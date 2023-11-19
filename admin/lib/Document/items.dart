import 'package:admin/Document/DocumentModel.dart';
import 'package:admin/paths.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImageItem extends StatefulWidget {
  ImageItem(
      {super.key,
      required this.document,
      required this.itemIndex,
      required this.imageItem,
      required this.isReorderItems});
  final DocumentModel document;
  final int itemIndex;
  final Map imageItem;
  final bool isReorderItems;
  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  File? image;
  bool exist = false;
  @override
  void initState() {
    super.initState();
    image = File(
        "${AppDataDirectory.documentPath(widget.document.name).path}/${widget.imageItem['name']}");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: !widget.isReorderItems
            ? () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ["jpg"]);
                if (result != null) {
                  DateTime now = DateTime.now();
                  String creationDate =
                      "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
                  String newImageName = "$creationDate.jpg";
                  String newImagePath =
                      "${AppDataDirectory.documentPath(widget.document.name).path}/$newImageName";
                  await File(result.files.single.path!).copy(newImagePath);
                  widget.document.deletedFiles.add(widget.imageItem["name"]);
                  widget.document.body[widget.itemIndex]["name"] = newImageName;
                  await image!.delete();
                  image = File(newImagePath);
                  widget.document.save();
                }
                setState(() {
                  imageCache.clear();
                  imageCache.clearLiveImages();
                });
              }
            : null,
        child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.file(
                  File(
                      "${AppDataDirectory.documentPath(widget.document.name).path}/${widget.imageItem['name']}"),
                  key: UniqueKey(),
                  errorBuilder: (context, error, stackTrace) =>
                      const Text("عکس موجود نیست"),
                ),
              ),
            )));
  }
}
