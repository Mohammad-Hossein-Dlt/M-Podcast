import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/Bloc/FetchDocumentsBloc/all_documents_bloc.dart';
import 'package:user/Bloc/FetchDocumentsBloc/all_documents_event.dart';
import 'package:user/Bloc/FetchDocumentsBloc/all_documents_state.dart';
import 'package:user/Bloc/CategoriesPageBloc/categories_page_block.dart';
import 'package:user/Bloc/CategoriesPageBloc/categories_page_event.dart';
import 'package:user/Bloc/CategoriesPageBloc/categories_page_state.dart';
import 'package:user/Bloc/LoginBloc/login_block.dart';
import 'package:user/Bloc/SubscriptionBloc/subscription_block.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DataModel/data_model.dart';
import 'package:user/DocumentOnline/document_item.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/refresh.dart';
import 'package:user/Home/fetch_documents.dart';
import 'package:user/Home/items.dart';
import 'package:user/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Subscription/subscription_screen.dart';
import 'package:user/User/User.dart';
import 'package:user/iconsax_icons.dart';

import '../Bloc/SubGroupsBloc/subgroups_block.dart';

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
                    ? AllDocumentsItem(
                        title: e["title"],
                        by: "newest",
                        preTitle: e["title"],
                        fromCategories: GroupSubgroup(
                          group: e["category"]["group"],
                          subGroup: e["category"]["subgroup"],
                        ),
                        shimmerColor: const Color(0xffF5F5F5),
                      )
                    : AllDocumentsItem2(
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
                    ? AllDocumentsItem(
                        title: e["title"],
                        by: "hottest",
                        preTitle: "پرطرفدارترین ها",
                        fromCategories: GroupSubgroup(
                          group: widget.id,
                          subGroup: "",
                        ),
                        shimmerColor: midWhite,
                      )
                    : AllDocumentsItem2(
                        title: e["title"],
                        by: "hottest",
                        preTitle: "پرطرفدارترین ها",
                        fromCategories: GroupSubgroup(
                          group: widget.id,
                          subGroup: "",
                        ),
                        shimmerColor: midWhite,
                      ),
              ),
            );
            break;
          case "newest":
            widget_ = Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: BlocProvider(
                create: (context) => FetchDocumentsBloc(),
                child: e["style"] == "style-1"
                    ? AllDocumentsItem(
                        title: e["title"],
                        by: "newest",
                        preTitle: "جدیدترین ها",
                        fromCategories: GroupSubgroup(
                          group: widget.id,
                          subGroup: "",
                        ),
                        shimmerColor: midWhite)
                    : AllDocumentsItem2(
                        title: e["title"],
                        by: "newest",
                        preTitle: "جدیدترین ها",
                        fromCategories: GroupSubgroup(
                          group: widget.id,
                          subGroup: "",
                        ),
                        shimmerColor: midWhite,
                      ),
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
      backgroundColor: Colors.white,
      elevation: 2.5,
      shadowColor: Colors.white.withOpacity(0.5),
      surfaceTintColor: Colors.white,
      // toolbarHeight: 50,
      // leadingWidth: 50,
      centerTitle: true,
      leading: TextButton(
        child: const Icon(
          Iconsax.arrow_left,
          color: Colors.black,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.groupName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget content(CategoryPageDataModel data) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        ...buildItems(
          page: data.page,
          image: data.image ?? "",
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget noSubscription() {
    bool userLogin = isUserLogin();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              // height: 120,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset("assets/images/coffee.png"),
                  ),
                ),
              ),
            ),
            userLogin
                ? Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "است ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                decoration: const BoxDecoration(
                                  // shape: BoxShape.circle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  color: lightblue,
                                ),
                                child: const Center(
                                  child: Text(
                                    "ویژه",
                                    style: TextStyle(
                                        color: accent_blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              const Text(
                                " این یک دسته بندی",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            // "لطفا برای تهیه اشتراک نسخه جدید برنامه را دریافت کنید",
                            "برای دسترسی به این بخش لطفا اشتراک ویژه تهیه کنید",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "است ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: const BoxDecoration(
                              // shape: BoxShape.circle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: lightblue,
                            ),
                            child: const Center(
                              child: Text(
                                "ویژه",
                                style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          const Text(
                            " این یک دسته بندی",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "لطفا برای ادامه وارد حساب کاربری خود شوید",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Icon(
                  //   Icons.diamond_rounded,
                  //   color: blue,
                  // ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    decoration: const BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      // color: lightblue,
                    ),
                    child: const Center(
                      child: Text(
                        "ویژه",
                        style: TextStyle(
                            color: blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
                  const Text(
                    " با تهیه اشتراک",
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              const Text(
                "شما به دسته بندی ها و مطالب ویژه و دیگر امکانات این برنامه دسترسی بیشتری دارید",
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
        userLogin
            ? OutlinedButton(
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size(320, 50),
                  maximumSize: const Size(320, 50),
                  shadowColor: Colors.white,
                  backgroundColor: accent_blue,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  side: const BorderSide(color: accent_blue),
                ),
                onPressed: () async {
                  Get.to(
                    BlocProvider(
                      create: (context) => SubscriptionBloc(),
                      child: const Subscription(),
                    ),
                  );
                },
                child: const Text(
                  // "دریافت نسخه جدید",
                  "خرید اشتراک",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
            : OutlinedButton(
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size(320, 50),
                  maximumSize: const Size(320, 50),
                  shadowColor: Colors.white,
                  backgroundColor: accent_blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  side: const BorderSide(color: accent_blue),
                ),
                onPressed: () {
                  Get.to(
                    BlocProvider(
                      create: (context) => LoginBloc(),
                      child: Login(
                        reload: () {
                          BlocProvider.of<CategoriesPageBloc>(context).add(
                              GetCategoriesPageData(mainGroupId: widget.id));
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                  "ورود / ثبت نام",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
        const SizedBox(),
      ],
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
                              size: 50,
                            ),
                          ],
                        ),
                      ),
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
                    child: CustomScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          // floating: true,
                          forceElevated: true,
                          backgroundColor: Colors.white,
                          elevation: r.permission ? 2.5 : 0,
                          shadowColor: Colors.white.withOpacity(0.5),

                          leading: TextButton(
                            child: const Icon(
                              Iconsax.arrow_left,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          actions: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.groupName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                        if (r.permission)
                          SliverFillRemaining(child: content(r))
                        else
                          SliverFillRemaining(child: noSubscription()),
                      ],
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
                    Get.back();
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
            body: Column(
              children: [
                if (state is FetchDocumentsLoading) ...[
                  const Expanded(
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
                ],
                if (state is FetchDocumentsData) ...[
                  state.data.fold(
                    (l) {
                      return Text(l);
                    },
                    (r) {
                      docs.addAll(r.documents);
                      showIndicator = r.next;
                      showLoading.value = r.next;
                      return Expanded(
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              ...docs.map(
                                (e) => AnimatedOpacity(
                                  duration: const Duration(microseconds: 800),
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
                              Visibility(
                                  visible: r.next,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: LoadingRing(
                                          lineWidth: 1.5,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  )),
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
        ),
      ),
    );
  }
}
