import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:user/Bloc/FetchDocumentsBloc/all_documents_bloc.dart';
import 'package:user/Bloc/CategoriesBloc/categories_block.dart';
import 'package:user/Bloc/CategoriesBloc/categories_event.dart';
import 'package:user/Bloc/CategoriesBloc/categories_state.dart';
import 'package:user/Bloc/CategoriesPageBloc/categories_page_block.dart';
import 'package:user/Bloc/SearchBloc/search_block.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DocumentOnline/document_item.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/refresh.dart';
import 'package:user/Home/fetch_documents.dart';
import 'package:user/Home/items.dart';
import 'package:user/Home/pagescreen.dart';
import 'package:user/Home/search_screen.dart';
import 'package:user/Bloc/HomeBloc/home_block.dart';
import 'package:user/Bloc/HomeBloc/home_event.dart';
import 'package:user/Bloc/HomeBloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/UserProfile/settings_.dart';
import 'package:user/iconsax_icons.dart';
import '../paths.dart';

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
  IconWidget icon = const IconWidget();
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
                    child: AllDocumentsItem(
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
                    child: AllDocumentsItem2(
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
                    child: AllDocumentsItem(
                      title: e["title"],
                      by: "hottest",
                      preTitle: "پرطرفدارترین ها",
                      shimmerColor: const Color(0xffF5F5F5),
                    ),
                  )
                : BlocProvider(
                    create: (context) => FetchDocumentsBloc(),
                    child: AllDocumentsItem2(
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
                    child: AllDocumentsItem(
                      title: e["title"],
                      by: "newest",
                      preTitle: "جدیدترین ها",
                      shimmerColor: const Color(0xffF5F5F5),
                    ),
                  )
                : BlocProvider(
                    create: (context) => FetchDocumentsBloc(),
                    child: AllDocumentsItem2(
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
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      pinned: true,
                      elevation: 2,
                      forceElevated: true,
                      shadowColor: Colors.white.withOpacity(0.5),
                      backgroundColor: const Color(0xffFAFAFA),
                      foregroundColor: Colors.black,
                      toolbarHeight: kToolbarHeight,
                      leading: TextButton(
                          onPressed: () {
                            Get.to(
                              Settings(),
                            );
                          },
                          child: const Icon(
                            Icons.settings,
                            color: gray,
                          )),
                      title: const Text(
                        "خانه",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      centerTitle: true,
                      actions: [
                        TextButton(
                          onPressed: () {
                            showSearch.value = true;
                          },
                          child: const Icon(
                            Iconsax.search_normal_1,
                            color: black,
                          ),
                        )
                      ],
                    ),
                  ],
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
                            (l) => Refresh(onRefresh: () {
                                  BlocProvider.of<HomeBloc>(context)
                                      .add(GetHomeData());
                                }), (r) {
                          return Expanded(
                            child: RefreshIndicator(
                              color: black,
                              backgroundColor: Colors.white,
                              strokeWidth: 1.8,
                              child: ListView(
                                physics: const ClampingScrollPhysics(),
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
                              child:
                                  SearchScreen(preSearch: "", back: showSearch),
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

  Widget categories(
      {required String title,
      required String preTitle,
      required List categories}) {
    return Container(
      color: Color(0xffF5F5F5),
      child: SizedBox(
        height: 70,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (categories.isNotEmpty) ...[
                ...categories.reversed.map((e) => e["showinhomepage"]
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: black,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.to(
                              BlocProvider(
                                create: (context) => CategoriesPageBloc(),
                                child: PageScreen(
                                  id: e["id"],
                                  groupName: e["name"],
                                  image: e["image"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 6,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    e["name"],
                                    style: const TextStyle(
                                      color: black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                e["image"] != null && e["image"].isNotEmpty
                                    ? SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 32,
                                              height: 32,
                                              child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: ImageItem.Category(
                                                  imageName: e["image"],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()),
                Container(
                  height: 70,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: black,
                  ),
                  child: Center(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        title.isNotEmpty ? title : preTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ),
                )
              ]
            ],
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

class IconWidget extends StatefulWidget {
  const IconWidget({super.key});

  @override
  State<IconWidget> createState() => _IconWidgetState();
}

class _IconWidgetState extends State<IconWidget>
    with AutomaticKeepAliveClientMixin {
  Image icon = Image.asset(
    "assets/images/ic_transparent.png",
    height: 40,
    // cacheHeight: 50,
  );
  @override
  void didChangeDependencies() {
    precacheImage(icon.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return icon;
  }

  @override
  bool get wantKeepAlive => true;
}

class Settings extends StatefulWidget {
  Settings({
    super.key,
  });
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Timer countDown = Timer(const Duration(seconds: 5), () {});
  bool isCountingDown = false;
  Duration duration = const Duration(seconds: 5);
  void setCountDown() {
    int reduceSeconsBy = 1;
    setState(() {
      final curentSeconds = duration.inSeconds - reduceSeconsBy;
      if (curentSeconds <= 0) {
        countDown.cancel();
        isCountingDown = false;
        List flist = AppDataDirectory.tempDirectory().listSync();
        for (File f in flist) {
          f.delete();
        }
      } else {
        duration = Duration(seconds: curentSeconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  forceElevated: true,
                  backgroundColor: Colors.white,
                  elevation: 1,
                  shadowColor: Colors.white.withOpacity(0.5),
                  leading: TextButton(
                    child: const Icon(
                      Iconsax.arrow_left,
                      color: black,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  actions: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "تنظیمات",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        SizedBox(width: 14),
                      ],
                    ),
                  ],
                ),
                const SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 10)),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  sliver: SliverToBoxAdapter(child: settings()),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              child: Visibility(
                visible: isCountingDown,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xff26303A),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            elevation: 0,
                            shadowColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              countDown.cancel();
                              isCountingDown = false;
                            });
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Iconsax.redo,
                                color: Color(0xff84C9FD),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "برگرداندن",
                                style: TextStyle(
                                  color: Color(0xff84C9FD),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(width: 40),
                      Row(
                        children: [
                          const Text(
                            "همه دانلودهای شما پاک شد",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 26,
                            height: 26,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: duration.inSeconds.toDouble() / 5,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  duration.inSeconds.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item({
    Widget? leading,
    required String title,
    Color? titleColor,
    String? subTitle,
    Color? subTitleColor,
    required Widget icon,
    Color? iconContainerColor,
    bool? hideDivider,
    required Function() function,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () {
              function();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                leading ??
                                    const Icon(
                                      Iconsax.arrow_left_2,
                                      size: 14,
                                      color: Color(0xff848DA2),
                                    ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                                color: titleColor ?? black),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: subTitle != null,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              subTitle ?? "",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: subTitleColor ??
                                                      lightgray,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: hideDivider == null || !hideDivider,
          child: Divider(
            thickness: 1.2,
            color: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Widget settings() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          item(
            leading: Directionality(
              textDirection: TextDirection.rtl,
              child: Switch(
                activeTrackColor: blue,
                activeColor: Colors.white,
                value: settingsData()!.autoDownload,
                onChanged: (value) {
                  settingsData()!.autoDownload = value;
                  settingsData()!.save();
                  setState(() {});
                },
              ),
            ),
            title: "دانلود خودکار فایل های صوتی",
            icon: const Icon(
              Iconsax.book,
              color: black,
            ),
            iconContainerColor: const Color(0xffF1F5FF),
            function: () {},
          ),
          item(
            leading: Directionality(
              textDirection: TextDirection.rtl,
              child: Switch(
                activeTrackColor: blue,
                activeColor: Colors.white,
                value: settingsData()!.autoPlyaNextAudio,
                onChanged: (value) {
                  settingsData()!.autoPlyaNextAudio = value;
                  settingsData()!.save();
                  setState(() {});
                },
              ),
            ),
            title: "پخش خودکار فایل صوتی بعدی",
            icon: const Icon(
              Iconsax.book,
              color: black,
            ),
            iconContainerColor: const Color(0xffF1F5FF),
            function: () {},
          ),
          item(
            leading: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
              onPressed: () {
                Get.defaultDialog(
                  titlePadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  title: "همه دانلود های شما حذف شود؟",
                  content: const SizedBox(),
                  contentPadding: EdgeInsets.zero,
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: const Color(0xff848DA2),
                            enableFeedback: false,

                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            // side: BorderSide(color: blue),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("خیر"),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: black,
                            enableFeedback: false,

                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            // side: BorderSide(color: blue),
                          ),
                          onPressed: () async {
                            setState(() {
                              isCountingDown = true;
                              duration = const Duration(seconds: 5);
                              if (countDown.isActive) {
                                countDown.cancel();
                              }
                              countDown = Timer.periodic(
                                const Duration(seconds: 1),
                                (_) => setCountDown(),
                              );
                            });
                            Get.back();
                          },
                          child: const Text("بله"),
                        ),
                      ],
                    ),
                  ],
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: const BoxDecoration(
                  color: midPurple,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: const Text(
                  "پاک کردن",
                  style: TextStyle(
                    color: purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: "پاک کردن فایل های دانلود شده",
            icon: const Icon(
              Iconsax.book,
              color: black,
            ),
            iconContainerColor: const Color(0xffF1F5FF),
            hideDivider: true,
            function: () {},
          ),
        ],
      ),
    );
  }
}
