import 'package:admin/Bloc/DocumentBloc/document_block.dart';
import 'package:admin/Bloc/DocumentBloc/document_event.dart';
import 'package:admin/Bloc/DocumentBloc/document_state.dart';
import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_bloc.dart';
import 'package:admin/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:admin/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:admin/Bloc/SearchBloc/search_block.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/DocumentOnline/document_edit_online.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/PageManager/pagemanager.dart';
import 'package:admin/DocumentOnline/textbox.dart';
import 'package:admin/Home/fetch_documents.dart';
import 'package:admin/Home/search_screen.dart';
import 'package:admin/MainScreen/main_screen.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

enum TextResize { show, hide }

class DocumentOnline extends StatefulWidget {
  DocumentOnline({
    super.key,
    required this.id,
  });
  final String id;
  @override
  State<DocumentOnline> createState() => _DocumentOnlineState();
}

class _DocumentOnlineState extends State<DocumentOnline> {
  OrdinaryDocumentDataModel document = OrdinaryDocumentDataModel(
    name: "",
    id: 0,
    mainimage: "",
    body: [],
    isSubscription: false,
    labels: [],
    group: "",
    subGroup: "",
    groupId: "",
    subGroupId: "",
    creationDate: {},
    likes: "0",
    audioList: [],
    recommended: [],
  );
  PageManager pm = PageManager(audioPath: null, source: AudioSource.url);
  List<Map<String, Map<String, PageManager>>> audioList = [];
  bool firstPlay = false;
  ScrollController controller = ScrollController();
  ValueNotifier<double> textSize = ValueNotifier<double>(1.0);
  // -----------------------------------------------------------
  bool isTextResize = false;
  // ValueNotifier textSizeFactor = ValueNotifier(1.0);
  // -----------------------------------------------------------
  List<Widget> buildItems() {
    List items = List.of(document.body);
    return [
      ...items.map((item) {
        if (item["type"] == "textbox") {
          return ValueListenableBuilder<double>(
            valueListenable: textSize,
            builder: (context, value, child) => TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(100, 100),
              ),
              onPressed: (item["noteable"] || item["enableLink"])
                  ? () async {
                      if (item["enableLink"]) {
                        if (!await launchUrl(Uri.parse(item["link"]),
                            mode: LaunchMode.externalApplication)) {
                          throw "";
                        }
                      }
                    }
                  : null,
              child: TextBoxOnlineBuilder(
                textBox: item,
                textSizeFactor: value,
              ),
            ),
          );
        } else {
          if (item["type"] == "image") {
            return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: CachedNetworkImage(
                      imageUrl:
                          "http://mhdlt.ir/DocumentsData/${document.name}/${item['name']}",
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/place_holder.png"),
                      placeholder: (context, url) =>
                          Image.asset("assets/images/place_holder.png"),
                      fadeInCurve: Curves.linear,
                      fadeOutCurve: Curves.linear,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                    ),
                  ),
                ));
          } else {
            return Container();
          }
        }
      })
    ];
  }

  Widget recommendedList(String title, List doc) {
    return Container(
      // color: const green,
      // height: 200,
      // color: black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: [
                ...doc.map((e) => e["name"] != document.name
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 20),
                        child: FullDetailsItem(
                          document: e,
                          showInWrap: false,
                        ),
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ],
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
                  const SizedBox(height: 16),
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
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xffDCE4FB),
                                  padding: EdgeInsets.zero,
                                  backgroundColor: midWhite,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => SearchBloc(),
                                      child: Scaffold(
                                          backgroundColor: Colors.white,
                                          body: SearchScreen(
                                            preSearch: e,
                                            onDelete: false,
                                            preDocumentId: int.parse(widget.id),
                                          )),
                                    ),
                                  ));
                                },
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    e,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: black),
                                  ),
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
            ),
            Column(
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

  Widget header(String name, String mainImage, Map creationDate, String group,
      String subGroup, String likes) {
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
                          child: ImageItem.Item(
                            documentName: name,
                            imageName: mainImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Color(0xffFFF4E2),
                      ),
                      child: Center(
                        child: Text(
                          document.isSubscription ? "اشتراکی" : "رایگان",
                          style: const TextStyle(
                              color: Color(0xffEB6116),
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => FetchDocumentsBloc(),
                      child: FetchDocuments(
                        title: group,
                        by: "newest",
                        fromCategories: GroupSubgroup(
                          group: document.groupId,
                          subGroup: "",
                        ),
                        ignoredDocumentId: document.id,
                      ),
                    ),
                  ));
                },
                child: Text(
                  group,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff66728C),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => FetchDocumentsBloc(),
                      child: FetchDocuments(
                        title: group,
                        by: "newest",
                        fromCategories: GroupSubgroup(
                          group: document.groupId,
                          subGroup: document.subGroupId,
                        ),
                        ignoredDocumentId: document.id,
                      ),
                    ),
                  ));
                },
                child: Text(
                  subGroup,
                  style: const TextStyle(
                    color: Color(0xff66728C),
                    fontWeight: FontWeight.normal,
                    // fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.heart,
                          color: Color(0xff5E83EE),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          persianNumber(likes),
                          style: const TextStyle(
                            color: Color(0xff5E83EE),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {},
                    child: const Column(
                      children: [
                        Icon(
                          Icons.bookmark_add_outlined,
                          size: 26,
                          color: Color(0xff5E83EE),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              date(creationDate),
            ],
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
        header(
          document.name,
          document.mainimage,
          document.creationDate,
          document.group,
          document.subGroup,
          document.likes,
        ),
        ...buildItems(),
        const SizedBox(height: 30),
        labels(),
        const SizedBox(height: 40),
        Visibility(
          visible: document.recommended.isNotEmpty,
          child: recommendedList("جدیدترین مطالب مرتبط", document.recommended),
        ),
      ],
    );
  }

  // -----------------------------------------------------------

  @override
  void initState() {
    BlocProvider.of<DocumentOnlineBloc>(context)
        .add(GetOrdinaryDocumentEvent(id: int.parse(widget.id)));
    super.initState();
  }

  @override
  void dispose() {
    // if ((pm.player.state == PlayerState.stopped ||
    //     pm.player.state == PlayerState.paused)) {
    //   BlocProvider.of<MainScreenBloc>(mainScreenContext.get())
    //       .add(MainScreenDisposeAudioEvent(name: widget.name));
    // }

    () async {
      await pm.dispose();
    }();
    super.dispose();
  }

  String persianNumber(String dateEn) {
    String date = dateEn;
    Map numbers = {
      "0": "۰",
      "1": "۱",
      "2": "۲",
      "3": "۳",
      "4": "۴",
      "5": "۵",
      "6": "۶",
      "7": "۷",
      "8": "۸",
      "9": "۹",
    };
    for (String i in numbers.keys) {
      date = date.replaceAll(RegExp(i), numbers[i]);
    }
    return date;
  }

  Widget date(Map dateTime) {
    TextStyle strStyle = TextStyle(color: Colors.grey.shade500, fontSize: 12);
    TextStyle numberStyle =
        TextStyle(color: Colors.grey.shade500, fontSize: 14);
    Widget elapsedTime = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          " دقیقه قبل",
          style: strStyle,
        ),
        const SizedBox(width: 2),
        Text(
          "۱",
          style: numberStyle,
        ),
      ],
    );
    if (int.parse(dateTime["year"]) != 0 ||
        int.parse(dateTime["month"]) != 0 ||
        int.parse(dateTime["day"]) != 0) {
      elapsedTime = Text(
        dateTime["date"],
        style: strStyle,
      );
    } else if (int.parse(dateTime["hour"]) != 0) {
      elapsedTime = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ساعت پیش",
            style: strStyle,
          ),
          const SizedBox(width: 2),
          Text(
            persianNumber(dateTime["hour"]),
            style: numberStyle,
          ),
        ],
      );
    } else if (int.parse(dateTime["minute"]) != 0) {
      elapsedTime = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            " دقیقه پیش",
            style: strStyle,
          ),
          const SizedBox(width: 2),
          Text(
            persianNumber(dateTime["minute"]),
            style: numberStyle,
          ),
        ],
      );
    }

    return elapsedTime;
  }

  Widget textSizeSlider() {
    return ValueListenableBuilder(
      valueListenable: textSize,
      builder: (context, value, child) => Container(
        color: white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "الف",
              style: TextStyle(fontSize: 14),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: blue,
                  inactiveTrackColor: silver,
                  disabledInactiveTrackColor: silver,
                  disabledActiveTrackColor: silver,
                  disabledThumbColor: blue,
                  thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 4, elevation: 0, pressedElevation: 0),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20),
                  trackHeight: 1,
                ),
                child: Slider(
                  min: 0.5,
                  max: 2.0,
                  divisions: 10,
                  value: textSize.value,
                  thumbColor: blue,
                  activeColor: blue,
                  onChanged: (value) async {
                    textSize.value = value;
                  },
                ),
              ),
            ),
            const Text(
              "الف",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  ValueNotifier bookmarkButton = ValueNotifier(200.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<DocumentOnlineBloc, DocumentOnlineState>(
          builder: (context, state) =>
              NotificationListener<UserScrollNotification>(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  // pinned: true,
                  floating: true,
                  elevation: 2,
                  shadowColor: Colors.white.withOpacity(0.6),
                  // forceElevated: true,
                  foregroundColor: black,
                  title: const SizedBox(),
                  leading: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.arrow_left_2,
                            color: Color(0xff5E83EE),
                            // size: 40,
                          ),
                        ],
                      )),
                  actions: [
                    ValueListenableBuilder(
                      valueListenable: ValueNotifier(state),
                      builder: (context, value, child) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: value is! DocumentLoadingState,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: value is DocumentDataState
                                      ? () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                create: (context) =>
                                                    DocumentOnlineBloc(),
                                                child: DocumentEditor(
                                                  id: int.parse(widget.id),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: SvgPicture.asset(
                                    "assets/images/edit.svg",
                                    color: const Color(0xff5E83EE),
                                  ),
                                ),
                                // TextButton(
                                //   style: TextButton.styleFrom(
                                //     padding: EdgeInsets.zero,
                                //   ),
                                //   onPressed: state is! DocumentLoadingState
                                //       ? () {
                                //           setState(() {
                                //             isTextResize = !isTextResize;
                                //           });
                                //         }
                                //       : null,
                                //   child: Icon(
                                //     Iconsax.text,
                                //     color: state is! DocumentLoadingState
                                //         ? black
                                //         : lightgray,
                                //   ),
                                // ),

                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: state is! DocumentLoadingState
                                      ? document.audioList.isNotEmpty
                                          ? () {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  builder: (context) {
                                                    return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom,
                                                        ),
                                                        child: AudioListOnline(
                                                            audioList:
                                                                audioList,
                                                            documentName:
                                                                document.name,
                                                            pm: pm,
                                                            setAudio: (PageManager
                                                                audio) async {
                                                              pm.pause();
                                                              pm = audio;
                                                            }));
                                                  });
                                            }
                                          : null
                                      : null,
                                  child: Icon(
                                    Iconsax.headphone5,
                                    color: document.audioList.isNotEmpty
                                        ? const Color(0xff5E83EE)
                                        : lightgray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  toolbarHeight:
                      isTextResize ? kToolbarHeight + 36 : kToolbarHeight,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: isTextResize ? textSizeSlider() : const SizedBox(),
                  ),
                ),
                if (state is DocumentLoadingState) ...[
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingRing(
                          color: const Color(0xff5E83EE),
                          lineWidth: 1.5,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ],
                if (state is DocumentDataState) ...[
                  // const SizedBox(height: 10),
                  state.data.fold(
                    (l) {
                      return SliverFillRemaining(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Refresh(onRefresh: () {
                              BlocProvider.of<DocumentOnlineBloc>(context).add(
                                  GetOrdinaryDocumentEvent(
                                      id: int.parse(widget.id)));
                            }),
                          ],
                        ),
                      );
                    },
                    (r) {
                      document = r;
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

                      return SliverToBoxAdapter(child: content());
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget musicPlayer() {
    return SizedBox(
      height: 60,
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
                              style: TextStyle(
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
                                            if (!firstPlay) {
                                              BlocProvider.of<MainScreenBloc>(
                                                      mainScreenContext.get())
                                                  .add(MainScreenSetAudioEvent(
                                                name: document.name,
                                                curentAudio: pm,
                                                mainImage: document.mainimage,
                                              ));

                                              firstPlay = true;
                                            }
                                            pm.play();
                                          },
                                          child: Icon(
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
                                          child: Icon(
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
                              style: TextStyle(color: black),
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

class AudioListOnline extends StatefulWidget {
  AudioListOnline(
      {super.key,
      required this.documentName,
      required this.audioList,
      required this.pm,
      required this.setAudio});
  final String documentName;
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
    return Column(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
            ),
          )),
        ],
      ],
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child:
                                Icon(Iconsax.clock, size: 18, color: lightgray),
                          ),
                          const SizedBox(width: 6),
                          value
                              ? ValueListenableBuilder(
                                  valueListenable: audio.progressNotifier,
                                  builder: (context, value, child) => Text(
                                    "${(value.total.inSeconds / 60).floor()}:${(value.total.inSeconds % 60).floor() < 10 ? 0 : ''}${(value.total.inSeconds % 60).floor()}",
                                    style: TextStyle(color: black),
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
                                  style: TextStyle(
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
                              style: TextStyle(
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
                                          child: Icon(
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
                                          child: Icon(
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
                              style: TextStyle(color: black),
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

class DocumentShimmer extends StatelessWidget {
  DocumentShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // const SizedBox(height: 10),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 180,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffF0F0EE),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 26,
                                      width: 140,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffF0F0EE),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 26,
                                      width: 120,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffF0F0EE),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 16,
                                      width: 100,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        color: const Color(0xffF0F0EE),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 20),
              ],
            ),

            const SizedBox(height: 40),

            Column(
              children: [
                text(MediaQuery.of(context).size.width - 200, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 100, 20),
                const SizedBox(height: 40),
                text(MediaQuery.of(context).size.width - 100, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 40, 20),
                text(MediaQuery.of(context).size.width - 200, 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget text(double width, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              color: Color(0xffF0F0EE),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget labels() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    direction: Axis.horizontal,
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 24,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xffF0F0EE),
                          // color: Color.fromRGBO(82, 99, 252, 0.5),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 24,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xffF0F0EE),
                          // color: Color.fromRGBO(82, 99, 252, 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 100,
                height: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xffF0F0EE),
                  // color: Color.fromRGBO(82, 99, 252, 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Preview extends StatelessWidget {
  Preview({
    super.key,
    required this.name,
    required this.mainImage,
    required this.group,
    required this.subGroup,
    required this.likes,
    required this.creationDate,
    required this.isSubscription,
  });
  final String name;
  final String mainImage;
  final String group;
  final String subGroup;
  final String likes;
  final Map creationDate;
  final bool isSubscription;

  final double imgWidth = 200;
  final double imgHeight = 200;

  String persianNumber(String dateEn) {
    String date = dateEn;
    Map numbers = {
      "0": "۰",
      "1": "۱",
      "2": "۲",
      "3": "۳",
      "4": "۴",
      "5": "۵",
      "6": "۶",
      "7": "۷",
      "8": "۸",
      "9": "۹",
    };
    for (String i in numbers.keys) {
      date = date.replaceAll(RegExp(i), numbers[i]);
    }
    return date;
  }

  Widget date(Map dateTime) {
    TextStyle strStyle = TextStyle(color: Colors.grey.shade500, fontSize: 12);
    TextStyle numberStyle =
        TextStyle(color: Colors.grey.shade500, fontSize: 14);
    Widget elapsedTime = Row(
      children: [
        Text(
          " دقیقه قبل",
          style: strStyle,
        ),
        const SizedBox(width: 2),
        Text(
          "۱",
          style: numberStyle,
        ),
      ],
    );
    if (int.parse(dateTime["year"]) != 0 ||
        int.parse(dateTime["month"]) != 0 ||
        int.parse(dateTime["day"]) != 0) {
      elapsedTime = Text(
        dateTime["date"],
        style: strStyle,
      );
    } else if (int.parse(dateTime["hour"]) != 0) {
      elapsedTime = Row(
        children: [
          Text(
            "ساعت پیش",
            style: strStyle,
          ),
          const SizedBox(width: 2),
          Text(
            "${persianNumber(dateTime["hour"])} ",
            style: numberStyle,
          ),
        ],
      );
    } else if (int.parse(dateTime["minute"]) != 0) {
      elapsedTime = Row(
        children: [
          Text(
            " دقیقه پیش",
            style: strStyle,
          ),
          const SizedBox(width: 2),
          Text(
            persianNumber(dateTime["minute"]),
            style: numberStyle,
          ),
        ],
      );
    }
    return elapsedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          date(creationDate),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: TextStyle(
                                  color: black,
                                  fontSize: 12,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Icon(
                                Iconsax.heart,
                                color: black,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                persianNumber(likes),
                                // "222",
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: ImageItem.Item(
                      documentName: name,
                      imageName: mainImage,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xffF1F5FF),
                  ),
                  child: Text(
                    subGroup,
                    style: const TextStyle(
                      color: Color(0xff848DA2),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    // color: Color(0xffFBF0CC),
                    color: Color(0xffF1F5FF),

                    // color: Color.fromRGBO(82, 99, 252, 0.5),
                  ),
                  child: Text(
                    group,
                    style: const TextStyle(
                        color: Color(0xff848DA2),
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;
  HeaderDelegate({required this.tabBar});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: Column(
        children: [
          tabBar,
        ],
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
