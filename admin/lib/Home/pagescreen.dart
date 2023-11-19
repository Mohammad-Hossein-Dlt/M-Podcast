import 'package:admin/Bloc/CategoriesPageBloc/categories_page_block.dart';
import 'package:admin/Bloc/CategoriesPageBloc/categories_page_event.dart';
import 'package:admin/Bloc/CategoriesPageBloc/categories_page_state.dart';
import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_bloc.dart';
import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_event.dart';
import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_state.dart';
import 'package:admin/Bloc/PageEditor/page_editor_block.dart';
import 'package:admin/Bloc/SubGroupsBloc/subgroups_block.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/Home/fetch_documents.dart';
import 'package:admin/Home/items.dart';
import 'package:admin/Home/pagescreen_designe.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PageScreen extends StatefulWidget {
  PageScreen(
      {super.key,
      required this.id,
      required this.groupName,
      required this.image});

  final String id;
  final String groupName;
  final String image;

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  @override
  void initState() {
    BlocProvider.of<CategoriesPageBloc>(context)
        .add(GetCategoriesPageData(mainGroupId: widget.id));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> buildItems({
    required List page,
    required String image,
  }) {
    return [
      ...page.map((e) {
        Widget widget_ = Container(key: UniqueKey());
        switch (e["type"]) {
          case "selectiveFromSubGroup":
            widget_ = Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: BlocProvider(
                create: (context) => FetchDocumentsBloc(),
                child: e["style"] == "style-1"
                    ? AllDocumentsItemStyle1(
                        title: e["title"],
                        by: "newest",
                        preTitle: e["title"],
                        fromCategories: GroupSubgroup(
                          group: e["category"]["group"],
                          subGroup: e["category"]["subgroup"],
                        ),
                        shimmerColor: const Color(0xffF5F5F5),
                      )
                    : AllDocumentsItemStyle2(
                        title: e["title"],
                        by: "newest",
                        preTitle: e["title"],
                        fromCategories: GroupSubgroup(
                          group: e["category"]["group"],
                          subGroup: e["category"]["subgroup"],
                        ),
                        shimmerColor: const Color(0xffF5F5F5),
                      ),
              ),
            );

            break;

          case "hottest":
            widget_ = Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: BlocProvider(
                create: (context) => FetchDocumentsBloc(),
                child: e["style"] == "style-1"
                    ? AllDocumentsItemStyle1(
                        title: e["title"],
                        by: "hottest",
                        preTitle: "پرطرفدارترین ها",
                        shimmerColor: midWhite)
                    : AllDocumentsItemStyle2(
                        title: e["title"],
                        by: "hottest",
                        preTitle: "پرطرفدارترین ها",
                        shimmerColor: midWhite),
              ),
            );
            break;
          case "newest":
            widget_ = Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: BlocProvider(
                create: (context) => FetchDocumentsBloc(),
                child: e["style"] == "style-1"
                    ? AllDocumentsItemStyle1(
                        title: e["title"],
                        by: "newest",
                        preTitle: "جدیدترین ها",
                        shimmerColor: midWhite)
                    : AllDocumentsItemStyle2(
                        title: e["title"],
                        by: "newest",
                        preTitle: "جدیدترین ها",
                        shimmerColor: midWhite),
              ),
            );
            break;
          case "subGroups":
            widget_ = BlocProvider(
              create: (context) => SubGroupsBloc(),
              child: SubGroupsItem(
                id: widget.id,
                title: e["title"],
                preTitle: "دسته بندی ها",
              ),
            );
            break;
          case "banner":
            widget_ = Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: BannerItem(
                bannerData: e,
                isSetRadios: true,
                isSetPadding: true,
              ),
            );
            break;
          case "bannerlist":
            widget_ = Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: BannerList(banners: e["list"]),
            );
            break;
          default:
            widget_ = Container();
        }
        return widget_;
      })
    ];
  }

  Widget appBarPrevie() {
    return SliverAppBar(
      pinned: true,
      forceElevated: true,
      elevation: 2,
      shadowColor: Colors.white.withOpacity(0.5),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      centerTitle: true,
      leading: TextButton(
        child: const Icon(
          Iconsax.arrow_left,
          color: Color(0xff0B1B3F),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        widget.groupName,
        style: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black, fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<CategoriesPageBloc, CategoriesPageState>(
          builder: (context, state) => Column(
            children: [
              if (state is CategoriesPageLoadingState) ...[
                Expanded(
                  child: CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [
                      appBarPrevie(),
                      SliverFillRemaining(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingRing(
                            lineWidth: 1.5,
                            size: 40,
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ],
              if (state is CategoriesPageDataState) ...[
                state.data.fold((l) {
                  return Expanded(
                    child: CustomScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      slivers: [
                        appBarPrevie(),
                        SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Refresh(onRefresh: () {
                                BlocProvider.of<CategoriesPageBloc>(
                                        this.context)
                                    .add(GetCategoriesPageData(
                                        mainGroupId: widget.id));
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }, (r) {
                  return Expanded(
                    child: NestedScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      floatHeaderSlivers: true,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            // pinned: true,
                            floating: true,
                            elevation: 2,
                            forceElevated: true,
                            shadowColor: Colors.white.withOpacity(0.5),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,

                            leading: TextButton(
                              child: const Icon(
                                Iconsax.arrow_left,
                                color: Color(0xff0B1B3F),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            title: Text(
                              widget.groupName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                            centerTitle: true,
                            actions: [
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) =>
                                                PageEditorBloc(),
                                            child: PageDesigner(id: widget.id),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Iconsax.edit_2,
                                      color: black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ];
                      },
                      body: ListView(
                        children: [
                          const SizedBox(height: 20),
                          ...buildItems(
                            page: r.page,
                            image: r.image ?? "",
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                }),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class SubGroupPage extends StatefulWidget {
  SubGroupPage({
    super.key,
    required this.mainGroupId,
    required this.subGroupId,
    required this.subGroup,
  });
  final String mainGroupId;
  final String subGroupId;
  final String subGroup;
  @override
  State<SubGroupPage> createState() => _SubGroupPageState();
}

class _SubGroupPageState extends State<SubGroupPage> {
  final ScrollController _controller = ScrollController();
  bool showIndicator = false;

  List docs = [];

  String by = "newest";
  ValueNotifier showLoading = ValueNotifier(false);

  @override
  void initState() {
    BlocProvider.of<FetchDocumentsBloc>(context).add(FetchFirstDocumentsByEvent(
      offset: 0,
      by: by,
      group: widget.mainGroupId,
      subGroup: widget.subGroupId,
    ));

    _controller.addListener(() async {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (showIndicator) {
          showLoading.value = true;
        }
        BlocProvider.of<FetchDocumentsBloc>(context).add(FetchMoreByEvent(
          offset: docs.length,
          by: by,
          group: widget.mainGroupId,
          subGroup: widget.subGroupId,
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<FetchDocumentsBloc, FetchDocumentsState>(
          builder: (context, state) => NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: state is! FetchDocumentsData ? true : false,
                pinned: state is! FetchDocumentsLoading ? false : true,
                forceElevated: true,
                backgroundColor: Colors.white,
                elevation: 2.5,
                shadowColor: Colors.white.withOpacity(0.5),
                leading: TextButton(
                  child: const Icon(
                    Iconsax.arrow_left,
                    color: black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          widget.subGroup,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff0B1B3F),
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kTextTabBarHeight),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: state is FetchDocumentsLoading
                                    ? null
                                    : () {
                                        if (by == "newest") {
                                          by = "hottest";
                                          docs = [];

                                          BlocProvider.of<FetchDocumentsBloc>(
                                                  context)
                                              .add(FetchFirstDocumentsByEvent(
                                                  offset: 0,
                                                  by: "hottest",
                                                  group: widget.mainGroupId,
                                                  subGroup: widget.subGroupId));
                                        }
                                      },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: by == "hottest"
                                        ? accent_blue
                                        : Colors.white,
                                    border: Border.all(
                                      color: by == "hottest"
                                          ? accent_blue
                                          : lightblue,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    "پرطرفدارترین ها",
                                    style: TextStyle(
                                      color: by == "hottest"
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: by == "hottest"
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
                                onPressed: state is FetchDocumentsLoading
                                    ? null
                                    : () async {
                                        if (by == "hottest") {
                                          by = "newest";
                                          docs = [];

                                          BlocProvider.of<FetchDocumentsBloc>(
                                                  context)
                                              .add(FetchFirstDocumentsByEvent(
                                                  offset: 0,
                                                  by: "newest",
                                                  group: widget.mainGroupId,
                                                  subGroup: widget.subGroupId));
                                        }
                                      },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: by == "newest"
                                        ? accent_blue
                                        : Colors.white,
                                    border: Border.all(
                                      color: by == "newest"
                                          ? accent_blue
                                          : lightblue,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    "جدیدترین ها",
                                    style: TextStyle(
                                      color: by == "newest"
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: by == "newest"
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                ),
              ),
            ],
            body: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      if (state is FetchDocumentsLoading) ...[
                        Expanded(
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              const Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Shimmer(
                                  period: Duration(milliseconds: 600),
                                  gradient: LinearGradient(
                                    colors: [
                                      white,
                                      Color(0xffF4F4F4),
                                      white,
                                    ],
                                    stops: [
                                      0.1,
                                      0.3,
                                      0.4,
                                    ],
                                    begin: Alignment(-1.0, -0.3),
                                    end: Alignment(1.0, 0.3),
                                    tileMode: TileMode.clamp,
                                  ),
                                  child: AllDocumentsPageShimmer(),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                child: Material(
                                  elevation: 2,
                                  color: Colors.white,
                                  shadowColor: Colors.white,
                                  shape: const CircleBorder(),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: midWhite,
                                    ),
                                    child: LoadingRing(
                                      lineWidth: 2,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (state is FetchDocumentsData) ...[
                        state.data.fold(
                          (l) {
                            return Text(l);
                          },
                          (r) {
                            docs.addAll(r.documents);
                            showIndicator = r.next;
                            return Expanded(
                              child: SingleChildScrollView(
                                controller: _controller,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    ...docs.map(
                                      (e) => AnimatedOpacity(
                                        duration:
                                            const Duration(microseconds: 800),
                                        opacity: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            children: [
                                              HorizontalFullDetailsItem(
                                                document: e,
                                                remove: null,
                                                // showInWrap: true,
                                              ),
                                              const SizedBox(height: 14),
                                              const Divider(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ]
                    ],
                  ),
                ),
                Positioned(
                    top: 20,
                    child: ValueListenableBuilder(
                      valueListenable: showLoading,
                      builder: (context, value, child) => Visibility(
                        visible: value,
                        child: Material(
                          elevation: 2,
                          color: Colors.white,
                          shadowColor: Colors.white,
                          shape: const CircleBorder(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: white,
                            ),
                            child: LoadingRing(
                              lineWidth: 1.5,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
