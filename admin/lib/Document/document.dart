import 'dart:io';
import 'package:admin/Bloc/CategoriesBloc/categories_block.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_event.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_state.dart';
import 'package:admin/Bloc/EditDocument/edit_document_block.dart';
import 'package:admin/Bloc/EditDocument/edit_document_event.dart';
import 'package:admin/Bloc/EditDocument/edit_document_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/Document/TextBoxItem/paragraph_editor.dart';
import 'package:admin/Document/TextBoxItem/textbox.dart';
import 'package:admin/Document/add_document.dart';
import 'package:admin/Document/items.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/GeneralWidgets/upload_process.dart';
import 'package:admin/PageManager/pagemanager.dart';
import 'package:admin/paths.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../iconsax_icons.dart';
import 'DocumentModel.dart';

class Document extends StatefulWidget {
  Document({
    super.key,
    required this.documentBox,
    required this.document,
  });
  final Box<DocumentModel> documentBox;
  final DocumentModel document;
  @override
  State<Document> createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  GroupSubGroup groupSubGroup = GroupSubGroup(group: "", subGroup: "");
  PageManager pm = PageManager(audioPath: null, source: AudioSource.file);
  String curentAudioTitle = "";
  // -----------------------------------------------------------
  List<File> deletedFilePath = [];
  List<String> deletedFileName = [];
  List reorderItems_ = [];
  bool isReorderItems = false;
  List<Widget> buildItems(List body) {
    return [
      ...body.map((item) {
        if (item["type"] == "textbox") {
          return TextBoxBuilder(
            document: widget.document,
            textBox: item,
            textBoxIndex: body.indexOf(item),
            textSizeFactor: 1.0,
            clickable: !isReorderItems,
            reload: () {
              BlocProvider.of<EditDocumentBloc>(this.context).add(EditEvent());
            },
          );
        } else {
          if (item["type"] == "image") {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ImageItem(
                key: UniqueKey(),
                document: widget.document,
                itemIndex: body.indexOf(item),
                imageItem: item,
                isReorderItems: isReorderItems,
              ),
            );
          } else {
            return Container();
          }
        }
      })
    ];
  }

  Widget labels() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      direction: Axis.horizontal,
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        ...widget.document.labels.map(
                          (e) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: midWhite,
                                ),
                                child: Row(
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        e,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: black),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.document.labels.remove(e);
                                          widget.document.save();
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/close.svg",
                                        width: 20,
                                        height: 20,
                                        color: lightgray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                builder: (context) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: BlocProvider(
                                        create: (context) => EditDocumentBloc(),
                                        child: AddLabel(
                                          document: widget.document,
                                          oldLabelIndex: null,
                                        ),
                                      ));
                                }).then((value) {
                              BlocProvider.of<EditDocumentBloc>(this.context)
                                  .add(EditEvent());
                            });
                          },
                          child: SvgPicture.asset(
                            "assets/images/add.svg",
                            color: green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Column(
              children: [
                Text(
                  "برچسب ها",
                  style: TextStyle(
                      color: lightgray,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mainImageWidget({required bool change}) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: change
          ? () async {
              FilePickerResult? result = await FilePicker.platform
                  .pickFiles(type: FileType.custom, allowedExtensions: ["jpg"]);
              if (result != null) {
                File mainImage = File(
                    "${AppDataDirectory.documentPath(widget.document.name).path}/${widget.document.mainImage}");
                DateTime now = DateTime.now();
                String creationDate =
                    "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
                // Create File Name With Documnet Name And CreationDate
                // String newImageName = "${widget.document.name}_$creationDate.jpg";
                String newImageName = "$creationDate.jpg";
                // Find Image Path With NewImageName
                String newImagePath =
                    "${AppDataDirectory.documentPath(widget.document.name).path}/$newImageName";
                await File(result.files.single.path!).copy(newImagePath);
                if (await mainImage.exists()) {
                  await mainImage.delete();
                }
                widget.document.deletedFiles.add(widget.document.mainImage);
                widget.document.mainImage = newImageName;
                widget.document.save();

                setState(() {
                  imageCache.clear();
                  imageCache.clearLiveImages();
                });
              }
            }
          : null,
      child: Image.file(
        File(
            "${AppDataDirectory.documentPath(widget.document.name).path}/${widget.document.mainImage}"),
        key: UniqueKey(),
        errorBuilder: (context, error, stackTrace) => Container(
          color: midWhite,
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  Widget header({required bool isUploadInfo}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Material(
                    elevation: 4,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    shadowColor: Colors.white.withOpacity(0.5),
                    child: Container(
                      width: 200,
                      height: 160,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: mainImageWidget(change: !isUploadInfo),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: !isUploadInfo
                ? () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: AddDocument(
                              documentBox: widget.documentBox,
                              document: widget.document,
                            ),
                          );
                        }).then((value) {
                      BlocProvider.of<EditDocumentBloc>(this.context)
                          .add(EditEvent());
                    });
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      widget.document.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: const TextStyle(
                          color: black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Shabnam"
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                groupSubGroup.group == "" ? "گروه" : groupSubGroup.group,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff66728C),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                groupSubGroup.subGroup == ""
                    ? "زیرگروه"
                    : groupSubGroup.subGroup,
                style: const TextStyle(
                  color: Color(0xff66728C),
                  fontWeight: FontWeight.normal,
                  // fontSize: 10,
                ),
              ),
            ],
          ),
          Visibility(
            visible: !isUploadInfo,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                      activeColor: blue,
                      value: widget.document.isSubscription,
                      onChanged: (value) {
                        widget.document.isSubscription = value ?? false;
                        widget.document.save();
                        BlocProvider.of<EditDocumentBloc>(this.context)
                            .add(EditEvent());
                      },
                    ),
                    const Text("اشتراکی"),
                  ],
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () async {
                    await Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => CategoriesBloc(),
                          child: Grouping(document: widget.document),
                        ),
                      ),
                    )
                        .then((value) {
                      BlocProvider.of<EditDocumentBloc>(context).add(
                        InitEvent(
                          document: widget.document,
                          groupId: widget.document.category["Group"],
                          subGroupId: widget.document.category["SubGroup"],
                        ),
                      );
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: midWhite,
                    ),
                    child: const Text(
                      "دسته بندی",
                      style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.2,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        const SizedBox(height: 10),
        header(isUploadInfo: false),
        const SizedBox(height: 20),
        ...buildItems(widget.document.body),
        Visibility(
          visible: widget.document.body.isEmpty,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: const Column(
                        children: [
                          SizedBox(height: 20),
                          Column(
                            children: [
                              Text("!محتوای این سند خالی است",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 10),
                              Text(".هنوز هیچ آیتمی اضافه نشده است",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  )),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        labels(),
        const SizedBox(height: 80),
      ],
    );
  }

  // -----------------------------------------------------------
  void addTextBox() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => ParagraphEditor(
          document: widget.document,
        ),
      ),
    )
        .then((value) {
      BlocProvider.of<EditDocumentBloc>(this.context).add(EditEvent());
    });
  }

  void addImage() async {
    // Pick Image
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["jpg"]);
    if (result != null) {
      // Naming And Copying Image to Document Name Directory
      // Get Curent Date
      DateTime now = DateTime.now();
      String creationDate =
          "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
      // Create File Name With Documnet Name And CreationDate
      // String newImageName = "${widget.document.name}_$creationDate.jpg";
      String newImageName = "$creationDate.jpg";
      // Find Image Path With NewImageName
      String newImagePath =
          "${AppDataDirectory.documentPath(widget.document.name).path}/$newImageName";
      // Copying And Naming Image With NewImagePath
      File(result.files.single.path!).copy(newImagePath);
      widget.document.body.add({"type": "image", "name": newImageName});
      widget.document.save();
      BlocProvider.of<EditDocumentBloc>(this.context).add(EditEvent());
    }
  }

  Future<void> addAudio({Map? preAudio}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      // Create File Name With Documnet Name And CreationDate
      DateTime now = DateTime.now();
      String creationDate =
          "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
      String newAudioName = "$creationDate.mp3";
      // Find Image Path With NewImageName
      String newAudioPath =
          "${AppDataDirectory.documentPath(widget.document.name).path}/$newAudioName";
      // Copying And Naming Image With NewImagePath
      await File(result.files.single.path!).copy(newAudioPath);

      if (preAudio != null) {
        File oldFile = File(
            "${AppDataDirectory.documentPath(widget.document.name).path}/${preAudio['name']}");
        if (await oldFile.exists()) {
          await oldFile.delete();
          widget.document.deletedFiles.add(preAudio['name']);
        }
        widget.document.audios[widget.document.audios.indexWhere((element) =>
            element["title"] == preAudio["title"] &&
            element["name"] == preAudio['name'])] = {
          "title": preAudio["title"],
          "name": newAudioName,
        };
      } else {
        widget.document.audios.add({
          "title": "عنوان",
          "name": newAudioName,
        });
      }
      widget.document.save();
      BlocProvider.of<EditDocumentBloc>(this.context).add(EditEvent());
    }
  }

  // -----------------------------------------------------------

  Widget appBarActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                isReorderItems = !isReorderItems;
                reorderItems_ = List.of(widget.document.body);
              });
            },
            child: const Icon(
              Iconsax.repeat,
              color: black,
            ),
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  builder: (context) {
                    return AudioList(
                      document: widget.document,
                      pm: pm,
                      setAudio: (PageManager audio) async {
                        await pm.dispose();
                        pm = audio;
                      },
                    );
                  });
            },
            child: SvgPicture.asset(
              "assets/images/headphone.svg",
              color: black,
            ),
          ),
          TextButton(
            onPressed: () async {
              await pm.dispose();
              pm = PageManager(audioPath: null, source: AudioSource.file);
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => AudioListScreen(
                    document: widget.document,
                    addAudio: (Map preAudio) async {
                      await addAudio(preAudio: preAudio);
                    }),
              ))
                  .then((value) {
                BlocProvider.of<EditDocumentBloc>(this.context)
                    .add(EditEvent());
              });
            },
            child: const Icon(Iconsax.headphone, color: black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PopupMenuButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              itemBuilder: (context) {
                return <PopupMenuEntry<Object>>[
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/images/audio.svg",
                          color: black,
                        ),
                        const Text("فایل صوتی")
                      ],
                    ),
                    onTap: () async {
                      await Future(addAudio);
                    },
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/images/text-block.svg",
                          color: black,
                        ),
                        const Text("باکس متن"),
                      ],
                    ),
                    onTap: () async {
                      await Future(addTextBox);
                    },
                  ),
                  PopupMenuItem(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.photo_size_select_actual_rounded),
                        Text("عکس"),
                      ],
                    ),
                    onTap: () async {
                      await Future(addImage);
                    },
                  ),
                ];
              },
              child: SvgPicture.asset("assets/images/menu.svg"),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  Widget reorderItems() {
    List items = buildItems(reorderItems_);
    return ReorderableListView(
      children: [
        ...items.map(
          (e) => Container(
            key: UniqueKey(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (reorderItems_.elementAt(items.indexOf(e))["type"] ==
                            "image") {
                          File imagePath = File(
                              "${AppDataDirectory.documentPath(widget.document.name).path}/${reorderItems_[items.indexOf(e)]["name"]}");
                          if (await imagePath.exists()) {
                            deletedFileName
                                .add(reorderItems_[items.indexOf(e)]["name"]);
                            deletedFilePath.add(imagePath);
                          }
                        }
                        setState(() {
                          reorderItems_.removeAt(items.indexOf(e));
                        });
                      },
                      child: SvgPicture.asset(
                        "assets/images/close.svg",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                e
              ],
            ),
          ),
        )
      ],
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex--;
          }
          var old = reorderItems_.removeAt(oldIndex);
          reorderItems_.insert(newIndex, old);
        });
      },
    );
  }

  Widget reorderActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            style: TextButton.styleFrom(
              // backgroundColor: const silver,
              foregroundColor: black,
              minimumSize: const Size(80, 40),
              maximumSize: const Size(80, 40),
            ),
            onPressed: () {
              setState(() {
                isReorderItems = false;
              });
            },
            child: const Text("لغو")),
        const SizedBox(width: 40),
        TextButton(
            style: TextButton.styleFrom(
              // backgroundColor: const silver,
              foregroundColor: black,
              minimumSize: const Size(80, 40),
              maximumSize: const Size(80, 40),
            ),
            onPressed: () async {
              if (deletedFilePath.isNotEmpty) {
                for (File f in deletedFilePath) {
                  if (await f.exists()) {
                    await f.delete();
                  }
                }
              }
              for (String i in deletedFileName) {
                if (!widget.document.deletedFiles.contains(i)) {
                  widget.document.deletedFiles.add(i);
                }
              }
              setState(() {
                widget.document.body = reorderItems_;
                widget.document.save();
                isReorderItems = false;
              });
            },
            child: const Text("تایید")),
      ],
    );
  }

  @override
  void initState() {
    BlocProvider.of<EditDocumentBloc>(context).add(
      InitEvent(
        document: widget.document,
        groupId: widget.document.category["Group"],
        subGroupId: widget.document.category["SubGroup"],
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    () async {
      await pm.dispose();
    }();
  }

  Widget editScreen() {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              SliverVisibility(
                visible: !isReorderItems,
                sliver: SliverAppBar(
                  backgroundColor: Colors.white,
                  floating: true,
                  elevation: 2,
                  shadowColor: Colors.white.withOpacity(0.6),
                  foregroundColor: black,
                  leading: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Iconsax.arrow_left,
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  // alignment: Alignment.bottomCenter,
                                  backgroundColor: const Color(0xffF0F0F2),
                                  elevation: 2,
                                  content: const Text(
                                    "از حذف این سند اطمینان دارید؟",
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    const Color(0xff4BCB81),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("خیر")),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xff4BCB81),
                                              ),
                                              onPressed: () async {
                                                await widget.document.delete();
                                                List flist = AppDataDirectory
                                                        .documentPath(widget
                                                            .document.name)
                                                    .listSync();
                                                for (File f in flist) {
                                                  f.delete();
                                                }
                                                Directory documentFolder =
                                                    Directory(AppDataDirectory
                                                            .documentPath(widget
                                                                .document.name)
                                                        .path);
                                                await documentFolder.delete();
                                                Navigator.of(this.context)
                                                    .pop();
                                                Navigator.of(this.context)
                                                    .pop();
                                              },
                                              child: const Text("بله")),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text(
                              "حذف سند",
                              style: TextStyle(color: red),
                            ),
                          ),
                          const SizedBox(width: 20),
                          TextButton(
                            style: TextButton.styleFrom(
                              // padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(14),
                                ),
                                side: BorderSide(
                                  color: midBlue.withOpacity(0.4),
                                  strokeAlign: 1.4,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              BlocProvider.of<EditDocumentBloc>(context).add(
                                  InitUploadEvent(
                                      documentName: widget.document.name));
                            },
                            child: const Text(
                              "آپلود سند",
                              style: TextStyle(color: midBlue),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (isReorderItems)
                SliverFillRemaining(
                  child: reorderItems(),
                )
              else
                SliverToBoxAdapter(
                  child: content(),
                ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: midWhite,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: isReorderItems ? reorderActions() : appBarActions(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDocumentBloc, EditDocumentState>(
      builder: (context, state) => WillPopScope(
        onWillPop: () async {
          if (isReorderItems) {
            setState(() {
              isReorderItems = false;
            });
          } else {
            if (state is EditState ||
                state is LoadingState ||
                state is DocumentFirstState) {
              Navigator.of(context).pop();
            } else {
              BlocProvider.of<EditDocumentBloc>(this.context).add(EditEvent());
            }
          }

          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is InitUploadState) ...[
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        header(isUploadInfo: true),
                        const SizedBox(height: 50),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: LoadingRing(
                                    lineWidth: 1.5,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "در حال چک کردن نام سند",
                                  style: TextStyle(color: black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                if (state is ReadyUploadState) ...[
                  state.data.fold(
                      (l) => Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 100),
                                header(isUploadInfo: true),
                                const SizedBox(height: 50),
                                Expanded(
                                    child: UploadError(
                                  error: l,
                                  back: (() {
                                    BlocProvider.of<EditDocumentBloc>(
                                            this.context)
                                        .add(EditEvent());
                                  }),
                                  tryAgain: () async {
                                    BlocProvider.of<EditDocumentBloc>(
                                            this.context)
                                        .add(InitUploadEvent(
                                            documentName:
                                                widget.document.name));
                                  },
                                )),
                              ],
                            ),
                          ), (r) {
                    return Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          header(isUploadInfo: true),
                          const SizedBox(height: 50),
                          Expanded(
                            child: ExistName(
                              validNameTrue: "نام سند معتبر است",
                              validNameFalse: "نام سند از قبل موجود است",
                              exist: r,
                              upload: () {
                                BlocProvider.of<EditDocumentBloc>(this.context)
                                    .add(
                                        UploadEvent(document: widget.document));
                              },
                              back: () {
                                BlocProvider.of<EditDocumentBloc>(this.context)
                                    .add(EditEvent());
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                ],
                if (state is UploadState) ...[
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        header(isUploadInfo: true),
                        const SizedBox(height: 50),
                        Expanded(
                          child: UploadProgress(
                            uploadSuccessTitle: "سند با موفقیت آپلود شد",
                            title1: "آپلود سند",
                            title2: "آپلود فایل ها",
                            title3: "حذف فایل های قدیمی",
                            error: state.error,
                            uploadProgress: state.uploadProgress,
                            back: () {
                              BlocProvider.of<EditDocumentBloc>(this.context)
                                  .add(EditEvent());
                            },
                            tryAgain: () async {
                              BlocProvider.of<EditDocumentBloc>(this.context)
                                  .add(InitUploadEvent(
                                      documentName: widget.document.name));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (state is EditState) ...[
                  editScreen(),
                ],
                if (state is DocumentFirstState) ...[
                  state.groupSubGroup.fold((l) {
                    return Expanded(
                      child: NestedScrollView(
                        headerSliverBuilder: (context, innerBoxIsScrolled) => [
                          SliverAppBar(
                            backgroundColor: Colors.white,
                            floating: true,
                            elevation: 2,
                            shadowColor: Colors.white.withOpacity(0.6),
                            foregroundColor: black,
                            leading: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Iconsax.arrow_left,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Refresh(onRefresh: () {
                              BlocProvider.of<EditDocumentBloc>(context).add(
                                InitEvent(
                                  document: widget.document,
                                  groupId: widget.document.category["Group"],
                                  subGroupId:
                                      widget.document.category["SubGroup"],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }, (r) {
                    groupSubGroup.group = r.group;
                    groupSubGroup.subGroup = r.subGroup;
                    return editScreen();
                  })
                ],
                if (state is LoadingState) ...[
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverAppBar(
                          backgroundColor: Colors.white,
                          floating: true,
                          elevation: 2,
                          shadowColor: Colors.white.withOpacity(0.6),
                          foregroundColor: black,
                          leading: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Iconsax.arrow_left,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingRing(
                            color: Colors.black,
                            lineWidth: 1.5,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Grouping extends StatefulWidget {
  Grouping({
    super.key,
    required this.document,
  });
  final DocumentModel document;
  @override
  State<Grouping> createState() => _GroupingState();
}

class _GroupingState extends State<Grouping> {
  @override
  void initState() {
    BlocProvider.of<CategoriesBloc>(context).add(GetCategoriesData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white.withOpacity(0.5),
        foregroundColor: Colors.black,
        elevation: 2,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Iconsax.arrow_left,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.document.name,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) => Column(
            children: [
              if (state is CategoriesLoadingState) ...[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingRing(
                            lineWidth: 1.5,
                            size: 40,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (state is CategoriesDataState) ...[
                state.data.fold((l) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Refresh(onRefresh: () {
                              BlocProvider.of<CategoriesBloc>(context)
                                  .add(GetCategoriesData());
                            }),
                          ],
                        ),
                      ],
                    ),
                  );
                }, (r) {
                  List categories = r.categoriesList;
                  return Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 20),
                        ...categories.map((e) {
                          var subGroup = e["subgroups"];
                          if (subGroup.isEmpty) {
                            subGroup = {};
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                childrenPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                collapsedIconColor: black,
                                collapsedTextColor: black,
                                iconColor: midBlue,
                                textColor: midBlue,
                                title:
                                    Text(e["name"], textAlign: TextAlign.end),
                                children: [
                                  ...subGroup.keys.map((i) {
                                    return ListTile(
                                      title: Text(
                                        subGroup[i],
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(color: midBlue),
                                      ),
                                      onTap: () {
                                        widget.document.category = {
                                          "Group": e["id"],
                                          "SubGroup": i
                                        };
                                        widget.document.save();
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }).toList()
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                })
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class AddLabel extends StatefulWidget {
  AddLabel({
    super.key,
    required this.document,
    required this.oldLabelIndex,
  });
  final DocumentModel document;
  final int? oldLabelIndex;
  @override
  State<AddLabel> createState() => _AddLabelState();
}

class _AddLabelState extends State<AddLabel> {
  TextEditingController labelName = TextEditingController();
  FocusNode fNode = FocusNode();
  bool validName = false;
  String? errorText;
  @override
  void initState() {
    if (widget.oldLabelIndex != null) {
      labelName.text = widget.document.labels[widget.oldLabelIndex!];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
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
                      backgroundColor: const Color(0xff7DABF6),
                      shape: const CircleBorder(side: BorderSide.none),
                    ),
                    onPressed: validName
                        ? () {
                            if (widget.oldLabelIndex == null) {
                              widget.document.labels.add(labelName.text);
                              widget.document.save();
                            } else {
                              widget.document.labels[widget.oldLabelIndex!] =
                                  labelName.text;
                              widget.document.save();
                            }
                            Navigator.of(context).pop();
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
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(color: lightgray),
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: labelName,
                      textDirection: TextDirection.rtl,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintTextDirection: TextDirection.rtl,
                        focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        hintText: "نام برچسب",
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

  String? error(String name) {
    if (name.isEmpty) {
      validName = false;
      return null;
    } else {
      if (!widget.document.labels.contains(name.replaceAll(" ", ""))) {
        validName = true;
        return null;
      } else {
        validName = false;
        return "این زیر گروه وحود دارد!";
      }
    }
  }
}

class AudioTitle extends StatefulWidget {
  AudioTitle({
    super.key,
    required this.document,
    required this.name,
  });
  final DocumentModel document;

  final String name;
  @override
  State<AudioTitle> createState() => _AudioTitleState();
}

class _AudioTitleState extends State<AudioTitle> {
  TextEditingController labelName = TextEditingController();
  FocusNode fNode = FocusNode();
  bool validName = false;
  String? errorText;

  List<String> titles = [];
  @override
  void initState() {
    for (Map audio in widget.document.audios) {
      titles.add(audio["title"]);
    }
    labelName.text = widget.document.audios[widget.document.audios
        .indexWhere((element) => element["name"] == widget.name)]["title"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
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
                      backgroundColor: const Color(0xff7DABF6),
                      shape: const CircleBorder(side: BorderSide.none),
                    ),
                    onPressed: validName
                        ? () {
                            widget.document.audios[widget.document.audios
                                    .indexWhere((element) =>
                                        element["name"] == widget.name)]
                                ["title"] = labelName.text;
                            widget.document.save();
                            // BlocProvider.of<EditDocumentBloc>(widget.ctx)
                            //     .add(EditEvent());
                            Navigator.of(context).pop();
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
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(color: lightgray),
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: labelName,
                      textDirection: TextDirection.rtl,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintTextDirection: TextDirection.rtl,
                        focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        hintText: "نام برچسب",
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

  String? error(String name) {
    if (name.isEmpty) {
      validName = false;
      return null;
    } else {
      if (!titles.contains(name.replaceAll(" ", ""))) {
        validName = true;
        return null;
      } else {
        validName = false;
        return "این زیر گروه وحود دارد!";
      }
    }
  }
}

class AudioList extends StatefulWidget {
  AudioList({
    super.key,
    required this.document,
    required this.pm,
    required this.setAudio,
  });
  final DocumentModel document;
  final Function(PageManager newPm) setAudio;
  final PageManager pm;
  @override
  State<AudioList> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList> {
  Map size = {
    0: 0.2,
    1: 0.22,
    2: 0.3,
    3: 0.36,
    4: 0.44,
    5: 0.52,
    6: 0.6,
  };

  PageManager pm = PageManager(audioPath: null, source: AudioSource.file);

  @override
  void initState() {
    super.initState();

    () async {
      await pm.dispose();
    }();
    pm = widget.pm;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.document.audios.length > 6
          ? MediaQuery.of(context).size.height * 0.6
          : MediaQuery.of(context).size.height *
              size[widget.document.audios.length],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("فهرست فایل های صوتی"),
                  ],
                ),
              ),
              musicPlayer(),
            ],
          ),
          if (widget.document.audios.isEmpty) ...[
            const Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("!لیست فایل های صوتی خالی است"),
                  ],
                ),
              ],
            ),
          ],
          if (widget.document.audios.length <= 6) ...[
            ...widget.document.audios.map((e) {
              String audioName = e["name"];
              String audioPath =
                  "${AppDataDirectory.documentPath(widget.document.name).path}/$audioName";
              PageManager newPm =
                  PageManager(audioPath: audioPath, source: AudioSource.file);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  children: [
                    audioItem(e["title"], widget.document.audios.indexOf(e),
                        newPm, e["name"]),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: widget.document.audios.last != e,
                      child: Container(
                        width: double.infinity,
                        height: 0.5,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          if (widget.document.audios.length > 6) ...[
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  ...widget.document.audios.map((e) {
                    String audioName = e["name"];
                    String audioPath =
                        "${AppDataDirectory.documentPath(widget.document.name).path}/$audioName";
                    PageManager newPm = PageManager(
                        audioPath: audioPath, source: AudioSource.file);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      child: Column(
                        children: [
                          audioItem(
                              e["title"],
                              widget.document.audios.indexOf(e),
                              newPm,
                              e["name"]),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: widget.document.audios.last != e,
                            child: Container(
                              width: double.infinity,
                              height: 0.5,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget audioItem(String title, int index, PageManager audio, String name) {
    return Container(
      decoration: BoxDecoration(
        color: pm.p == audio.p ? const Color(0xffECEEF4) : Colors.transparent,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: () async {
          if (pm.p != audio.p) {
            await pm.dispose();
            setState(() {
              widget.setAudio(audio);
              pm = audio;
              pm.play();
            });
          }
        },
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Iconsax.clock, size: 18, color: lightgray),
                      ),
                      const SizedBox(width: 6),
                      ValueListenableBuilder(
                        valueListenable: audio.progressNotifier,
                        builder: (context, value, child) => Text(
                          "${(value.total.inSeconds / 60).floor()}:${(value.total.inSeconds % 60).floor() < 10 ? 0 : ''}${(value.total.inSeconds % 60).floor()}",
                          style: const TextStyle(color: black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: black,
                                fontSize: 12,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text((index + 1).toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget musicPlayer() {
    return SizedBox(
      // height: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<ProgressBarState>(
            valueListenable: pm.progressNotifier,
            builder: (context, value, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: green,
                        inactiveTrackColor: silver,
                        disabledInactiveTrackColor: silver,
                        disabledActiveTrackColor: silver,
                        disabledThumbColor: green,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 4,
                            elevation: 0,
                            pressedElevation: 0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 20),
                        trackHeight: 1,
                      ),
                      child: Slider(
                        // min: 0,
                        max: value.total.inSeconds.toDouble(),
                        value: value.position.inSeconds.toDouble(),
                        thumbColor: green,
                        activeColor: green,

                        onChanged: (value) async {
                          await pm.player
                              .seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: Text(
                              "${(value.position.inSeconds / 60).floor()}:${(value.position.inSeconds % 60).floor() < 10 ? 0 : ''}${(value.position.inSeconds % 60).floor()}",
                              style: const TextStyle(
                                color: black,
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: pm.isLoaded,
                          builder: (context, value, child) => value
                              ? ValueListenableBuilder<AudioState>(
                                  valueListenable: pm.buttonNotifier,
                                  builder: (context, value, child) {
                                    switch (value) {
                                      case AudioState.paused:
                                        return TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () {
                                            pm.play();
                                          },
                                          child: const Icon(
                                            Iconsax.play4,
                                            color: green,
                                          ),
                                        );
                                      case AudioState.playing:
                                        return TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () {
                                            pm.pause();
                                          },
                                          child: const Icon(
                                            Iconsax.pause4,
                                            color: green,
                                          ),
                                        );
                                    }
                                  },
                                )
                              : LoadingRing(),
                        ),
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: Text(
                              "${(value.total.inSeconds / 60).floor()}:${(value.total.inSeconds % 60).floor() < 10 ? 0 : ''}${(value.total.inSeconds % 60).floor()}",
                              style: const TextStyle(color: black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class AudioListScreen extends StatefulWidget {
  AudioListScreen({super.key, required this.document, required this.addAudio});
  final DocumentModel document;
  final Function(Map preAudio) addAudio;
  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  PageManager pm = PageManager(audioPath: null, source: AudioSource.file);

  bool reorder = false;
  @override
  void dispose() {
    super.dispose();

    () async {
      await pm.dispose();
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          foregroundColor: black,
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    reorder = !reorder;
                  });
                },
                child: const Icon(
                  Iconsax.repeat,
                  color: black,
                )),
          ]),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            musicPlayer(),
            if (!reorder)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...widget.document.audios.map((e) {
                        String audioName = e["name"];
                        String audioPath =
                            "${AppDataDirectory.documentPath(widget.document.name).path}/$audioName";
                        PageManager newPm = PageManager(
                            audioPath: audioPath, source: AudioSource.file);
                        return Padding(
                          key: UniqueKey(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              audioItem(e["title"], newPm, e["name"]),
                              const Divider(),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }
                      var old = widget.document.audios.removeAt(oldIndex);
                      widget.document.audios.insert(newIndex, old);
                    });
                  },
                  children: [
                    ...widget.document.audios.map((e) {
                      String audioName = e["name"];
                      String audioPath =
                          "${AppDataDirectory.documentPath(widget.document.name).path}/$audioName";
                      PageManager newPm = PageManager(
                          audioPath: audioPath, source: AudioSource.file);
                      return Padding(
                        key: UniqueKey(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            audioItem(e["title"], newPm, e["name"]),
                            const Divider(),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget audioItem(String title, PageManager audio, String name) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Icon(Iconsax.clock, size: 22, color: lightgray),
                ),
                const SizedBox(width: 6),
                ValueListenableBuilder(
                  valueListenable: audio.progressNotifier,
                  builder: (context, value, child) => Text(
                    "${(value.total.inSeconds / 60).floor()}:${(value.total.inSeconds % 60).floor() < 10 ? 0 : ''}${(value.total.inSeconds % 60).floor()}",
                    style: const TextStyle(color: black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TextButton(
                onPressed: reorder
                    ? null
                    : () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: AudioTitle(
                                  document: widget.document,
                                  name: name,
                                ),
                              );
                            }).then((value) {
                          setState(() {});
                        });
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: black,
                            fontSize: 12,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: !reorder,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await widget.addAudio({"title": title, "name": name});
                  setState(() {});
                },
                child: SvgPicture.asset(
                  "assets/images/replace_items.svg",
                  color: black,
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AlertDialog(
                      // alignment: Alignment.bottomCenter,
                      backgroundColor: const Color(0xffF0F0F2),
                      elevation: 2,
                      content: const Text(
                        "از حذف این فایل صوتی اطمینان دارید؟",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xff4BCB81),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("خیر")),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff4BCB81),
                                  ),
                                  onPressed: () async {
                                    File oldFile = File(
                                        "${AppDataDirectory.documentPath(widget.document.name).path}/$name");
                                    if (await oldFile.exists()) {
                                      await oldFile.delete();
                                      widget.document.deletedFiles.add(name);
                                    }
                                    widget.document.audios.removeWhere(
                                        (element) =>
                                            element["title"] == title &&
                                            element["name"] == name);
                                    widget.document.save();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("بله")),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: const Icon(
                  Iconsax.trash,
                  color: black,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  if (pm.p != audio.p) {
                    pm.dispose();
                    setState(() {
                      pm = audio;
                    });
                  }
                },
                child: const Icon(
                  Iconsax.play4,
                  color: green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget musicPlayer() {
    return SizedBox(
      // height: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<ProgressBarState>(
            valueListenable: pm.progressNotifier,
            builder: (context, value, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: green,
                        inactiveTrackColor: silver,
                        disabledInactiveTrackColor: silver,
                        disabledActiveTrackColor: silver,
                        disabledThumbColor: green,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 4,
                            elevation: 0,
                            pressedElevation: 0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 20),
                        trackHeight: 1,
                      ),
                      child: Slider(
                        // min: 0,
                        max: value.total.inSeconds.toDouble(),
                        value: value.position.inSeconds.toDouble(),
                        thumbColor: green,
                        activeColor: green,

                        onChanged: (value) async {
                          await pm.player
                              .seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: Text(
                              "${(value.position.inSeconds / 60).floor()}:${(value.position.inSeconds % 60).floor() < 10 ? 0 : ''}${(value.position.inSeconds % 60).floor()}",
                              style: const TextStyle(
                                color: black,
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: pm.isLoaded,
                          builder: (context, value, child) => value
                              ? ValueListenableBuilder<AudioState>(
                                  valueListenable: pm.buttonNotifier,
                                  builder: (context, value, child) {
                                    switch (value) {
                                      case AudioState.paused:
                                        return TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () {
                                            pm.play();
                                          },
                                          child: const Icon(
                                            Iconsax.play4,
                                            color: green,
                                          ),
                                        );
                                      case AudioState.playing:
                                        return TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () {
                                            pm.pause();
                                          },
                                          child: const Icon(
                                            Iconsax.pause4,
                                            color: green,
                                          ),
                                        );
                                    }
                                  },
                                )
                              : LoadingRing(),
                        ),
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: Text(
                              "${(value.total.inSeconds / 60).floor()}:${(value.total.inSeconds % 60).floor() < 10 ? 0 : ''}${(value.total.inSeconds % 60).floor()}",
                              style: const TextStyle(color: black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
