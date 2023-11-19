import 'dart:io';

import 'package:admin/Bloc/EditCategoriesBloc/edit_categories_block.dart';
import 'package:admin/Bloc/EditCategoriesBloc/edit_categories_event.dart';
import 'package:admin/Bloc/EditCategoriesBloc/edit_categories_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/GeneralWidgets/upload_process.dart';
import 'package:admin/paths.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../DataModel/data_model.dart';

class EditGroupItem extends StatefulWidget {
  EditGroupItem({
    super.key,
    this.id,
  });
  final String? id;
  @override
  State<EditGroupItem> createState() => _EditGroupItemState();
}

class _EditGroupItemState extends State<EditGroupItem> {
  String name = "";
  TextEditingController newGroupName = TextEditingController();
  FocusNode fNode = FocusNode();
  List<List> subGroup = [];

  String image = "";
  String newImage = "";
  String prevImage = "";

  bool showInHomePage = true;
  bool specialGroup = false;

  bool loaded = false;
  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<EditCategoriesBloc>(context)
          .add(GetSingleCategoryDataEvent(mainGroupId: widget.id!));
    } else {
      BlocProvider.of<EditCategoriesBloc>(context)
          .add(SingleCategoriesDefaultEvent());
    }
    super.initState();
  }

  @override
  void dispose() {
    List flist = AppDataDirectory.categories().listSync();
    for (File f in flist) {
      f.delete();
    }

    super.dispose();
  }

  Widget content() {
    return Expanded(
      child: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            elevation: 2.5,
            forceElevated: true,
            shadowColor: Colors.white.withOpacity(0.5),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            // toolbarHeight: 50,
            leadingWidth: 140,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    BlocProvider.of<EditCategoriesBloc>(context)
                        .add(CategoryInitUploadEvent(name: newGroupName.text));
                  },
                  child: SvgPicture.asset(
                    "assets/images/document-upload.svg",
                    width: 30,
                    height: 30,
                  ),
                ),
                TextButton(
                  onPressed: widget.id != null
                      ? () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              // alignment: Alignment.bottomCenter,
                              backgroundColor: const Color(0xffF0F0F2),
                              elevation: 2,
                              content: const Text(
                                "از حذف این دسته بندی اطمینان دارید؟",
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
                                            foregroundColor: green,
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
                                            backgroundColor: green,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            BlocProvider.of<EditCategoriesBloc>(
                                                    this.context)
                                                .add(CategoriyDeleteEvent(
                                                    mainGroupId:
                                                        widget.id ?? ""));
                                          },
                                          child: const Text("بله")),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      : null,
                  child: SvgPicture.asset(
                    "assets/images/trash.svg",
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  "assets/images/arrow-right2.svg",
                ),
              ),
            ],
          ),
        ],
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Checkbox(
                              activeColor: green,
                              value: showInHomePage,
                              onChanged: (value) {
                                showInHomePage = !showInHomePage;
                                BlocProvider.of<EditCategoriesBloc>(
                                        this.context)
                                    .add(SingleCategoriesDefaultEvent());
                              },
                            ),
                            const Text("نمایش در صفحه اصلی"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Checkbox(
                              activeColor: green,
                              value: specialGroup,
                              onChanged: (value) {
                                specialGroup = !specialGroup;
                                BlocProvider.of<EditCategoriesBloc>(
                                        this.context)
                                    .add(SingleCategoriesDefaultEvent());
                              },
                            ),
                            const Text("گروه ویژه"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: categoriesImage(name: image),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "عنوان",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border:
                          Border.all(color: const Color(0xffF1F5FF), width: 4),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: newGroupName,
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        minLines: 1,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              borderSide:
                                  BorderSide(color: midBlue, width: 1.4)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              borderSide:
                                  BorderSide(color: lightblue, width: 1)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: AddSubGroup(
                                  subGroup: subGroup,
                                  subGroupIndex: null,
                                ));
                          }).then((value) {
                        BlocProvider.of<EditCategoriesBloc>(context)
                            .add(SingleCategoriesDefaultEvent());
                      });
                    },
                    child: SvgPicture.asset(
                      "assets/images/add.svg",
                      color: green,
                    ),
                  ),
                  const SizedBox(width: 40),
                  const Text(
                    ":زیر گروه ها",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex--;
                    }
                    var old = subGroup.removeAt(oldIndex);
                    subGroup.insert(newIndex, old);
                    BlocProvider.of<EditCategoriesBloc>(context)
                        .add(SingleCategoriesDefaultEvent());
                  },
                  children: [
                    ...subGroup.map((e) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        key: UniqueKey(),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, right: 40),
                            height: 40,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0xffF6F6F6),
                            ),
                            child: Row(
                              children: [
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
                                              child: AddSubGroup(
                                                subGroup: subGroup,
                                                subGroupIndex:
                                                    subGroup.indexOf(e),
                                              ));
                                        }).then((value) {
                                      BlocProvider.of<EditCategoriesBloc>(
                                              context)
                                          .add(SingleCategoriesDefaultEvent());
                                    });
                                  },
                                  child: Text(
                                    subGroup[subGroup.indexOf(e)][1],
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    subGroup.removeWhere(
                                      (element) =>
                                          element[0] == e[0] &&
                                          element[1] == e[1],
                                    );
                                    BlocProvider.of<EditCategoriesBloc>(
                                            this.context)
                                        .add(SingleCategoriesDefaultEvent());
                                  },
                                  child: const Icon(
                                    Icons.highlight_remove_outlined,
                                    color: lightgray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map cleanedCategories() {
    Map data = {};
    for (var i in subGroup) {
      data.putIfAbsent(i[0], () => i[1]);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: BlocBuilder<EditCategoriesBloc, EditCategoriesState>(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is CategoriesDataLoadingState) ...[
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
              if (state is InitUploadState) ...[
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 150),
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
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "در حال چک کردن نام گروه",
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
              if (state is CategoryReadyUploadState) ...[
                state.data.fold(
                    (l) => Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 100),
                              // uploadInfo(),
                              const SizedBox(height: 50),
                              UploadError(
                                  error: l,
                                  back: () {
                                    BlocProvider.of<EditCategoriesBloc>(
                                            this.context)
                                        .add(SingleCategoriesDefaultEvent());
                                  },
                                  tryAgain: () async {
                                    BlocProvider.of<EditCategoriesBloc>(
                                            this.context)
                                        .add(CategoryInitUploadEvent(
                                            name: widget.id!));
                                  }),
                            ],
                          ),
                        ), (r) {
                  return Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 150),
                        ExistName(
                          validNameTrue: "نام گروه معتبر است",
                          validNameFalse: "نام گروه از قبل موجود است",
                          exist: r,
                          upload: () async {
                            BlocProvider.of<EditCategoriesBloc>(this.context)
                                .add(CategoryUploadEvent(
                                    singleCategoryDataModel:
                                        SingleCategoryDataModel(
                              name: name.isNotEmpty ? name : newGroupName.text,
                              newName: newGroupName.text,
                              subGroups: cleanedCategories(),
                              image: image,
                              prevImage: prevImage,
                              showinhomepage: showInHomePage,
                              specialGroup: specialGroup,
                            )));
                          },
                          back: () {
                            BlocProvider.of<EditCategoriesBloc>(this.context)
                                .add(SingleCategoriesDefaultEvent());
                          },
                        ),
                      ],
                    ),
                  );
                })
              ],
              if (state is CategoryUploadState) ...[
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 150),
                      Expanded(
                        child: UploadProgress(
                          uploadSuccessTitle: "گروه با موفقیت ایجاد شد",
                          title1: "ایجاد گروه",
                          title2: "آپلود عکس گروه",
                          title3: "گروه حذف عکس قدیمی",
                          error: state.error,
                          uploadProgress: state.uploadProgress,
                          back: () {
                            BlocProvider.of<EditCategoriesBloc>(this.context)
                                .add(SingleCategoriesDefaultEvent());
                          },
                          tryAgain: () async {
                            BlocProvider.of<EditCategoriesBloc>(this.context)
                                .add(CategoryInitUploadEvent(name: widget.id!));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (state is SingleCategoryDataState) ...[
                state.data.fold(
                    (l) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Refresh(
                              onRefresh: () {
                                BlocProvider.of<EditCategoriesBloc>(context)
                                    .add(GetSingleCategoryDataEvent(
                                        mainGroupId: widget.id!));
                              },
                            ),
                          ],
                        ), (r) {
                  if (!loaded) {
                    newGroupName.text = r.name;
                    name = r.name;
                    Map subGroupList = Map.of(r.subGroups);
                    if (subGroup.isEmpty) {
                      for (String e in subGroupList.values) {
                        subGroup.add([e, e]);
                      }
                    }
                    image = r.image;
                    showInHomePage = r.showinhomepage;
                    specialGroup = r.specialGroup;
                    loaded = true;
                  }
                  return content();
                })
              ],
              if (state is SingleCategoriesDefaultState) ...[content()],
              if (state is CategoryDeleteState) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: state.error,
                      builder: (context, error, child) => !error
                          ? ValueListenableBuilder(
                              valueListenable: state.uploadProgress,
                              builder: (context, progress, child) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  progress
                                      ? const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "دسته بندی با موفقیت حذف شد",
                                              style: TextStyle(color: black),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: Color(0xff18DAA3),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: LoadingRing(
                                                lineWidth: 1.5,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              "درحال حذف دسته بندی",
                                              style: TextStyle(color: black),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: black,
                                        disabledBackgroundColor:
                                            const Color(0xffF5F5F5),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      onPressed: progress == true
                                          ? () {
                                              Navigator.of(context).pop();
                                            }
                                          : null,
                                      child: const Text("بازگشت")),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("خطایی رخ داد"),
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
                                          BlocProvider.of<EditCategoriesBloc>(
                                                  this.context)
                                              .add(CategoriyDeleteEvent(
                                                  mainGroupId: widget.id!));
                                        },
                                        child: const Text("تلاش دوباره")),
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
                                          BlocProvider.of<EditCategoriesBloc>(
                                                  this.context)
                                              .add(
                                                  SingleCategoriesDefaultEvent());
                                        },
                                        child: const Text("بازگشت")),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget categoriesImage({
    required String name,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                child: Material(
                  elevation: 6,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  shadowColor: Colors.white.withOpacity(0.8),
                  child: Container(
                    width: 50,
                    height: 50,
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
                        child: image == newImage
                            ? Image.file(
                                File(
                                    "${AppDataDirectory.categories().path}/$image"),
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 50,
                                  height: 50,
                                  color: silver,
                                ),
                              )
                            : ImageItem.Category(
                                imageName: image,
                              ),
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
                    prevImage = image;
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
                        "${AppDataDirectory.categories().path}/$newImageName";
                    // Copying And Naming Image With NewImagePath
                    File(result.files.single.path!).copy(newImagePath);
                    image = newImageName;

                    File prevImage_ = File(
                        "${AppDataDirectory.categories().path}/$prevImage");
                    if (await prevImage_.exists()) {
                      await prevImage_.delete();
                    }

                    image = newImageName;
                    newImage = newImageName;
                    BlocProvider.of<EditCategoriesBloc>(context)
                        .add(SingleCategoriesDefaultEvent());
                  }
                }),
          ],
        ),
        const SizedBox(height: 10),
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: red,
            ),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                  // alignment: Alignment.bottomCenter,
                  backgroundColor: const Color(0xffF0F0F2),
                  elevation: 2,
                  content: const Text(
                    "از حذف عکس اطمینان دارید؟",
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
                                foregroundColor: green,
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
                                backgroundColor: green,
                              ),
                              onPressed: () async {
                                prevImage = image;
                                image = "";
                                newImage = "";
                                File prevImage_ = File(
                                    "${AppDataDirectory.categories().path}/$prevImage");
                                if (await prevImage_.exists()) {
                                  await prevImage_.delete();
                                }
                                Navigator.of(context).pop();
                                BlocProvider.of<EditCategoriesBloc>(
                                        this.context)
                                    .add(SingleCategoriesDefaultEvent());
                              },
                              child: const Text("بله")),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            child: const Text("حذف عکس")),
      ],
    );
  }
}

