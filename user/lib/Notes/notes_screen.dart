import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:user/Bloc/NotesBloc/notes_block.dart';
import 'package:user/Bloc/NotesBloc/notes_event.dart';
import 'package:user/Bloc/NotesBloc/notes_state.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DocumentOnline/document_item.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/no_login.dart';
import 'package:user/GeneralWidgets/refresh.dart';
import 'package:user/iconsax_icons.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final ScrollController _controller = ScrollController();
  List docs = [];
  String orderedBy = "default";

  @override
  void initState() {
    BlocProvider.of<NotesBloc>(context)
        .add(GetNotesEvent(offset: 0, order: orderedBy));
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        BlocProvider.of<NotesBloc>(context)
            .add(LoadMoreNotesEvent(offset: docs.length, order: orderedBy));
      }
    });
    super.initState();
  }

  void order(String order) {
    docs = [];
    orderedBy = order;
    BlocProvider.of<NotesBloc>(context)
        .add(GetNotesEvent(offset: 0, order: order));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) => Scaffold(
        // backgroundColor: Colors.white,
        backgroundColor: Colors.white,
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: state is! NoLoginState ? true : false,
              pinned: state is! NoLoginState ? false : true,
              forceElevated: true,
              backgroundColor: Colors.white,
              elevation: 2.5,
              shadowColor: Colors.white.withOpacity(0.5),
              leading: const SizedBox(),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          const Text(
                            "یادداشت ها",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0B1B3F),
                                fontSize: 16),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Iconsax.document_text_1,
                            color: black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(
                    state is! NoLoginState ? kToolbarHeight : 0),
                child: Column(
                  children: [
                    if (state is! NoLoginState) ...[
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: state is NotesLoadingState
                                  ? null
                                  : () {
                                      if (orderedBy != "newest") {
                                        order("newest");
                                      }
                                    },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: orderedBy == "newest"
                                      ? accent_blue
                                      : Colors.white,
                                  border: Border.all(
                                    color: orderedBy == "newest"
                                        ? accent_blue
                                        : lightblue,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  "جدیدترین",
                                  style: TextStyle(
                                    color: orderedBy == "newest"
                                        ? Colors.white
                                        : accent_blue,
                                    fontWeight: orderedBy == "newest"
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: state is NotesLoadingState
                                  ? null
                                  : () {
                                      if (orderedBy != "document") {
                                        order("document");
                                      }
                                    },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: orderedBy == "document"
                                      ? accent_blue
                                      : Colors.white,
                                  border: Border.all(
                                    color: orderedBy == "document"
                                        ? accent_blue
                                        : lightblue,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  "عنوان مطلب",
                                  style: TextStyle(
                                    color: orderedBy == "document"
                                        ? Colors.white
                                        : accent_blue,
                                    fontWeight: orderedBy == "document"
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: state is NotesLoadingState
                                  ? null
                                  : () {
                                      if (orderedBy != "default") {
                                        order("default");
                                      }
                                    },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: orderedBy == "default"
                                      ? accent_blue
                                      : Colors.white,
                                  border: Border.all(
                                    color: orderedBy == "default"
                                        ? accent_blue
                                        : lightblue,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  "همه یادداشتها",
                                  style: TextStyle(
                                    color: orderedBy == "default"
                                        ? Colors.white
                                        : accent_blue,
                                    fontWeight: orderedBy == "default"
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is RemoveErrorState) ...[
                Refresh(
                  onRefresh: () {
                    BlocProvider.of<NotesBloc>(context)
                        .add(GetNotesEvent(offset: 0, order: orderedBy));
                  },
                ),
              ],
              if (state is NoLoginState) ...[
                Expanded(
                  child: NoLogin2(
                      title: "!هنوز وارد حساب کاربریتان نشدید",
                      subTitle:
                          "برای مشاهده یادداشت هایی که ذخیره کردید وارد حساب کاربریتان شوید"),
                ),
              ],
              if (state is NotesLoadingState) ...[
                LoadingRing(
                  lineWidth: 1.5,
                  size: 50,
                ),
              ],
              if (state is NotesDataState) ...[
                state.notes.fold((l) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Refresh(
                        onRefresh: () {
                          docs = [];
                          BlocProvider.of<NotesBloc>(context)
                              .add(GetNotesEvent(offset: 0, order: orderedBy));
                        },
                      ),
                    ],
                  );
                }, (r) {
                  docs.addAll(r.notes);
                  return Expanded(
                      child: RefreshIndicator(
                    color: black,
                    backgroundColor: white,
                    strokeWidth: 1.8,
                    onRefresh: () async {
                      docs = [];
                      BlocProvider.of<NotesBloc>(context)
                          .add(GetNotesEvent(offset: 0, order: orderedBy));
                    },
                    child: ListView(children: [
                      const SizedBox(height: 10),
                      ...docs.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            children: [
                              NoteItem(
                                note: Map.of(jsonDecode(
                                    docs[docs.indexOf(e)]["textBox"])),
                                document: docs[docs.indexOf(e)],
                                remove: (int id) {
                                  Get.bottomSheet(
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "از حذف این یادداشت مطمعن هستید؟",
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                                0xffF5F5F5),
                                                        foregroundColor: black,
                                                        minimumSize:
                                                            const Size(100, 40),
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text("خیر")),
                                                  const SizedBox(width: 40),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: red,
                                                        minimumSize:
                                                            const Size(100, 40),
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                      ),
                                                      onPressed: () {
                                                        BlocProvider
                                                                .of<NotesBloc>(
                                                                    this
                                                                        .context)
                                                            .add(RemoveNoteEvent(
                                                                itemId: docs[docs
                                                                            .indexOf(e)]
                                                                        [
                                                                        "textBoxId"]
                                                                    .toString(),
                                                                documentId:
                                                                    id));
                                                        Get.back();
                                                      },
                                                      child: const Text("بله")),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Divider(
                                color: lightgray,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: r.next,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: LoadingRing(
                                lineWidth: 1.5,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ));
                  // : Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                  //     child: Column(
                  //       children: [
                  //         Image.asset("assets/images/empty_screen.png",
                  //             width: 300),
                  //         Container(
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 20, vertical: 10),
                  //           margin: const EdgeInsets.symmetric(
                  //               vertical: 20, horizontal: 10),
                  //           decoration: BoxDecoration(
                  //             borderRadius: const BorderRadius.all(
                  //                 Radius.circular(10)),
                  //             border: Border.all(
                  //                 color: const Color(0xffECEEF4), width: 2),
                  //             color: const Color(0xffF9FAFE),
                  //           ),
                  //           child: Column(
                  //             children: const [
                  //               Text(
                  //                 "هنوز یادداشتی را اضافه نکردید\nبا افزودن یادداشت ها، دسترسی سریعتری به قسمت های مورد نظر هر روضه دارید.",
                  //                 textAlign: TextAlign.center,
                  //                 textDirection: TextDirection.rtl,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
