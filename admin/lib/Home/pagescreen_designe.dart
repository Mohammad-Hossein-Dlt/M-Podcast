import 'dart:io';
import 'package:admin/Bloc/CategoriesBloc/categories_block.dart';
import 'package:admin/Bloc/PageEditor/page_editor_event.dart';
import 'package:admin/Bloc/PageEditor/page_editor_state.dart';
import 'package:admin/Bloc/SearchBloc/search_block.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/GeneralWidgets/upload_process.dart';
import 'package:admin/Home/home_designe.dart';
import 'package:admin/Home/search_screen.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:admin/paths.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../Bloc/PageEditor/page_editor_block.dart';

class PageDesigner extends StatefulWidget {
  PageDesigner({
    super.key,
    required this.id,
  });
  final String id;
  @override
  State<PageDesigner> createState() => _PageDesignerState();
}

enum DesignState { loading, loaded }

class _PageDesignerState extends State<PageDesigner> {
  List page = [];

  List removeImages = [];
  List newImages = [];

  bool isReorder = false;
  List reorderMain = [];

  @override
  void initState() {
    categoriesData = [];
    BlocProvider.of<PageEditorBloc>(context)
        .add(GetCategoryPageDataEvent(mainGroupId: widget.id));
    super.initState();
  }

  List<Widget> buildItems(List content) {
    return [
      ...content.map((e) {
        Widget widget_ = Container(key: UniqueKey());
        switch (e["type"]) {
          case "selectiveFromSubGroup":
            widget_ =
                e["style"] == "style-1" ? selectedList(e) : selectedList2(e);
            break;

          case "newest":
            widget_ = e["style"] == "style-1"
                ? allDocumentsBy(e, "جدیدترین ها")
                : allDocumentsBy2(e, "جدیدترین ها");
            break;
          case "hottest":
            widget_ = e["style"] == "style-1"
                ? allDocumentsBy(e, "پرطرفدارترین ها")
                : allDocumentsBy2(e, "پرطرفدارترین ها");
            break;
          case "subGroups":
            widget_ = subGroups(e, "زیرگروه ها");
            break;
          case "banner":
            widget_ = Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "بنر یکه",
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                banner(
                    bannerData: e,
                    mainIndex: content.indexOf(e),
                    bannerListIndex: null),
              ],
            );
            break;
          case "bannerlist":
            widget_ =
                bannerList(bannerListData: e, mainIndex: content.indexOf(e));
            break;
          default:
            widget_ = Container(key: UniqueKey());
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: widget_,
        );
      })
    ];
  }

  @override
  void dispose() {
    List flist = AppDataDirectory.mainpage().listSync();
    for (File f in flist) {
      f.delete();
    }
    super.dispose();
  }

  Widget appBarActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                reorderMain = List.of(page);
                isReorder = !isReorder;
                BlocProvider.of<PageEditorBloc>(context)
                    .add(PageEditorDefaultEvent());
              },
              child: const Icon(
                Iconsax.repeat,
                color: black,
              )),
          PopupMenuButton(
            icon: SvgPicture.asset("assets/images/menu.svg"),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            itemBuilder: (context) {
              return <PopupMenuEntry<Object>>[
                PopupMenuItem(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.photo_size_select_actual_outlined),
                      Text("بنر"),
                    ],
                  ),
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom, allowedExtensions: ["jpg"]);
                    if (result != null) {
                      DateTime now = DateTime.now();
                      String creationDate =
                          "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
                      String newImageName = "$creationDate.jpg";
                      String newImagePath =
                          "${AppDataDirectory.mainpage().path}/$newImageName";
                      await File(result.files.single.path!).copy(newImagePath);
                      newImages.add(newImageName);

                      page.add({
                        "type": "banner",
                        "name": newImageName,
                        "documentName": "",
                        "documentId": "",
                      });
                      BlocProvider.of<PageEditorBloc>(this.context)
                          .add(PageEditorDefaultEvent());
                    }
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.photo_size_select_actual_outlined),
                      Text("لیست بنر"),
                    ],
                  ),
                  onTap: () {
                    page.add({
                      "type": "bannerlist",
                      "list": [],
                    });
                    BlocProvider.of<PageEditorBloc>(context)
                        .add(PageEditorDefaultEvent());
                  },
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.check_box_outlined),
                      Text("انتخابی از زیرگروه ها"),
                    ],
                  ),
                  onTap: () {
                    page.add({
                      "type": "selectiveFromSubGroup",
                      "title": "",
                      "category": {"group": "", "subgroup": ""}
                    });
                    BlocProvider.of<PageEditorBloc>(context)
                        .add(PageEditorDefaultEvent());
                  },
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.check_box_outlined),
                      Text("انتخابی"),
                    ],
                  ),
                  onTap: () {
                    page.add({
                      "type": "selective",
                      "title": "",
                      "list": [],
                    });
                    BlocProvider.of<PageEditorBloc>(context)
                        .add(PageEditorDefaultEvent());
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.timelapse_sharp),
                      Text(
                        "جدیدترین ها",
                      ),
                    ],
                  ),
                  onTap: () {
                    bool check = false;
                    for (Map i in page) {
                      if (i["type"] == "newest") {
                        check = true;
                      }
                    }
                    if (!check) {
                      page.add({
                        "type": "newest",
                        "title": "",
                      });
                      BlocProvider.of<PageEditorBloc>(context)
                          .add(PageEditorDefaultEvent());
                    }
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.groups_rounded),
                      Text("پرطرفدارترین ها"),
                    ],
                  ),
                  onTap: () {
                    bool check = false;
                    for (Map i in page) {
                      if (i["type"] == "hottest") {
                        check = true;
                      }
                    }
                    if (!check) {
                      page.add({
                        "type": "hottest",
                        "title": "",
                      });
                      BlocProvider.of<PageEditorBloc>(context)
                          .add(PageEditorDefaultEvent());
                    }
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.groups_rounded),
                      Text("زیر گروه ها"),
                    ],
                  ),
                  onTap: () {
                    bool check = false;
                    for (Map i in page) {
                      if (i["type"] == "subGroups") {
                        check = true;
                      }
                    }
                    if (!check) {
                      page.add({
                        "type": "subGroups",
                        "title": "",
                      });
                      BlocProvider.of<PageEditorBloc>(context)
                          .add(PageEditorDefaultEvent());
                    }
                  },
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  Widget editScreen() {
    return Expanded(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                elevation: 2,
                forceElevated: true,
                backgroundColor: white,
                shadowColor: white,
                title: const Text(
                  "",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                leading: TextButton(
                    onPressed: () async {
                      BlocProvider.of<PageEditorBloc>(context)
                          .add(InitUploadPageEvent());
                    },
                    child: SvgPicture.asset("assets/images/upload.svg")),
                actions: [
                  TextButton(
                    child: SvgPicture.asset("assets/images/arrow-right2.svg"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
            body: isReorder
                ? reorderItems()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ...buildItems(page),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: isReorder ? reorderActions() : appBarActions(),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<PageEditorBloc, PageEditorState>(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is PageEditorLoadingState) ...[
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
              if (state is PageEditorErrorState) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Refresh(onRefresh: () {
                      BlocProvider.of<PageEditorBloc>(context).add(
                          GetCategoryPageDataEvent(mainGroupId: widget.id));
                    }),
                  ],
                ),
              ],
              if (state is CategoryPageEditorDataState) ...[
                state.data.fold((l) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Refresh(onRefresh: () {
                        BlocProvider.of<PageEditorBloc>(context).add(
                            GetCategoryPageDataEvent(mainGroupId: widget.id));
                      }),
                    ],
                  );
                }, (r) {
                  page = r.page;
                  categoriesData = state.categories;
                  return editScreen();
                })
              ],
              if (state is PageEditorDefaultState) ...[
                editScreen(),
              ],
              if (state is InitUploadPageState) ...[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "آپلود شود؟",
                                style: TextStyle(color: black),
                              ),
                              // const SizedBox(width: 4),
                              // const Icon(Icons.check_sharp),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: black,
                                    disabledBackgroundColor:
                                        const Color(0xffF5F5F5),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                  onPressed: () async {
                                    BlocProvider.of<PageEditorBloc>(context)
                                        .add(UploadCategoryPageEvent(
                                      id: widget.id,
                                      page: page,
                                      removeImages: removeImages,
                                    ));
                                  },
                                  child: const Text("آپلود")),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: black,
                                    disabledBackgroundColor:
                                        const Color(0xffF5F5F5),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<PageEditorBloc>(context)
                                        .add(PageEditorDefaultEvent());
                                  },
                                  child: const Text("بازگشت")),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (state is UploadPageState) ...[
                Expanded(
                  child: UploadProgress(
                    uploadSuccessTitle: "لیست با موفقیت آپلود شد",
                    title1: "آپلود لیست",
                    title2: "آپلود فایل ها",
                    title3: "حذف فایل های قدیمی",
                    error: state.error,
                    uploadProgress: state.uploadProgress,
                    back: () {
                      BlocProvider.of<PageEditorBloc>(context)
                          .add(PageEditorDefaultEvent());
                    },
                    tryAgain: () async {
                      BlocProvider.of<PageEditorBloc>(context)
                          .add(UploadCategoryPageEvent(
                        id: widget.id,
                        page: page,
                        removeImages: removeImages,
                      ));
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget reorderItems() {
    List<Widget> items = buildItems(reorderMain);
    return ReorderableListView(
      children: [
        ...items.map((e) => Column(
              key: UniqueKey(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 20),
                      child: InkWell(
                        child: const Icon(
                          Icons.remove_circle_outline_rounded,
                          color: Colors.red,
                        ),
                        onTap: () {
                          if (reorderMain.elementAt(items.indexOf(e))["type"] ==
                              "banner") {
                            removeImages
                                .add(reorderMain[items.indexOf(e)]["name"]);
                          }
                          if (reorderMain.elementAt(items.indexOf(e))["type"] ==
                              "bannerlist") {
                            for (Map banner in reorderMain[items.indexOf(e)]
                                ["list"]) {
                              if (banner.keys.contains("name") &&
                                  banner["name"] != null) {
                                removeImages.add(banner["name"]);
                              }
                            }
                          }
                          reorderMain.removeAt(items.indexOf(e));
                          BlocProvider.of<PageEditorBloc>(context)
                              .add(PageEditorDefaultEvent());
                        },
                      ),
                    ),
                  ],
                ),
                e,
              ],
            ))
      ],
      onReorder: (oldIndex, newIndex) {
        // setState(() {
        if (oldIndex < newIndex) {
          newIndex--;
        }
        var old = reorderMain.removeAt(oldIndex);
        reorderMain.insert(newIndex, old);
        BlocProvider.of<PageEditorBloc>(context).add(PageEditorDefaultEvent());
        // }
        // );
      },
    );
  }

  Widget reorderActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: black,
            ),
            onPressed: () {
              setState(() {
                isReorder = false;
              });
            },
            child: const Text("لغو")),
        const SizedBox(width: 40),
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: black,
            ),
            onPressed: () async {
              for (String name in removeImages) {
                File file = File("${AppDataDirectory.mainpage().path}/$name");
                if (await file.exists()) {
                  await file.delete();
                }
              }
              page = reorderMain;
              isReorder = false;
              BlocProvider.of<PageEditorBloc>(context)
                  .add(PageEditorDefaultEvent());
            },
            child: const Text("تایید")),
      ],
    );
  }

  Widget subGroups(Map item, String preTitle) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Expanded(
                          child: Text(
                            item["title"].isNotEmpty ? item["title"] : preTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
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
                              child: AddTitle(
                                main: page,
                                item: item,
                              ));
                        }).then((value) {
                      BlocProvider.of<PageEditorBloc>(this.context)
                          .add(PageEditorDefaultEvent());
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Container(
                width: 100,
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: const Color(0xffF1F5FF), width: 1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Container(
                width: 100,
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: const Color(0xffF1F5FF), width: 1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Container(
                width: 100,
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: const Color(0xffF1F5FF), width: 1),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget selectedList(Map selected) {
    String title = selected["title"];
    Map ctg = selected["category"];
    String groupId = ctg["group"];
    String subgroupId = ctg["subgroup"];

    String group = categoriesData
            .where((element) => element["id"] == groupId)
            .first["name"] ??
        "";

    String subgroup = categoriesData
            .where((element) =>
                (element["id"] == groupId && element["subgroups"].isNotEmpty))
            .first[subgroupId] ??
        "";
    return Column(
      key: UniqueKey(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  selected["style"] = "style-2";
                  BlocProvider.of<PageEditorBloc>(this.context)
                      .add(PageEditorDefaultEvent());
                },
                child: const Text(
                  "استایل 2",
                  style: TextStyle(
                    color: accent_blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Expanded(
                          child: Text(
                            title.isNotEmpty ? title : "نام لیست",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
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
                              child: AddTitle(
                                main: page,
                                item: selected,
                              ));
                        }).then((value) {
                      BlocProvider.of<PageEditorBloc>(this.context)
                          .add(PageEditorDefaultEvent());
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    group.isNotEmpty
                        ? subgroup.isNotEmpty
                            ? subgroup
                            : "همه*"
                        : "زیرگروه",
                    style: const TextStyle(fontSize: 16, color: lightgray),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 18,
                    color: lightgray,
                  ),
                  Text(
                    group.isNotEmpty ? group : "گروه",
                    style: const TextStyle(fontSize: 16, color: lightgray),
                  ),
                ],
              ),
              onTap: () async {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => CategoriesBloc(),
                      child: Grouping(
                        main: page,
                        selected: selected,
                      ),
                    ),
                  ),
                )
                    .then((value) {
                  BlocProvider.of<PageEditorBloc>(this.context)
                      .add(PageEditorDefaultEvent());
                });
              },
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            children: [
              const SizedBox(width: 10),
              DocumentItemPreview(name: ""),
              DocumentItemPreview(name: ""),
              DocumentItemPreview(name: ""),
              DocumentItemPreview(name: ""),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget selectedList2(Map selected) {
    String title = selected["title"];
    Map ctg = selected["category"];
    String groupId = ctg["group"];
    String subgroupId = ctg["subgroup"];

    String group = categoriesData
            .where((element) => element["id"] == groupId)
            .first["name"] ??
        "";

    String subgroup = categoriesData
            .where((element) =>
                (element["id"] == groupId && element["subgroups"].isNotEmpty))
            .first[subgroupId] ??
        "";

    return Container(
      key: UniqueKey(),
      color: black,
      child: Column(
        children: [
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: [
                const SizedBox(width: 10),
                DocumentItemPreview(name: ""),
                DocumentItemPreview(name: ""),
                DocumentItemPreview(name: ""),
                DocumentItemPreview(name: ""),
                Container(
                  width: 100,
                  height: 240,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: black,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Expanded(
                                  child: Text(
                                    title.isNotEmpty ? title : "نام لیست",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
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
                                      child: AddTitle(
                                        main: page,
                                        item: selected,
                                      ));
                                }).then((value) {
                              BlocProvider.of<PageEditorBloc>(this.context)
                                  .add(PageEditorDefaultEvent());
                            });
                          },
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(100, 38),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          "استایل 1",
                          style: TextStyle(
                            color: accent_blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          selected["style"] = "style-1";
                          BlocProvider.of<PageEditorBloc>(this.context)
                              .add(PageEditorDefaultEvent());
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  group.isNotEmpty
                      ? subgroup.isNotEmpty
                          ? subgroup
                          : "همه*"
                      : "زیرگروه",
                  style: const TextStyle(fontSize: 16, color: lightgray),
                ),
                const Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 18,
                  color: lightgray,
                ),
                Text(
                  group.isNotEmpty ? group : "گروه",
                  style: const TextStyle(fontSize: 16, color: lightgray),
                ),
              ],
            ),
            onTap: () async {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => CategoriesBloc(),
                    child: Grouping(
                      main: page,
                      selected: selected,
                    ),
                  ),
                ),
              )
                  .then((value) {
                BlocProvider.of<PageEditorBloc>(this.context)
                    .add(PageEditorDefaultEvent());
              });
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget allDocumentsBy(Map item, String preTitle) {
    return Container(
      key: UniqueKey(),
      // padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    item["style"] = "style-2";
                    BlocProvider.of<PageEditorBloc>(this.context)
                        .add(PageEditorDefaultEvent());
                  },
                  child: const Text(
                    "استایل 2",
                    style: TextStyle(
                      color: accent_blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Expanded(
                            child: Text(
                              item["title"].isNotEmpty
                                  ? item["title"]
                                  : preTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
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
                                child: AddTitle(
                                  main: page,
                                  item: item,
                                ));
                          }).then((value) {
                        BlocProvider.of<PageEditorBloc>(this.context)
                            .add(PageEditorDefaultEvent());
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                DocumentItemPreview(name: ""),
                DocumentItemPreview(name: ""),
                DocumentItemPreview(name: ""),
                DocumentItemPreview(name: ""),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget allDocumentsBy2(Map item, String preTitle) {
    return Container(
      key: UniqueKey(),
      color: black,
      // padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                DocumentItemPreview(name: ""),
                DocumentItemPreview(name: ""),
                DocumentItemPreview(name: ""),
                DocumentItemPreview(name: ""),
                Container(
                  width: 100,
                  height: 240,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: black,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Expanded(
                                  child: Text(
                                    item["title"].isNotEmpty
                                        ? item["title"]
                                        : preTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
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
                                      child: AddTitle(
                                        main: page,
                                        item: item,
                                      ));
                                }).then((value) {
                              BlocProvider.of<PageEditorBloc>(this.context)
                                  .add(PageEditorDefaultEvent());
                            });
                          },
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(100, 38),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          "استایل 1",
                          style: TextStyle(
                            color: accent_blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          item["style"] = "style-1";
                          BlocProvider.of<PageEditorBloc>(this.context)
                              .add(PageEditorDefaultEvent());
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget banner({
    required Map bannerData,
    required int mainIndex,
    required int? bannerListIndex,
  }) {
    String name = bannerData['name'];
    String documentName_ = bannerData["documentName"];
    String documentId_ = bannerData["documentId"];
    String imagePath =
        "${AppDataDirectory.mainpage().path}/${bannerData['name']}";
    return SizedBox(
      key: UniqueKey(),
      height: 240,
      child: IntrinsicWidth(
        child: Column(
          children: [
            InkWell(
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: newImages.contains(name)
                          ? Image.file(
                              File(imagePath),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            )
                          : ImageItem.Banner(
                              imageName: name,
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),
                  ),
                ),
                onTap: () async {
                  // Pick Image
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ["jpg"]);
                  if (result != null) {
                    removeImages.add(name);
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
                        "${AppDataDirectory.mainpage().path}/$newImageName";
                    // Copying And Naming Image With NewImagePath
                    File(result.files.single.path!).copy(newImagePath);
                    newImages.add(newImageName);
                    if (bannerListIndex == null) {
                      page[mainIndex] = {
                        "type": "banner",
                        "name": newImageName,
                        "documentName": documentName_,
                        "documentId": documentId_,
                      };
                    } else {
                      page[mainIndex]["list"][bannerListIndex] = {
                        "type": "banner",
                        "name": newImageName,
                        "documentName": documentName_,
                        "documentId": documentId_,
                      };
                    }

                    File prevImage = File(imagePath);
                    if (await prevImage.exists()) {
                      prevImage.delete();
                    }

                    BlocProvider.of<PageEditorBloc>(this.context)
                        .add(PageEditorDefaultEvent());
                  }
                }),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width - 40,
              child: InkWell(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(" :سند ارجاعی"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Expanded(
                            child: Text(
                              documentName_,
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
                  ],
                ),
                onTap: () async {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => SearchBloc(),
                        child: Scaffold(
                          body: SearchScreen(
                            onDelete: false,
                            bannerData: bannerData,
                            preSearch: "",
                          ),
                        ),
                      ),
                    ),
                  )
                      .then((value) {
                    BlocProvider.of<PageEditorBloc>(this.context)
                        .add(PageEditorDefaultEvent());
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bannerList({
    required Map bannerListData,
    required int mainIndex,
  }) {
    List names = bannerListData["list"];
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "لیست بنر",
                style: TextStyle(
                    color: black, fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          ),
        ),
        SizedBox(
          key: UniqueKey(),
          width: double.infinity,
          height: 250,
          child: Center(
            child: ListView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              children: [
                const SizedBox(
                  width: 6,
                ),
                ...names.map(
                  (e) => banner(
                      bannerData: e,
                      mainIndex: mainIndex,
                      bannerListIndex: names.indexOf(e)),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  // height: 200,
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ["jpg"]);
                        if (result != null) {
                          DateTime now = DateTime.now();
                          String creationDate =
                              "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
                          String newImageName = "$creationDate.jpg";
                          String newImagePath =
                              "${AppDataDirectory.mainpage().path}/$newImageName";
                          await File(result.files.single.path!)
                              .copy(newImagePath);
                          newImages.add(newImageName);
                          setState(() {
                            names.add({
                              "type": "banner",
                              "name": newImageName,
                              "documentName": "",
                              "documentId": "",
                            });
                            bannerListData["list"] = names;
                          });
                        }
                      },
                      child: SvgPicture.asset(
                        "assets/images/add.svg",
                        color: black,
                        width: 50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SelectedList extends StatefulWidget {
  SelectedList({
    super.key,
    required this.page,
    required this.selected,
    required this.isReorder,
    required this.reload,
  });
  final List page;
  final Map selected;
  final bool isReorder;
  final Function reload;
  @override
  State<SelectedList> createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList>
    with AutomaticKeepAliveClientMixin {
  List<Widget> items = [];
  String title = "";
  List ctg = [];
  bool isReorder = false;
  @override
  void initState() {
    title = widget.selected["title"];
    ctg = widget.selected["list"];
    items = ctg
        .map((e) => Container(
              key: UniqueKey(),

              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.only(top: 10),
              // height: 40,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xffF6F6F6),
              ),
              child: IntrinsicHeight(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Expanded(
                                child: Text(
                                  e,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => SearchBloc(),
                                child: Scaffold(
                                  body: SearchScreen(
                                    onDelete: false,
                                    selectedList: widget.selected,
                                    replaceSelectedListItem: ctg.indexOf(e),
                                    preSearch: "",
                                  ),
                                ),
                              ),
                            ),
                          )
                              .then((value) {
                            widget.reload();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Visibility(
                      visible: !widget.isReorder,
                      child: InkWell(
                        onTap: () {
                          ctg.remove(e);
                          widget.reload();

                          setState(() {});
                        },
                        child: const Icon(
                          Icons.highlight_remove_outlined,
                          color: lightgray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      key: UniqueKey(),
      width: double.infinity,
      // height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
            color: const Color.fromARGB(255, 183, 228, 217), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(
                  title.isNotEmpty ? title : "نام لیست",
                  style: const TextStyle(
                      color: black, fontWeight: FontWeight.bold),
                ),
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
                            child: AddTitle(
                              main: widget.page,
                              item: widget.selected,
                            ));
                      }).then((value) {
                    widget.reload();
                  });
                },
              )
            ],
          ),
          const Divider(color: lightgray),
          if (widget.isReorder)
            list()
          else if (isReorder)
            reOrder()
          else
            Column(
              children: [...items],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: isReorder ? midGreen : null,
                ),
                onPressed: () async {
                  setState(() {
                    isReorder = !isReorder;
                  });
                },
                child: SvgPicture.asset(
                  "assets/images/replace_items.svg",
                  color: black,
                ),
              ),
              Visibility(
                visible: !widget.isReorder,
                child: TextButton(
                  onPressed: () async {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => SearchBloc(),
                          child: Scaffold(
                            body: SearchScreen(
                              onDelete: false,
                              selectedList: widget.selected,
                              preSearch: "",
                            ),
                          ),
                        ),
                      ),
                    )
                        .then((value) {
                      widget.reload();
                    });
                  },
                  child: SvgPicture.asset(
                    "assets/images/add.svg",
                    color: black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget reOrder() {
    return SizedBox(
      height: items.length * 66,
      child: ReorderableListView(
        children: [...items],
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex--;
          }
          var old = widget.page[widget.page.indexOf(widget.selected)]["list"]
              .removeAt(oldIndex);
          widget.page[widget.page.indexOf(widget.selected)]["list"]
              .insert(newIndex, old);
          widget.reload();
          setState(() {
            isReorder = true;
          });
        },
      ),
    );
  }

  Widget list() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        // initiallyExpanded: true,
        childrenPadding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        collapsedIconColor: black,
        collapsedTextColor: black,
        iconColor: green,
        textColor: green,
        title: Text(title, textAlign: TextAlign.end),
        children: [...items],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class AddTitle extends StatefulWidget {
  AddTitle({
    super.key,
    required this.main,
    required this.item,
  });
  final List main;
  final Map item;
  @override
  State<AddTitle> createState() => _AddTitleState();
}

class _AddTitleState extends State<AddTitle> {
  TextEditingController newName = TextEditingController();
  FocusNode fNode = FocusNode();
  @override
  void initState() {
    newName.text = widget.item["title"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7DABF6),
                shape: const CircleBorder(side: BorderSide.none),
              ),
              onPressed: () {
                widget.main
                        .elementAt(widget.main.indexOf(widget.item))["title"] =
                    newName.text;
                Navigator.of(context).pop();
              },
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
                controller: newName,
                textDirection: TextDirection.rtl,
                maxLines: null,
                decoration: InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  focusedBorder: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  hintText: "نام",
                  labelStyle: TextStyle(
                      color: fNode.hasFocus ? Colors.blue : Colors.white,
                      fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
