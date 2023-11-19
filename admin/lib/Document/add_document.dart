import 'dart:io';

import 'package:admin/Constants/colors.dart';
import 'package:admin/paths.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'DocumentModel.dart';

class AddDocument extends StatefulWidget {
  AddDocument({
    super.key,
    required this.documentBox,
    this.document,
  });
  final Box<DocumentModel> documentBox;
  final DocumentModel? document;
  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  TextEditingController newdocumentName = TextEditingController();
  FocusNode fNode = FocusNode();
  bool validName = false;
  String? errorText;
  List documentsNameList = [];

  @override
  void initState() {
    documentsNameList = widget.documentBox.keys
        .map((e) => widget.documentBox.get(e)!.name.replaceAll(" ", ""))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff65BF3F),
                      shape: const CircleBorder(side: BorderSide.none),
                    ),
                    onPressed: validName
                        ? () async {
                            addNewDocumen(newdocumentName.text);
                          }
                        : null,
                    child: const Icon(
                      Icons.keyboard_arrow_left_rounded,
                      size: 40,
                      color: Colors.white,
                    )),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Color(int.parse("0xff${theme['boldcolor']}")),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(color: lightgray),
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: newdocumentName,
                      textDirection: TextDirection.rtl,
                      maxLines: null,
                      decoration: InputDecoration(
                        // errorText: errorText,
                        // errorBorder: InputBorder.none,
                        // focusedErrorBorder: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                        focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        hintText: "نام سند",
                        labelStyle: TextStyle(
                            color: fNode.hasFocus ? Colors.blue : Colors.white,
                            fontSize: 15),
                      ),
                      onChanged: (value) {
                        setState(() {
                          errorText = error(value);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // documentColor(),
          errorText != null
              ? Text(errorText!, textDirection: TextDirection.rtl)
              : Container()
        ],
      ),
    );
  }

  String? error(String documentName) {
    if (documentName.isEmpty) {
      validName = false;
      return null;
    } else {
      if (!documentsNameList.contains(documentName.replaceAll(" ", ""))) {
        validName = true;

        return null;
      } else {
        validName = false;
        return "سندی با این نام وجود دارد!";
      }
    }
  }

  void addNewDocumen(String newDocumenName) async {
    if (widget.document == null) {
      // Cleen Name
      List<String> name = newDocumenName.split(" ");
      List cleaned = [];
      for (var i in name) {
        if (i != "") {
          cleaned.add(i);
        }
      }
      String documentName = cleaned.join(" ");
      // Get CreationDate
      DateTime now = DateTime.now();
      String creationDate = "${now.year}/${now.month}/${now.day}";
      // Create New Document
      widget.documentBox
          .add(DocumentModel(name: documentName, creationDate: creationDate));
      // Create Media Folders
      if (await AppDataDirectory.documents().exists()) {
        await Directory('${AppDataDirectory.documents().path}/$documentName')
            .create(recursive: true);
      }
    }
    if (widget.document != null) {
      Directory dir =
          Directory(AppDataDirectory.documentPath(widget.document!.name).path);
      await dir.rename(AppDataDirectory.documentPath(newDocumenName).path);
      widget.document!.name = newDocumenName;
      widget.document!.save();
    }
    Navigator.of(context).pop();
  }
}