class AddSubGroup extends StatefulWidget {
  AddSubGroup({
    super.key,
    required this.subGroup,
    required this.subGroupIndex,
  });
  final List<List> subGroup;
  final int? subGroupIndex;
  @override
  State<AddSubGroup> createState() => _AddSubGroupState();
}

class _AddSubGroupState extends State<AddSubGroup> {
  TextEditingController newSubGroupName = TextEditingController();
  FocusNode fNode = FocusNode();
  bool validName = false;
  String? errorText;

  List subGroupsName = [];
  @override
  void initState() {
    print(widget.subGroup);

    // if (widget.subGroupIndex != null) {
    //   newSubGroupName.text = widget.subGroup[widget.subGroupIndex!][1];
    // }
    // for (List i in widget.subGroup) {
    //   subGroupsName.add(i[1]);
    // }
    super.initState();
  }

  @override
  void dispose() {
    print(widget.subGroup);

    super.dispose();
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
                            if (widget.subGroupIndex == null) {
                              widget.subGroup.add(
                                  [newSubGroupName.text, newSubGroupName.text]);
                            } else {
                              String oldName =
                                  widget.subGroup[widget.subGroupIndex!][0];
                              widget.subGroup[widget.subGroupIndex!] = [
                                oldName,
                                newSubGroupName.text
                              ];
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
                      controller: newSubGroupName,
                      textDirection: TextDirection.rtl,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintTextDirection: TextDirection.rtl,
                        focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        hintText: "نام گروه",
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
      if (!subGroupsName.contains(name.replaceAll(" ", ""))) {
        validName = true;
        return null;
      } else {
        validName = false;
        return "این زیر گروه وحود دارد!";
      }
    }
  }
}
