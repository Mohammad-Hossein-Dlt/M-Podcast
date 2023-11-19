import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/Bloc/FetchDocumentsBloc/all_documents_bloc.dart';
import 'package:user/Bloc/DocumentBloc/document_block.dart';
import 'package:user/Bloc/DocumentBloc/document_event.dart';
import 'package:user/Bloc/DocumentBloc/document_state.dart';
import 'package:user/Bloc/SearchBloc/search_block.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DataModel/data_model.dart';
import 'package:user/DocumentOnline/document_item.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/no_login.dart';
import 'package:user/GeneralWidgets/no_subscription.dart';
import 'package:user/GeneralWidgets/refresh.dart';
import 'package:user/PageManager/pagemanager.dart';
import 'package:user/DocumentOnline/textbox.dart';
import 'package:user/Home/fetch_documents.dart';
import 'package:user/Home/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/User/user.dart';
import 'package:user/iconsax_icons.dart';

enum TextResize { show, hide }

class DocumentOnline extends StatefulWidget {
  DocumentOnline({
    super.key,
    required this.id,
    this.pm,
  });
  final String id;

  final PageManager? pm;

  @override
  State<DocumentOnline> createState() => _DocumentOnlineState();
}

enum AudioListState { default_, refresh }

PageManager pm = PageManager(fileName: null, documentName: null);
String curentAudioName = "";
ValueNotifier refreshAudioList =
    ValueNotifier<AudioListState>(AudioListState.default_);

