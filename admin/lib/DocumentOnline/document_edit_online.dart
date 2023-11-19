import 'dart:io';
import 'package:admin/Bloc/CategoriesBloc/categories_block.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_event.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_state.dart';
import 'package:admin/Bloc/DocumentBloc/document_block.dart';
import 'package:admin/Bloc/DocumentBloc/document_event.dart';
import 'package:admin/Bloc/DocumentBloc/document_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/DocumentOnline/TextBoxItem/paragraph_editor.dart';
import 'package:admin/DocumentOnline/TextBoxItem/textbox.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/GeneralWidgets/upload_process.dart';
import 'package:admin/PageManager/pagemanager.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:admin/paths.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DocumentEditor extends StatefulWidget {
  DocumentEditor({super.key, required this.id});
  final int id;
  @override
  State<DocumentEditor> createState() => _DocumentEditorState();
}

class _DocumentEditorState extends State<DocumentEditor> {
  EditDocumentDataModel document = EditDocumentDataModel(
    newName: "",
    name: "",
    id: 0,
    mainimage: "",
    body: [],
    isSubscription: false,
    labels: [],
    groupId: "",
    subGroupId: "",
    group: "",
    subGroup: "",
    audioList: [],
  );
  GroupSubGroup groupSubGroup = GroupSubGroup(group: "", subGroup: "");

  List newImages = [];
  // -----------------------------------------------------------
  String audio = "";
  PageManager pm = PageManager(audioPath: null, source: AudioSource.url);
  List<Map<String, Map<String, PageManager>>> audioList = [];

