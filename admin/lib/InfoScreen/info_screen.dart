import 'package:admin/Bloc/DocumentBloc/document_block.dart';
import 'package:admin/Bloc/DocumentBloc/document_event.dart';
import 'package:admin/Bloc/InfoBlock/info_block.dart';
import 'package:admin/Bloc/InfoBlock/info_event.dart';
import 'package:admin/Bloc/InfoBlock/info_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/DocumentOnline/TextBoxItem/paragraph_editor.dart';
import 'package:admin/DocumentOnline/TextBoxItem/textbox.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum Info { termsAndConditions, aboutUs }

class InfoScreen extends StatefulWidget {
  InfoScreen({super.key, required this.info});
  final Info info;
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
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
  // -----------------------------------------------------------
  bool loaded = false;
  // -----------------------------------------------------------
  List reorderItems_ = [];
  ValueNotifier isReorderItems = ValueNotifier(false);
  List<Widget> buildItems(List body) {
    return [
      ...body.map((item) {
        if (item["type"] == "textbox") {
          return TextBoxBuilder(
            reload: () {
              BlocProvider.of<InfoBloc>(this.context).add(InfoEditEvent());
            },
            document: document,
            textBox: item,
            textBoxIndex: body.indexOf(item),
            textSizeFactor: 1.0,
            clickable: !isReorderItems.value,
          );
        }
        //  else {
        //   if (item["type"] == "image") {
        //     return const Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //       child: SizedBox(),
        //       // image(name: item["name"], index: document.body.indexOf(item)),
        //     );
        //   }
        // }
        else {
          return Container();
        }
      })
    ];
  }

  Widget content() {
    return Column(
      children: [
        const SizedBox(height: 20),
        ...buildItems(document.body),
        const SizedBox(height: 30),
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
      BlocProvider.of<InfoBloc>(this.context).add(InfoEditEvent());
    });
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
            child: Icon(
              Iconsax.repeat,
              color: isReorderItems.value ? Colors.white : black,
            ),
          ),
          TextButton(
            child: Icon(
              Iconsax.text,
              color: black,
            ),
            onPressed: () async {
              await Future(addTextBox);
              BlocProvider.of<DocumentOnlineBloc>(this.context)
                  .add(InitDocumentEditEvent());
            },
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: black,
            ),
            onPressed: () {
              setState(() {
                isReorderItems.value = !isReorderItems.value;
              });
            },
            child: const Text("لغو")),
        const SizedBox(width: 40),
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: black,
            ),
            onPressed: () async {
              document.body = reorderItems_;
              isReorderItems.value = !isReorderItems.value;
            },
            child: const Text("تایید")),
      ],
    );
  }

  @override
  void initState() {
    if (widget.info == Info.termsAndConditions) {
      BlocProvider.of<InfoBloc>(context).add(GetTermsAndConditionsData());
    }
    if (widget.info == Info.aboutUs) {
      BlocProvider.of<InfoBloc>(context).add(GetAboutUsData());
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget editScreen() {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                forceElevated: true,
                elevation: 2.5,
                shadowColor: Colors.white.withOpacity(0.5),
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                // surfaceTintColor: Colors.white,
                stretch: false,
                leadingWidth: 80,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () async {
                            BlocProvider.of<InfoBloc>(this.context)
                                .add(InitInfoUploadEvent());
                          },
                          child: SvgPicture.asset(
                            "assets/images/document-upload.svg",
                            width: 30,
                            height: 30,
                          ),
                        ),
                        // SizedBox(width: 10),
                      ],
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
            body: ValueListenableBuilder(
              valueListenable: isReorderItems,
              builder: (context, value, child) => value
                  ? reorderItems()
                  : SingleChildScrollView(
                      child: content(),
                    ),
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              shadowColor: white,
              elevation: 2,
              child: Container(
                // padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child:
                    isReorderItems.value ? reorderActions() : appBarActions(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<InfoBloc, InfoState>(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is InfoLoadingState) ...[
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
              if (state is InfoDataState) ...[
                state.infoData.fold((l) {
                  return Text(l);
                }, (r) {
                  if (!loaded) {
                    document.body = r;

                    loaded = true;
                  }
                  return editScreen();
                }),
              ],
              if (state is InfoEditState) ...[
                editScreen(),
              ],
              if (state is InitInfoUploadState) ...[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "آپلود شود؟",
                            style: TextStyle(color: black),
                          ),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onPressed: () async {
                                if (widget.info == Info.termsAndConditions) {
                                  BlocProvider.of<InfoBloc>(context).add(
                                      UploadTermsAndConditionsEvent(
                                          termsAndConditions: document.body));
                                }
                                if (widget.info == Info.aboutUs) {
                                  BlocProvider.of<InfoBloc>(context).add(
                                      UploadAboutUsEvent(
                                          aboutUs: document.body));
                                }
                              },
                              child: const Text("آپلود")),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                disabledBackgroundColor:
                                    const Color(0xffF5F5F5),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onPressed: () {
                                BlocProvider.of<InfoBloc>(context)
                                    .add(InfoEditEvent());
                              },
                              child: const Text("بازگشت")),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (state is OnUploadInfoDataState) ...[
                ValueListenableBuilder(
                  valueListenable: state.error,
                  builder: (context, error, child) => !error
                      ? ValueListenableBuilder(
                          valueListenable: state.uploadProgress,
                          builder: (context, progress, child) => Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Column(
                                            children: [
                                              Visibility(
                                                visible: progress,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "با موفقیت آپلود شد",
                                                      style: TextStyle(
                                                          color: black),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline_rounded,
                                                      color: green,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: !progress,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: SpinKitThreeBounce(
                                                        color: green,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    800),
                                                        size: 16,
                                                        // strokeWidth: 2,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "درحال آپلود",
                                                      style: TextStyle(
                                                          color: black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: green,
                                          disabledBackgroundColor:
                                              const Color(0xffF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: progress
                                            ? () {
                                                BlocProvider.of<InfoBloc>(
                                                        context)
                                                    .add(InfoEditEvent());
                                              }
                                            : null,
                                        child: const Text("بازگشت")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("خطایی رخ داد"),
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
                                          if (widget.info ==
                                              Info.termsAndConditions) {
                                            BlocProvider.of<InfoBloc>(context)
                                                .add(
                                                    UploadTermsAndConditionsEvent(
                                                        termsAndConditions:
                                                            document.body));
                                          }
                                          if (widget.info == Info.aboutUs) {
                                            BlocProvider.of<InfoBloc>(context)
                                                .add(UploadAboutUsEvent(
                                                    aboutUs: document.body));
                                          }
                                        },
                                        child: const Text("تلاش دوباره")),
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
                                          BlocProvider.of<InfoBloc>(context)
                                              .add(InfoEditEvent());
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
            ],
          ),
        ),
      ),
    );
  }
}