class _DocumentOnlineState extends State<DocumentOnline> {
  PageManager pmHolder = PageManager(fileName: null, documentName: null);
  String curentAudioNameHolder = "";
  DocumentDataModel document = DocumentDataModel(
    name: "",
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
    id: 0,
    permission: false,
    isLiked: false,
    isBookmarked: false,
    audioList: [],
    recommended: [],
  );
  // List<Map<String, Map<String, PageManager>>> audioList = [];
  List<Map<String, PageManager>> audioList = [];
  OnRefresh onRefresh = OnRefresh.none;
  ValueNotifier<double> textSize = ValueNotifier<double>(1.0);
  String onNotingText = "درحال اضافه کردن به یادداشت ها";
  // -----------------------------------------------------------
  bool isTextResize = false;
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
                  ? onRefresh == OnRefresh.none
                      ? () async {
                          if (item["noteable"]) {
                            onNotingText = item["noted"]
                                ? "در حال حذف از یادداشت ها"
                                : "درحال اضافه کردن به یادداشت ها";
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
                                        Text(
                                          item["noted"]
                                              ? "این متن از یادداشت ها حذف شود؟"
                                              : "این متن به یادداشت ها اضافه شود؟",
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xffF5F5F5),
                                                  foregroundColor: black,
                                                  minimumSize:
                                                      const Size(100, 40),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text("خیر")),
                                            const SizedBox(width: 20),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: item["noted"]
                                                      ? red
                                                      : blue,
                                                  minimumSize:
                                                      const Size(120, 40),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                ),
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              DocumentOnlineBloc>(
                                                          this.context)
                                                      .add(
                                                    NoteEvent(
                                                      itemId: item["id"],
                                                      id: document.id,
                                                      ctx: this.context,
                                                    ),
                                                  );
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
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                            );
                          }
                          if (item["enableLink"]) {
                            if (!await launchUrl(Uri.parse(item["link"]),
                                mode: LaunchMode.externalApplication)) {
                              throw "";
                            }
                          }
                        }
                      : null
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
      color: black,
      child: Column(
        children: [
          const SizedBox(height: 10),
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
                      style: const TextStyle(
                          color: Colors.white,
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
                ...doc.map(
                  (e) => e["name"] != document.name
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: FullDetailsItem(
                            document: e,
                            showInWrap: false,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.zero,
                                  backgroundColor: midWhite,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  pm.pause();
                                  pmHolder = pm;
                                  curentAudioNameHolder = curentAudioName;
                                  Get.to(
                                    BlocProvider(
                                      create: (context) => SearchBloc(),
                                      child: Scaffold(
                                        backgroundColor: Colors.white,
                                        body: SearchScreen(
                                          preSearch: e,
                                          ignoredDocumentId: document.id,
                                        ),
                                      ),
                                    ),
                                  )?.then((value) {
                                    pm = pmHolder;
                                    curentAudioName = curentAudioNameHolder;
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      e,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.normal,
                                      ),
                                    ),
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

  Widget header(String name, String mainImage, Map creationDate, String group,
      String subGroup, String likes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: onRefresh == OnRefresh.none
                        ? () {
                            if (document.isLiked || document.permission) {
                              BlocProvider.of<DocumentOnlineBloc>(context).add(
                                LikeDocumentEvent(
                                  ctx: this.context,
                                  id: document.id,
                                ),
                              );
                            }
                          }
                        : null,
                    child: onRefresh == OnRefresh.like
                        ? LoadingRing(
                            color: red,
                            lineWidth: 1.5,
                            size: 20,
                          )
                        : Row(
                            children: [
                              Icon(
                                document.isLiked
                                    ? Iconsax.heart5
                                    : Iconsax.heart,
                                color: document.isLiked
                                    ? red
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(width: 4),
                              PersianNumber(
                                number: likes,
                                style: TextStyle(
                                  color: document.isLiked
                                      ? red
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: document.permission
                        ? onRefresh == OnRefresh.none
                            ? () {
                                BlocProvider.of<DocumentOnlineBloc>(context)
                                    .add(
                                  AddDocumentToFavoritesEvent(
                                    ctx: this.context,
                                    id: document.id,
                                  ),
                                );
                              }
                            : null
                        : null,
                    child: Column(
                      children: [
                        onRefresh == OnRefresh.addToFavorites
                            ? LoadingRing(
                                color: const Color(0xff1C1F2E),
                                lineWidth: 1.5,
                                size: 20,
                              )
                            : Icon(
                                document.isBookmarked
                                    ? Icons.bookmark_added_rounded
                                    : Icons.bookmark_add_outlined,
                                size: 26,
                                color: document.isBookmarked
                                    ? accent_blue
                                    : Colors.grey.shade400,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              DateElement(
                date: creationDate,
                strStyle: TextStyle(
                    color: Colors.grey.shade400,
                    // fontSize: 12,
                    fontWeight: FontWeight.bold),
                numberStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    name,
                    // textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: const TextStyle(
                        color: black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Shabnam"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                onPressed: () {
                  pm.pause();
                  pmHolder = pm;
                  curentAudioNameHolder = curentAudioName;

                  Get.to(
                    BlocProvider(
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
                  )?.then((value) {
                    pm = pmHolder;
                    curentAudioName = curentAudioNameHolder;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: Text(
                    group,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: black,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () {
                  pm.pause();
                  pmHolder = pm;
                  curentAudioNameHolder = curentAudioName;

                  Get.to(
                    BlocProvider(
                      create: (context) => FetchDocumentsBloc(),
                      child: FetchDocuments(
                        title: subGroup,
                        by: "newest",
                        fromCategories: GroupSubgroup(
                          group: document.groupId,
                          subGroup: document.subGroupId,
                        ),
                        ignoredDocumentId: document.id,
                      ),
                    ),
                  )?.then((value) {
                    pm = pmHolder;
                    curentAudioName = curentAudioNameHolder;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    subGroup,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      // fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // const SizedBox(height: 20),
        header(
          document.name,
          document.mainimage,
          document.creationDate,
          document.group,
          document.subGroup,
          document.likes,
        ),
        if (document.permission) ...[
          ...buildItems(),
          const SizedBox(height: 30),
          labels(),
          const SizedBox(height: 40),
          Visibility(
            visible: document.recommended.isNotEmpty,
            child:
                recommendedList("جدیدترین مطالب مرتبط", document.recommended),
          ),
        ] else ...[
          if (isUserLogin()) ...[
            const SizedBox(height: 40),
            NoSubscription(),
          ] else ...[
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                // border: Border.all(color: const Color(0xffECEEF4), width: 2),
                color: midWhite,
              ),
              child: Column(
                children: [
                  const Text("!این محتوا اشتراکی است",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      )),
                  const SizedBox(height: 6),
                  NoLogin(
                    reload: () {
                      BlocProvider.of<DocumentOnlineBloc>(this.context)
                          .add(GetOrdinaryDocumentEvent(id: document.id));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ],
    );
  }

  // -----------------------------------------------------------

  @override
  void initState() {
    pm = PageManager(fileName: null, documentName: null);
    curentAudioName = "";

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

  Widget textSizeSlider() {
    return ValueListenableBuilder<double>(
      valueListenable: textSize,
      builder: (context, value, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 40,
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
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverLayoutBuilder(
                        builder: (context, constraints) {
                          final scrolled = constraints.scrollOffset > 200;
                          return SliverAppBar(
                            backgroundColor: Colors.white,
                            pinned: true,
                            elevation: 2,
                            surfaceTintColor: Colors.white,
                            // scrolledUnderElevation: 0,
                            shadowColor: Colors.white.withOpacity(0.6),
                            foregroundColor: black,
                            leading: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Iconsax.arrow_left,
                                  color: state is! DocumentLoadingState
                                      ? scrolled
                                          ? Colors.black
                                          : Colors.white
                                      : Colors.black,
                                )),
                            actions: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: state
                                                is! DocumentLoadingState
                                            ? document.audioList.isNotEmpty &&
                                                    document.permission
                                                ? () {
                                                    Get.bottomSheet(
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                            refreshAudioList,
                                                        builder: (context,
                                                                value, child) =>
                                                            Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                          ),
                                                          child:
                                                              AudioListOnline(
                                                            audioList:
                                                                audioList,
                                                            documentName:
                                                                document.name,
                                                            // pm: pm
                                                            setAudio: (PageManager
                                                                audio) async {
                                                              pm.pause();
                                                              pm = audio;
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  16),
                                                          topRight:
                                                              Radius.circular(
                                                                  16),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                : null
                                            : null,
                                        child: Icon(
                                          Iconsax.headphone,
                                          color: state is! DocumentLoadingState
                                              ? document.audioList.isNotEmpty
                                                  ? scrolled
                                                      ? const Color(0xff1C1F2E)
                                                      : Colors.white
                                                  : scrolled
                                                      ? Colors.grey.shade400
                                                      : Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],

                            expandedHeight:
                                state is! DocumentLoadingState ? 250 : 0,
                            flexibleSpace: state is! DocumentLoadingState
                                ? FlexibleSpaceBar(
                                    collapseMode: CollapseMode.pin,
                                    background: SizedBox(
                                      height: 250,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: ImageItem.Item(
                                          documentName: document.name,
                                          imageName: document.mainimage,
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          );
                        },
                      ),
                      if (state is DocumentLoadingState) ...[
                        SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingRing(
                                lineWidth: 1.5,
                                size: 50,
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (state is DocumentErrorState) ...[
                        () {
                          onRefresh = OnRefresh.none;
                          return SliverFillRemaining(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Refresh(onRefresh: () {
                                  BlocProvider.of<DocumentOnlineBloc>(context)
                                      .add(GetOrdinaryDocumentEvent(
                                          id: int.parse(widget.id)));
                                }),
                              ],
                            ),
                          );
                        }(),
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
                                    BlocProvider.of<DocumentOnlineBloc>(context)
                                        .add(GetOrdinaryDocumentEvent(
                                            id: int.parse(widget.id)));
                                  }),
                                ],
                              ),
                            );
                          },
                          (r) {
                            document = r;
                            document.recommended = document.recommended
                                .where(
                                  (e) => e["id"] != document.id.toString(),
                                )
                                .toList();
                            if (audioList.isEmpty) {
                              for (Map audio in r.audioList) {
                                PageManager newPm = PageManager(
                                  fileName: audio["name"],
                                  documentName: r.name,
                                  playNext: () {
                                    int nextIndex =
                                        r.audioList.indexOf(audio) + 1;
                                    if (r.audioList.length > nextIndex) {
                                      pm.pause();
                                      pm = audioList
                                          .elementAt(nextIndex)
                                          .values
                                          .first;
                                      pm.play();
                                      curentAudioName = r.audioList
                                          .elementAt(nextIndex)["name"];
                                      refreshAudioList.value =
                                          AudioListState.default_;
                                      refreshAudioList.value =
                                          AudioListState.refresh;
                                    }
                                  },
                                );
                                audioList.add({audio["title"]: newPm});
                              }
                            }
                            return SliverToBoxAdapter(child: content());
                          },
                        ),
                      ],
                      if (state is DocumentRefreshState) ...[
                        () {
                          document = state.document;
                          onRefresh = state.onRefresh;
                          return SliverToBoxAdapter(child: content());
                        }(),
                      ],
                      if (state is DocumentOnRefreshState) ...[
                        () {
                          onRefresh = state.onRefresh;
                          return SliverToBoxAdapter(child: content());
                        }(),
                      ],
                    ],
                  ),
                ),
                if (onRefresh == OnRefresh.noting) ...[
                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: midWhite,
                      ),
                      child: Row(
                        children: [
                          LoadingRing(
                            lineWidth: 1.5,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(onNotingText),
                        ],
                      ),
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

class AudioListOnline extends StatefulWidget {
  AudioListOnline({
    super.key,
    required this.documentName,
    required this.audioList,
    // required this.pm,
    required this.setAudio,
  });
  final String documentName;
  final List<Map<String, PageManager>> audioList;

  final Function(PageManager newPm) setAudio;
  // PageManager pm;
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
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 6),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(2))),
        ),
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
                      e[e.keys.first]!),
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
                            e[e.keys.first]!),
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
    return ValueListenableBuilder<bool>(
      valueListenable: audio.isLoaded,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            color: curentAudioName == audio.fileName
                ? const Color(0xffDCE4FB)
                : Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: InkWell(
            onTap: value
                ? () async {
                    if (curentAudioName != audio.fileName) {
                      pm.pause();
                      pm = audio;
                      pm.play();
                      setState(() {
                        curentAudioName = audio.fileName ?? "";
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
                  const SizedBox(width: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: audio.onDownloading,
                        builder: (context, onDownloading, child) =>
                            onDownloading
                                ? ValueListenableBuilder(
                                    valueListenable: audio.downloadProgress,
                                    builder: (context, value, child) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: const Color(0xff5E83EE),
                                              value: value,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                audio.cancelDownload();
                                              },
                                              child: const Icon(
                                                Icons.close_rounded,
                                                color: lightgray,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : ValueListenableBuilder(
                                    valueListenable: audio.isDownloaded,
                                    builder: (context, value, child) => value
                                        ? InkWell(
                                            onTap: () {
                                              Get.defaultDialog(
                                                titlePadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                title: "این فایل صوتی حذف شود؟",
                                                content: const SizedBox(),
                                                contentPadding: EdgeInsets.zero,
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      OutlinedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          elevation: 0,
                                                          foregroundColor:
                                                              const Color(
                                                                  0xff848DA2),
                                                          enableFeedback: false,

                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          // side: BorderSide(color: blue),
                                                        ),
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child:
                                                            const Text("خیر"),
                                                      ),
                                                      OutlinedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          elevation: 0,
                                                          foregroundColor:
                                                              black,
                                                          enableFeedback: false,

                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          // side: BorderSide(color: blue),
                                                        ),
                                                        onPressed: () async {
                                                          await audio
                                                              .deleteAudio();
                                                          Get.back();
                                                        },
                                                        child:
                                                            const Text("بله"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6),
                                              child: Icon(
                                                Icons.cloud_download_rounded,
                                                color: Color(0xff5E83EE),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              audio.download();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6),
                                              child: Icon(
                                                Icons.cloud_download_rounded,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                  ),
                      ),
                      const SizedBox(width: 10),
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
                              : LoadingRing(
                                  color: const Color(0xff5E83EE),
                                  lineWidth: 1.5,
                                  size: 20,
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
                        activeTrackColor: blue,
                        inactiveTrackColor: silver,
                        disabledInactiveTrackColor: silver,
                        disabledActiveTrackColor: silver,
                        disabledThumbColor: blue,
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
                        value: value.position.inSeconds.toDouble() < 0
                            ? 0
                            : value.position.inSeconds.toDouble() >
                                    value.total.inSeconds.toDouble()
                                ? value.total.inSeconds.toDouble()
                                : value.position.inSeconds.toDouble(),
                        thumbColor: const Color(0xff5E83EE),
                        activeColor: const Color(0xff5E83EE),

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
                                              minimumSize: const Size(38, 38),
                                              maximumSize: const Size(38, 38),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(24)),
                                              )),
                                          onPressed: () {
                                            pm.play();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffDCE4FB),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Iconsax.play,
                                                color: Color(0xff5E83EE),
                                              ),
                                            ),
                                          ),
                                        );
                                      case AudioState.playing:
                                        return TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: const Size(38, 38),
                                            maximumSize: const Size(38, 38),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24)),
                                            ),
                                          ),
                                          onPressed: () {
                                            pm.pause();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffDCE4FB),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Iconsax.pause4,
                                                color: Color(0xff5E83EE),
                                              ),
                                            ),
                                          ),
                                        );
                                    }
                                  },
                                )
                              : LoadingRing(
                                  lineWidth: 1.5,
                                  size: 20,
                                ),
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
