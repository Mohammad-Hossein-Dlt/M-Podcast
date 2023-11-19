import 'package:admin/Bloc/EditDocument/edit_document_block.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/Document/add_document.dart';
import 'package:admin/Document/document.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:admin/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'DocumentModel.dart';

class DocumentsList extends StatefulWidget {
  const DocumentsList({super.key});
  @override
  State<DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends State<DocumentsList> {
  Box<DocumentModel> documentBox = Hive.box<DocumentModel>("Documents");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("اسناد"),
        centerTitle: true,
        elevation: 2.5,
        shadowColor: Colors.white.withOpacity(0.5),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        leading: TextButton(
          child: Icon(Iconsax.arrow_left, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: FloatingActionButton(
          heroTag: "documentslist",
          autofocus: false,
          backgroundColor: green,
          child: SvgPicture.asset(
            "assets/images/document-add.svg",
            color: Colors.white,
          ),
          onPressed: () {
            addDocument();
          },
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: documentBox.listenable(),
          builder: (context, value, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    direction: Axis.horizontal,
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      ...documentBox.values
                          .map(
                            (e) => Container(
                              width: MediaQuery.of(context).size.width / 2 - 10,
                              height: 210,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                // color: midWhite,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => EditDocumentBloc(),
                                        child: Document(
                                          documentBox: documentBox,
                                          document: e,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Material(
                                      elevation: 4,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      shadowColor:
                                          Colors.white.withOpacity(0.5),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                10,
                                        height: 160,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Image.file(
                                              File(
                                                  "${AppDataDirectory.documentPath(e.name).path}/${e.mainImage}"),
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                width: 160,
                                                height: 160,
                                                color: const Color(0xffFAFAFA),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                e.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 10,
                        height: 210,
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void addDocument() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: AddDocument(documentBox: documentBox));
        });
  }
}
