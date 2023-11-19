import 'package:admin/Bloc/CategoriesBloc/categories_block.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_event.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_state.dart';
import 'package:admin/Bloc/CategoriesPageBloc/categories_page_block.dart';
import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_bloc.dart';
import 'package:admin/Bloc/PageEditor/page_editor_block.dart';
import 'package:admin/Bloc/SearchBloc/search_block.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/Home/fetch_documents.dart';
import 'package:admin/Home/home_designe.dart';
import 'package:admin/Home/items.dart';
import 'package:admin/Home/pagescreen.dart';
import 'package:admin/Home/search_screen.dart';
import 'package:admin/Bloc/HomeBloc/home_block.dart';
import 'package:admin/Bloc/HomeBloc/home_event.dart';
import 'package:admin/Bloc/HomeBloc/home_state.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  Home({
    super.key,
  });
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController name = TextEditingController();
  ValueNotifier showSearch = ValueNotifier(false);
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(GetHomeData());
    super.initState();
  }

  List<Widget> buildItems({
    required List data,
  }) {
    return [
      ...data.map((e) {
        Widget widget_ = Container(key: UniqueKey());
        switch (e["type"]) {
          case "selective":
            widget_ = e["style"] == "style-1"
                ? BlocProvider(
                    create: (context) => FetchDocumentsBloc(),
                    child: AllDocumentsItemStyle1(
                      title: e["title"],
                      by: "newest",
                      preTitle: e["title"],
                      fromCategories: GroupSubgroup(
                          group: e["category"]["group"],
                          subGroup: e["category"]["subgroup"]),
                      shimmerColor: const Color(0xffF5F5F5),
                    ),
                  )
                : BlocProvider(
                    create: (context) => FetchDocumentsBloc(),
                    child: AllDocumentsItemStyle2(
                      title: e["title"],
                      by: "newest",
                      preTitle: e["title"],
                      fromCategories: GroupSubgroup(
                          group: e["category"]["group"],
                          subGroup: e["category"]["subgroup"]),
                      shimmerColor: const Color(0xffF5F5F5),
                    ),
                  );
            break;
          case "hottest":
            widget_ = e["style"] == "style-1"
                ? BlocProvider(
                    create: (context) => FetchDocumentsBloc(),
                    child: AllDocumentsItemStyle1(
                      title: e["title"],
                      by: "hottest",
                      preTitle: "پرطرفدارترین ها",
                      shimmerColor: const Color(0xffF5F5F5),
                    ),
                  )
                : BlocProvider(
                    create: (context) => FetchDocumentsBloc(),
                    child: AllDocumentsItemStyle2(
                      title: e["title"],
                      by: "hottest",
                      preTitle: "پرطرفدارترین ها",
                      shimmerColor: const Color(0xffF5F5F5),
                    ),
                  );
            break;
          case "newest":
            widget_ = e["style"] == "style-1"
                ? BlocProvider(
                    create: (context) => FetchDocumentsBloc(),
                    child: AllDocumentsItemStyle1(
                      title: e["title"],
                      by: "newest",
                      preTitle: "جدیدترین ها",
                      shimmerColor: const Color(0xffF5F5F5),
                    ),
                  )
                : BlocProvider(
                    create: (context) => FetchDocumentsBloc(),
                    child: AllDocumentsItemStyle2(
                      title: e["title"],
                      by: "newest",
                      preTitle: "جدیدترین ها",
                      shimmerColor: const Color(0xffF5F5F5),
                    ),
                  );
            break;
          case "categories":
            widget_ = BlocProvider(
              create: (context) => CategoriesBloc(),
              child: CategoriesItem(
                title: e["title"],
                preTitle: "دسته بندی ها",
              ),
            );
            break;
          case "banner":
            widget_ = BannerItem(
              bannerData: e,
              isSetRadios: true,
              isSetPadding: true,
            );
            break;
          case "bannerlist":
            widget_ = BannerList(banners: e["list"]);
            break;
          default:
            widget_ = Container();
        }
        return widget_;
      })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showSearch.value = false;

        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFAFAFA),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => Stack(
              children: [
                NestedScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        elevation: 2,
                        forceElevated: true,
                        shadowColor: Colors.white.withOpacity(0.5),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        toolbarHeight: kToolbarHeight + 4,
                        leading: TextButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => PageEditorBloc(),
                                  child: HomeDesigner(),
                                ),
                              ),
                            );
                          },
                          child: const Icon(
                            Iconsax.edit_2,
                            color: black,
                          ),
                        ),
                        title: const Text("خانه"),
                        centerTitle: true,
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  showSearch.value = true;
                                },
                                child: const Icon(
                                  Iconsax.search_normal_1,
                                  color: black,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ];
                  },
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state is HomeLoadingState) ...[
                        LoadingRing(
                          lineWidth: 1.5,
                          size: 40,
                        ),
                      ],
                      if (state is HomeDataState) ...[
                        state.data.fold(
                            (l) => Column(
                                  children: [
                                    Refresh(onRefresh: () {
                                      BlocProvider.of<HomeBloc>(context)
                                          .add(GetHomeData());
                                    })
                                  ],
                                ), (r) {
                          return Expanded(
                            child: RefreshIndicator(
                              color: black,
                              backgroundColor: white,
                              strokeWidth: 1.8,
                              child: ListView(
                                children: [
                                  const SizedBox(height: 20),
                                  ...buildItems(
                                    data: r.main,
                                  ).map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 40),
                                      child: e,
                                    ),
                                  ),
                                  // const SizedBox(height: 20),
                                ],
                              ),
                              onRefresh: () async {
                                BlocProvider.of<HomeBloc>(context)
                                    .add(GetHomeData());
                              },
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: showSearch,
                  builder: (context, value, child) => value
                      ? Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            color: Colors.white,
                            child: BlocProvider(
                              create: (context) => SearchBloc(),
                              child: SearchScreen(
                                  onDelete: false,
                                  preSearch: "",
                                  back: showSearch),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoriesList extends StatefulWidget {
  CategoriesList({
    super.key,
    this.backButton = false,
  });
  final bool backButton;
  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  void initState() {
    BlocProvider.of<CategoriesBloc>(context).add(GetCategoriesData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) => SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                elevation: 2,
                forceElevated: true,
                shadowColor: Colors.white.withOpacity(0.5),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: widget.backButton
                    ? TextButton(
                        child: const Icon(
                          Iconsax.arrow_left,
                          color: black,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    : const SizedBox(),
                actions: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "دسته بندی ها",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Iconsax.category,
                        color: Colors.black,
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ],
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is CategoriesLoadingState) ...[
                  LoadingRing(
                    lineWidth: 1.5,
                    size: 40,
                  ),
                ],
                if (state is CategoriesDataState) ...[
                  state.data.fold((l) {
                    return Refresh(onRefresh: () {
                      BlocProvider.of<CategoriesBloc>(context)
                          .add(GetCategoriesData());
                    });
                  }, (r) {
                    print(r.categoriesList);
                    return Expanded(
                      child: RefreshIndicator(
                        color: black,
                        backgroundColor: Colors.white,
                        strokeWidth: 1.8,
                        onRefresh: () async {
                          BlocProvider.of<CategoriesBloc>(context)
                              .add(GetCategoriesData());
                        },
                        child: ListView(
                          children: [
                            const SizedBox(height: 10),
                            ...r.categoriesList.map((e) {
                              if (e["showinhomepage"]) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            width: 34,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: accent_blue,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                e["specialGroup"]
                                                    ? "ویژه"
                                                    : "رایگان",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: InkWell(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        BlocProvider(
                                                      create: (context) =>
                                                          CategoriesPageBloc(),
                                                      child: PageScreen(
                                                        // id: keys[index],
                                                        id: e["id"],
                                                        groupName: e["name"],
                                                        image: e["image"],
                                                      ),
                                                    ),
                                                  ));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        // vertical: 14,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        6),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                            e["name"],
                                                                            style: const TextStyle(color: black)),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          if (e["image"] !=
                                                                  null &&
                                                              e["image"]
                                                                  .isNotEmpty)
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: 40,
                                                                  height: 40,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            4)),
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      child: e["image"] !=
                                                                              null
                                                                          ? ImageItem
                                                                              .Category(
                                                                              imageName: e["image"],
                                                                            )
                                                                          : const SizedBox(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          else
                                                            const SizedBox(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
