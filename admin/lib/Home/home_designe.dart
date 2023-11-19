import 'dart:io';
import 'package:admin/Bloc/CategoriesBloc/categories_block.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_event.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_state.dart';
import 'package:admin/Bloc/PageEditor/page_editor_block.dart';
import 'package:admin/Bloc/PageEditor/page_editor_event.dart';
import 'package:admin/Bloc/PageEditor/page_editor_state.dart';
import 'package:admin/Bloc/SearchBloc/search_block.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/GeneralWidgets/upload_process.dart';
import 'package:admin/Home/search_screen.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:admin/paths.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeDesigner extends StatefulWidget {
  HomeDesigner({
    super.key,
  });
  @override
  State<HomeDesigner> createState() => _HomeDesignerState();
}

enum DesignState { loading, loaded }

List categoriesData = [];

class _HomeDesignerState extends State<HomeDesigner>
    with SingleTickerProviderStateMixin {
  List main = [];

  List removeImages = [];
  List newImages = [];

  bool isReorder = false;
  List reorderMain = [];

  @override
  void initState() {
    categoriesData = [];

    BlocProvider.of<PageEditorBloc>(context).add(GetHomePageDataEvent());
    super.initState();
  }

  List<Widget> buildItems(List content) {
    return [
      ...content.map((e) {
        Widget widget_ = Container(key: UniqueKey());
        switch (e["type"]) {
          case "selective":
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
          case "categories":
            widget_ = categories(e, "دسته بندی ها");
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
                    mainIndex: main.indexOf(e),
                    bannerListIndex: null),
              ],
            );
            break;
          case "bannerlist":
            widget_ = bannerList(bannerListData: e, mainIndex: main.indexOf(e));
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
                reorderMain = List.of(main);
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

                      main.add({
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
                    main.add({
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
                      Icon(Icons.timelapse_sharp),
                      Text("جدیدترین ها"),
                    ],
                  ),
                  onTap: () {
                    bool check = false;
                    for (Map i in main) {
                      if (i["type"] == "newest") {
                        check = true;
                      }
                    }
                    if (!check) {
                      main.add({
                        "type": "newest",
                        "title": "",
                        "style": "style-1",
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
                    for (Map i in main) {
                      if (i["type"] == "hottest") {
                        check = true;
                      }
                    }
                    if (!check) {
                      main.add({
                        "type": "hottest",
                        "title": "",
                        "style": "style-1",
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
                      Icon(Icons.check_box_outlined),
                      Text("انتخابی"),
                    ],
                  ),
                  onTap: () {
                    main.add({
                      "type": "selective",
                      "title": "",
                      "category": {"group": "", "subgroup": ""},
                      "style": "style-1",
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
                      Icon(Icons.groups_rounded),
                      Text("دسته بندی ها"),
                    ],
                  ),
                  onTap: () {
                    bool check = false;
                    for (Map i in main) {
                      if (i["type"] == "categories") {
                        check = true;
                      }
                    }
                    if (!check) {
                      main.add({
                        "type": "categories",
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
                  "صفحه اصلی",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                leading: TextButton(
                  onPressed: () async {
                    BlocProvider.of<PageEditorBloc>(context)
                        .add(InitUploadPageEvent());
                  },
                  child: SvgPicture.asset("assets/images/upload.svg"),
                ),
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
                        ...buildItems(main),
                        const SizedBox(height: 50),
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
            if (state is HomePageEditorDataState) ...[
              state.data.fold((l) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Refresh(onRefresh: () {
                      BlocProvider.of<PageEditorBloc>(this.context)
                          .add(GetHomePageDataEvent());
                    }),
                  ],
                );
              }, (r) {
                main = r.main;
                categoriesData = r.categories;
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
                                  backgroundColor: green,
                                  disabledBackgroundColor:
                                      const Color(0xffF5F5F5),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                onPressed: () async {
                                  BlocProvider.of<PageEditorBloc>(context).add(
                                      UploadHomePageEvent(
                                          page: main,
                                          removeImages: removeImages));
                                },
                                child: const Text("آپلود")),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
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
                    BlocProvider.of<PageEditorBloc>(context).add(
                        UploadHomePageEvent(
                            page: main, removeImages: removeImages));
                  },
                ),
              ),
            ],
          ],
        ),
      )),
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
                    TextButton(
                      child: const Icon(
                        Icons.remove_circle_outline_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {
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
                  ],
                ),
                e,
              ],
            ))
      ],
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex--;
        }
        var old = reorderMain.removeAt(oldIndex);
        reorderMain.insert(newIndex, old);
        BlocProvider.of<PageEditorBloc>(context).add(PageEditorDefaultEvent());
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
              isReorder = false;
              BlocProvider.of<PageEditorBloc>(context)
                  .add(PageEditorDefaultEvent());
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
              main = reorderMain;
              isReorder = false;
              BlocProvider.of<PageEditorBloc>(this.context)
                  .add(PageEditorDefaultEvent());
            },
            child: const Text("تایید")),
      ],
    );
  }

  Widget categories(Map item, String preTitle) {
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
                                main: main,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            .first["subgroups"][subgroupId] ??
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
                                main: main,
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
                        main: main,
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
            .first["subgroups"][subgroupId] ??
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
                                        main: main,
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
                      main: main,
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
                                  main: main,
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
                                        main: main,
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
            Expanded(
              child: InkWell(
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
                        main[mainIndex] = {
                          "type": "banner",
                          "name": newImageName,
                          "documentName": documentName_,
                          "documentId": documentId_,
                        };
                      } else {
                        main[mainIndex]["list"][bannerListIndex] = {
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
                      // setState(() {});
                      // DefaultCacheManager().emptyCache();
                    }
                  }),
            ),
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
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: banner(
                        bannerData: e,
                        mainIndex: mainIndex,
                        bannerListIndex: names.indexOf(e)),
                  ),
                ),
                Container(
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

                          names.add({
                            "type": "banner",
                            "name": newImageName,
                            "documentName": "",
                            "documentId": "",
                          });
                          bannerListData["list"] = names;
                          BlocProvider.of<PageEditorBloc>(this.context)
                              .add(PageEditorDefaultEvent());
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
    return Container(
      decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff7DABF6),
                  shape: const CircleBorder(side: BorderSide.none),
                ),
                onPressed: () {
                  widget.main.elementAt(
                      widget.main.indexOf(widget.item))["title"] = newName.text;

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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentItemPreview extends StatefulWidget {
  DocumentItemPreview({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;
  @override
  State<DocumentItemPreview> createState() => _DocumentItemPreviewState();
}

class _DocumentItemPreviewState extends State<DocumentItemPreview> {
  final Color color = midWhite;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: 270,
            height: 160,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 270,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 270,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 270,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 200,
                        height: 20,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Grouping extends StatefulWidget {
  Grouping({
    super.key,
    required this.main,
    required this.selected,
  });
  final List main;
  final Map selected;
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
                  categoriesData = r.categoriesList;
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
                                leading: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: black,
                                  ),
                                  child: const Text("انخاب همه"),
                                  onPressed: () {
                                    widget.main[widget.main
                                            .indexOf(widget.selected)]
                                        ["category"] = {
                                      "group": e["id"],
                                      "subgroup": ""
                                    };
                                    Navigator.of(context).pop();
                                  },
                                ),
                                children: [
                                  ...subGroup.keys.map((i) {
                                    return ListTile(
                                      title: Text(
                                        subGroup[i],
                                        textAlign: TextAlign.end,
                                      ),
                                      onTap: () {
                                        widget.main[widget.main
                                                .indexOf(widget.selected)]
                                            ["category"] = {
                                          "group": e["id"],
                                          "subgroup": i
                                        };
                                        print(i);
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