  bool loaded = false;
  // -----------------------------------------------------------
  List<File> deletedFilePath = [];
  List<String> deletedFileName = [];
  List reorderItems_ = [];
  ValueNotifier<bool> isReorderItems = ValueNotifier<bool>(false);
  List<Widget> buildItems(List body) {
    return [
      ...body.map((item) {
        if (item["type"] == "textbox") {
          return TextBoxBuilder(
            reload: () {
              BlocProvider.of<DocumentOnlineBloc>(this.context)
                  .add(InitDocumentEditEvent());
            },
            document: document,
            textBox: item,
            textBoxIndex: body.indexOf(item),
            textSizeFactor: 1.0,
            clickable: !isReorderItems.value,
          );
        } else {
          if (item["type"] == "image") {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child:
                  image(name: item["name"], index: document.body.indexOf(item)),
            );
          } else {
            return Container();
          }
        }
      })
    ];
  }

  Widget image({required String name, int? index, bool isHeaderChange = true}) {
    String imagePath = "${AppDataDirectory.documentOnlineEdit().path}/$name";
    return Container(
      key: UniqueKey(),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: isHeaderChange
            ? () async {
                // Pick Image
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ["jpg"]);
                if (result != null) {
                  document.deletedFiles.add(name);
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
                      "${AppDataDirectory.documentOnlineEdit().path}/$newImageName";
                  // Copying And Naming Image With NewImagePath
                  File(result.files.single.path!).copy(newImagePath);
                  if (index != null) {
                    document.body[index] = {
                      "type": "image",
                      "name": newImageName
                    };
                  } else {
                    document.mainimage = newImageName;
                  }
                  newImages.add(newImageName);
                  File prevImage = File(imagePath);
                  if (await prevImage.exists()) {
                    prevImage.delete();
                  }

                  imageCache.clear();
                  imageCache.clearLiveImages();
                  // DefaultCacheManager().emptyCache();
                  BlocProvider.of<DocumentOnlineBloc>(this.context)
                      .add(InitDocumentEditEvent());
                }
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
                child: newImages.contains(name)
                    ? Image.file(File(imagePath))
                    : CachedNetworkImage(
                        imageUrl:
                            "https://mhdlt.ir/DocumentsData/${document.name}/$name",
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xffF4F4F4),
                          width: 100,
                          height: 100,
                        ),
                        placeholder: (context, url) => Container(
                          color: const Color(0xffF4F4F4),
                          width: 100,
                          height: 100,
                        ),
                      )),
          ),
        ),
      ),
    );
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
                        ...document.labels.map(
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
                                        document.labels.remove(e);
                                        BlocProvider.of<DocumentOnlineBloc>(
                                                this.context)
                                            .add(InitDocumentEditEvent());
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
                                      child: AddLabel(
                                        labels: document.labels,
                                        oldLabelIndex: null,
                                      ));
                                }).then((value) {
                              BlocProvider.of<DocumentOnlineBloc>(this.context)
                                  .add(InitDocumentEditEvent());
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
                    elevation: 6,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    shadowColor: white,
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
                          child: image(
                              name: document.mainimage,
                              isHeaderChange: !isUploadInfo),
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
                            child: RenameDocument(
                              document: document,
                            ),
                          );
                        }).then((value) {
                      BlocProvider.of<DocumentOnlineBloc>(this.context)
                          .add(InitDocumentEditEvent());
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
                      document.newName,
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
                      value: document.isSubscription,
                      onChanged: (value) {
                        document.isSubscription = value ?? false;

                        BlocProvider.of<DocumentOnlineBloc>(this.context)
                            .add(InitDocumentEditEvent());
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
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => CategoriesBloc(),
                          child: Grouping(
                            documentModelEdit: document,
                          ),
                        ),
                      ),
                    )
                        .then((value) {
                      BlocProvider.of<DocumentOnlineBloc>(this.context).add(
                          GetGroupSubGroupByIdEvent(
                              groupId: document.groupId,
                              subGroupId: document.subGroupId));
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
        ...buildItems(document.body),
        const SizedBox(height: 30),
        labels(),
        const SizedBox(height: 100),
      ],
    );
  }

  // -----------------------------------------------------------
  void addTextBox() async {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => DocumentOnlineBloc(),
          child: ParagraphEditor(
            document: document,
          ),
        ),
      ),
    )
        .then((value) {
      BlocProvider.of<DocumentOnlineBloc>(this.context)
          .add(InitDocumentEditEvent());
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
          "${AppDataDirectory.documentOnlineEdit().path}/$newImageName";
      // Copying And Naming Image With NewImagePath
      File(result.files.single.path!).copy(newImagePath);
      document.body.add({"type": "image", "name": newImageName});
      newImages.add(newImageName);
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
          "${AppDataDirectory.documentOnlineEdit().path}/$newAudioName";
      // Copying And Naming Image With NewImagePath
      await File(result.files.single.path!).copy(newAudioPath);

      if (preAudio != null) {
        File oldFile = File(
            "${AppDataDirectory.documentOnlineEdit().path}/${preAudio['name']}");

        if (await oldFile.exists()) {
          await oldFile.delete();
          document.deletedFiles.add(preAudio['name']);
        }
        document.audioList[document.audioList.indexWhere((element) =>
            element["title"] == preAudio["title"] &&
            element["name"] == preAudio['name'])] = {
          "title": preAudio["title"],
          "name": newAudioName,
        };
        String audioPath =
            "${AppDataDirectory.documentOnlineEdit().path}/$newAudioName";
        PageManager newPm =
            PageManager(audioPath: audioPath, source: AudioSource.file);
        audioList[audioList.indexWhere((element) =>
            element[element.keys.first]!.keys.first == preAudio['name'])] = {
          preAudio["title"]: {newAudioName: newPm},
        };

        document.deletedFiles.add(preAudio['name']);
      } else {
        document.audioList.add({
          "title": "عنوان",
          "name": newAudioName,
        });

        String audioPath =
            "${AppDataDirectory.documentOnlineEdit().path}/$newAudioName";
        PageManager newPm =
            PageManager(audioPath: audioPath, source: AudioSource.file);
        audioList.add({
          "عنوان": {newAudioName: newPm}
        });
      }
      // await pm.dispose();
      // pm = PageManager(audioPath: newAudioPath, source: AudioSource.file);
      BlocProvider.of<DocumentOnlineBloc>(this.context)
          .add(InitDocumentEditEvent());
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
                isReorderItems.value = !isReorderItems.value;
                reorderItems_ = List.of(document.body);
              });
            },
            child: SvgPicture.asset(
              "assets/images/replace_items.svg",
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
                    return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: AudioListOnline(
                            audioList: audioList,
                            pm: pm,
                            setAudio: (PageManager audio) async {
                              pm.pause();
                              pm = audio;
                            }));
                  });
            },
            child: SvgPicture.asset(
              "assets/images/headphone.svg",
              color: black,
            ),
          ),
          TextButton(
            onPressed: () async {
              pm.pause();
              pm = PageManager(audioPath: "", source: AudioSource.url);
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => AudioListScreen(
                    document: document,
                    audioList: audioList,
                    addAudio: (Map preAudio) async {
                      await addAudio(preAudio: preAudio);
                    }),
              ))
                  .then((value) {
                BlocProvider.of<DocumentOnlineBloc>(this.context)
                    .add(InitDocumentEditEvent());
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
                      BlocProvider.of<DocumentOnlineBloc>(this.context)
                          .add(InitDocumentEditEvent());
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
                      BlocProvider.of<DocumentOnlineBloc>(this.context)
                          .add(InitDocumentEditEvent());
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: ReorderableListView(
        buildDefaultDragHandles: true,
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
                          if (reorderItems_
                                  .elementAt(items.indexOf(e))["type"] ==
                              "image") {
                            File imagePath = File(
                                "${AppDataDirectory.documentOnlineEdit().path}/${reorderItems_[items.indexOf(e)]["name"]}");
                            deletedFilePath.add(imagePath);
                            deletedFileName
                                .add(reorderItems_[items.indexOf(e)]["name"]);
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
      ),
    );
  }

  Widget reorderActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: black,
            ),
            onPressed: () {
              isReorderItems.value = !isReorderItems.value;
            },
            child: const Text("لغو")),
        const SizedBox(width: 40),
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: black,
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
                if (!document.deletedFiles.contains(i)) {
                  document.deletedFiles.add(i);
                }
              }
              document.body = reorderItems_;
              isReorderItems.value = !isReorderItems.value;
            },
            child: const Text("تایید")),
      ],
    );
  }

  @override
  void initState() {
    List flist = AppDataDirectory.documentOnlineEdit().listSync();
    for (File f in flist) {
      f.delete();
    }
    BlocProvider.of<DocumentOnlineBloc>(context)
        .add(GetDocumentToEditEvent(id: widget.id));

    super.initState();
  }

  @override
  void dispose() {
    List flist = AppDataDirectory.documentOnlineEdit().listSync();
    for (File f in flist) {
      f.delete();
    }
    super.dispose();
    () async {
      pm.dispose();
    }();
  }

  Widget editScreen() {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              ValueListenableBuilder(
                valueListenable: isReorderItems,
                builder: (context, value, child) => SliverVisibility(
                  visible: !value,
                  sliver: SliverAppBar(
                    backgroundColor: Colors.white,
                    shadowColor: Colors.white,
                    elevation: 2,
                    floating: true,
                    foregroundColor: black,
                    leadingWidth: 80,
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
                                BlocProvider.of<DocumentOnlineBloc>(
                                        this.context)
                                    .add(OnlineInitUploadEvent(
                                        name: document.newName));
                              },
                              child: const Text(
                                "آپلود سند",
                                style: TextStyle(color: midBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: isReorderItems,
                builder: (context, value, child) => value
                    ? SliverFillRemaining(
                        child: reorderItems(),
                      )
                    : SliverToBoxAdapter(
                        child: content(),
                      ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: isReorderItems,
            builder: (context, isReorder_, child) => Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                shadowColor: white,
                elevation: 2,
                child: Container(
                  // padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: isReorder_ ? reorderActions() : appBarActions(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentOnlineBloc, DocumentOnlineState>(
      builder: (context, state) => WillPopScope(
        onWillPop: () async {
          if (isReorderItems.value) {
            isReorderItems.value = false;
          } else {
            if (state is DocumentLoadingState ||
                state is DocumentEditDefaultState ||
                state is DocumentEditState ||
                state is LoadingGroupSubGroupState ||
                state is GroupSubGroupDataState) {
              Navigator.of(context).pop();
            } else {
              BlocProvider.of<DocumentOnlineBloc>(this.context)
                  .add(InitDocumentEditEvent());
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
                if (state is DocumentLoadingState) ...[
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
                if (state is LoadingGroupSubGroupState) ...[
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
                if (state is GroupSubGroupDataState) ...[
                  state.groupSubGroup.fold((l) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Refresh(onRefresh: () {
                          BlocProvider.of<DocumentOnlineBloc>(this.context).add(
                              GetGroupSubGroupByIdEvent(
                                  groupId: document.group,
                                  subGroupId: document.subGroup));
                        }),
                      ],
                    );
                  }, (r) {
                    groupSubGroup =
                        GroupSubGroup(group: r.group, subGroup: r.subGroup);

                    return editScreen();
                  }),
                ],
                if (state is DocumentEditState) ...[
                  state.data.fold((l) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Refresh(onRefresh: () {
                          BlocProvider.of<DocumentOnlineBloc>(context)
                              .add(GetDocumentToEditEvent(id: widget.id));
                        }),
                      ],
                    );
                  }, (r) {
                    if (!loaded) {
                      document = r;
                      groupSubGroup.group = r.group;
                      groupSubGroup.subGroup = r.subGroup;
                      List preAudioNames = [];
                      for (Map<String, Map> audio in audioList) {
                        preAudioNames.add(audio[audio.keys.first]!.keys.first);
                      }
                      for (Map audio in r.audioList) {
                        String audioName = audio["name"];
                        if (!preAudioNames.contains(audioName)) {
                          String audioPath =
                              "https://mhdlt.ir/DocumentsData/${r.name}/$audioName";
                          PageManager newPm = PageManager(
                              audioPath: audioPath, source: AudioSource.url);
                          audioList.add({
                            audio["title"]: {audio["name"]: newPm}
                          });
                        }
                      }
                      loaded = true;
                    }
                    return editScreen();
                  }),
                ],
                if (state is DocumentEditDefaultState) ...[
                  editScreen(),
                ],
                if (state is OnlineInitUploadState) ...[
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
                if (state is OnlineReadyUploadState) ...[
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
                                    BlocProvider.of<DocumentOnlineBloc>(
                                            this.context)
                                        .add(InitDocumentEditEvent());
                                  }),
                                  tryAgain: () async {
                                    BlocProvider.of<DocumentOnlineBloc>(
                                            this.context)
                                        .add(OnlineInitUploadEvent(
                                            name: document.newName));
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
                                BlocProvider.of<DocumentOnlineBloc>(
                                        this.context)
                                    .add(OnlineUploadEvent(
                                  document: document,
                                  newName: document.newName,
                                ));
                              },
                              back: () {
                                BlocProvider.of<DocumentOnlineBloc>(
                                        this.context)
                                    .add(InitDocumentEditEvent());
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                ],
                if (state is OnlineUploadState) ...[
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
                              BlocProvider.of<DocumentOnlineBloc>(this.context)
                                  .add(InitDocumentEditEvent());
                            },
                            tryAgain: () async {
                              BlocProvider.of<DocumentOnlineBloc>(this.context)
                                  .add(OnlineInitUploadEvent(
                                      name: document.newName));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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
    required this.documentModelEdit,
  });
  final EditDocumentDataModel documentModelEdit;
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
                  widget.documentModelEdit.name,
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
                                        widget.documentModelEdit.groupId =
                                            e["id"];
                                        widget.documentModelEdit.subGroupId = i;
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
    required this.labels,
    required this.oldLabelIndex,
  });
  final List labels;
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
      labelName.text = widget.labels[widget.oldLabelIndex!];
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
                              widget.labels.add(labelName.text);
                            } else {
                              widget.labels[widget.oldLabelIndex!] =
                                  labelName.text;
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
      if (!widget.labels.contains(name.replaceAll(" ", ""))) {
        validName = true;
        return null;
      } else {
        validName = false;
        return "این زیر گروه وحود دارد!";
      }
    }
  }
}

class RenameDocument extends StatefulWidget {
  RenameDocument({
    super.key,
    required this.document,
  });
  final EditDocumentDataModel document;
  @override
  State<RenameDocument> createState() => _RenameDocumentState();
}

class _RenameDocumentState extends State<RenameDocument> {
  TextEditingController newName = TextEditingController();
  FocusNode fNode = FocusNode();
  bool validName = false;
  String? errorText;
  @override
  void initState() {
    newName.text = widget.document.newName;
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
                            widget.document.newName = newName.text;
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
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(color: lightgray),
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: newName,
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
                          error(value);
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

  void error(String name) {
    if (name.isEmpty) {
      validName = false;
    } else {
      validName = true;
    }
  }
}

class AudioListOnline extends StatefulWidget {
  AudioListOnline(
      {super.key,
      required this.audioList,
      required this.pm,
      required this.setAudio});
  final List<Map<String, Map<String, PageManager>>> audioList;
  final Function(PageManager newPm) setAudio;
  final PageManager pm;
  @override
  State<AudioListOnline> createState() => _AudioListOnlineState();
}

class _AudioListOnlineState extends State<AudioListOnline> {
  Map size = {
    0: 0.2,
    1: 0.22,
    2: 0.3,
    3: 0.36,
    4: 0.44,
    5: 0.52,
    6: 0.6,
  };
  PageManager pm = PageManager(audioPath: null, source: AudioSource.url);

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
      height: widget.audioList.length > 6
          ? MediaQuery.of(context).size.height * 0.6
          : MediaQuery.of(context).size.height * size[widget.audioList.length],
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
          if (widget.audioList.isEmpty) ...[
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
          if (widget.audioList.length <= 6) ...[
            ...widget.audioList.map((e) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  children: [
                    audioItem(e.keys.first, widget.audioList.indexOf(e),
                        e[e.keys.first]!.values.first),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: widget.audioList.last != e,
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
          if (widget.audioList.length > 6) ...[
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  ...widget.audioList.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      child: Column(
                        children: [
                          audioItem(e.keys.first, widget.audioList.indexOf(e),
                              e[e.keys.first]!.values.first),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: widget.audioList.last != e,
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

  Widget audioItem(String title, int index, PageManager audio) {
    return ValueListenableBuilder(
      valueListenable: audio.isLoaded,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            color:
                pm.p == audio.p ? const Color(0xffECEEF4) : Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: InkWell(
            onTap: value
                ? () async {
                    if (pm.p != audio.p) {
                      await widget.setAudio(audio);
                      setState(() {
                        pm = audio;
                        pm.play();
                      });
                    }
                  }
                : null,
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
                            child:
                                Icon(Iconsax.clock, size: 18, color: lightgray),
                          ),
                          const SizedBox(width: 6),
                          value
                              ? ValueListenableBuilder(
                                  valueListenable: audio.progressNotifier,
                                  builder: (context, value, child) => Text(
                                    "${(value.total.inSeconds / 60).floor()}:${(value.total.inSeconds % 60).floor() < 10 ? 0 : ''}${(value.total.inSeconds % 60).floor()}",
                                    style: const TextStyle(color: black),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : LoadingRing(),
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
      },
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
  AudioListScreen(
      {super.key,
      required this.document,
      required this.audioList,
      required this.addAudio});
  final EditDocumentDataModel document;
  final List<Map<String, Map<String, PageManager>>> audioList;
  final Function(Map preAudio) addAudio;
  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  PageManager pm = PageManager(audioPath: "", source: AudioSource.url);
  String curentAudioTitle = "";

  bool reorder = false;

  @override
  void dispose() {
    pm.pause();
    super.dispose();
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
                      ...widget.audioList.map((e) {
                        return Padding(
                          key: UniqueKey(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              audioItem(
                                  e.keys.first,
                                  e[e.keys.first]!.values.first,
                                  e[e.keys.first]!.keys.first),
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
                      var old = widget.document.audioList.removeAt(oldIndex);
                      widget.document.audioList.insert(newIndex, old);
                      old = widget.audioList.removeAt(oldIndex);
                      widget.audioList.insert(newIndex, old);
                    });
                  },
                  children: [
                    ...widget.audioList.map((e) {
                      return Padding(
                        key: UniqueKey(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            audioItem(
                                e.keys.first,
                                e[e.keys.first]!.values.first,
                                e[e.keys.first]!.keys.first),
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
    return ValueListenableBuilder(
      valueListenable: audio.isLoaded,
      builder: (context, value, child) => Column(
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
                  value
                      ? ValueListenableBuilder(
                          valueListenable: audio.progressNotifier,
                          builder: (context, value, child) => Text(
                            "${(value.total.inSeconds / 60).floor()}:${(value.total.inSeconds % 60).floor() < 10 ? 0 : ''}${(value.total.inSeconds % 60).floor()}",
                            style: const TextStyle(color: black),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : LoadingRing(),
                ],
              ),
              Expanded(
                child: TextButton(
                  onPressed: reorder
                      ? null
                      : () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: this.context,
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
                                  child: AudioTitle(
                                    document: widget.document,
                                    audioList: widget.audioList,
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
                  onPressed: value
                      ? () async {
                          await widget.addAudio({"title": title, "name": name});
                          setState(() {});
                        }
                      : null,
                  child: SvgPicture.asset(
                    "assets/images/replace_items.svg",
                    color: black,
                  ),
                ),
                TextButton(
                  onPressed: value
                      ? () {
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
                                            File oldFile = File(
                                                "${AppDataDirectory.documentOnlineEdit().path}/$name");
                                            if (await oldFile.exists()) {
                                              await oldFile.delete();
                                              widget.document.deletedFiles
                                                  .add(name);
                                            }
                                            widget.document.audioList
                                                .removeWhere((element) =>
                                                    element["title"] == title &&
                                                    element["name"] == name);
                                            widget.audioList.removeWhere(
                                                (element) =>
                                                    element.keys.first ==
                                                        title &&
                                                    element[element.keys.first]!
                                                            .keys
                                                            .first ==
                                                        name);
                                            widget.document.deletedFiles
                                                .add(name);
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
                        }
                      : null,
                  child: const Icon(
                    Iconsax.trash,
                    color: black,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: value
                      ? () {
                          if (pm.p != audio.p) {
                            pm.pause();
                            setState(() {
                              curentAudioTitle = title;
                              pm = audio;
                              pm.play();
                            });
                          }
                        }
                      : null,
                  child: const Icon(
                    Iconsax.play4,
                    color: green,
                  ),
                ),
              ],
            ),
          ),
        ],
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

class AudioTitle extends StatefulWidget {
  AudioTitle({
    super.key,
    required this.document,
    required this.audioList,
    required this.name,
  });
  final EditDocumentDataModel document;
  final List<Map<String, Map<String, PageManager>>> audioList;
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
    for (Map audio in widget.document.audioList) {
      titles.add(audio["title"]);
    }
    labelName.text = widget.document.audioList[widget.document.audioList
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
                            widget.document.audioList[widget.document.audioList
                                    .indexWhere((element) =>
                                        element["name"] == widget.name)]
                                ["title"] = labelName.text;

                            Map<String, Map<String, PageManager>> audio = widget
                                    .audioList[
                                widget.audioList.indexWhere((element) =>
                                    element[element.keys.first]!.keys.first ==
                                    widget.name)];

                            widget.audioList[widget.audioList.indexWhere(
                                (element) =>
                                    element[element.keys.first]!.keys.first ==
                                    widget.name)] = {
                              labelName.text: {
                                audio[audio.keys.first]!.keys.first:
                                    audio[audio.keys.first]!.values.first
                              }
                            };
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
