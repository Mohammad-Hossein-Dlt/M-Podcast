import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:user/Bloc/BookmarksBloc/favorites_block.dart';
import 'package:user/Bloc/BookmarksBloc/favorites_event.dart';
import 'package:user/Bloc/BookmarksBloc/favorites_state.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DocumentOnline/document_item.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/no_login.dart';
import 'package:user/GeneralWidgets/refresh.dart';
import 'package:user/iconsax_icons.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final ScrollController _controller = ScrollController();
  List docs = [];

  String orderedBy = "default";

  @override
  void initState() {
    BlocProvider.of<FavoritesBloc>(context)
        .add(GetFavoritesEvent(offset: 0, order: orderedBy));
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        BlocProvider.of<FavoritesBloc>(context)
            .add(LoadMoreFavoritesEvent(offset: docs.length, order: orderedBy));
      }
    });
    super.initState();
  }

  void order(String order) {
    docs = [];
    orderedBy = order;
    BlocProvider.of<FavoritesBloc>(context)
        .add(GetFavoritesEvent(offset: 0, order: orderedBy));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) => Scaffold(
        // backgroundColor: Color(0xffFAFAFA),
        backgroundColor: Colors.white,
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: state is! NoLoginState ? true : false,
              pinned: state is! NoLoginState ? false : true,
              elevation: 2.5,
              shadowColor: Colors.white.withOpacity(0.5),
              forceElevated: true,
              backgroundColor: Colors.white,
              leading: const SizedBox(),
              actions: const [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Text(
                            "علاقه مندی ها",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0B1B3F),
                                fontSize: 16),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Iconsax.heart,
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
                    state is! NoLoginState ? kTextTabBarHeight : 0),
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
                              onPressed: state is FavoritesLoadingState
                                  ? null
                                  : () async {
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
                                  "جدیدترین ها",
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
                              onPressed: state is FavoritesLoadingState
                                  ? null
                                  : () async {
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
                                  "همه علاقه مندیها",
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
                            // const Text(" :ترتیب"),
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
              if (state is FavoritesErrorState) ...[
                Refresh(
                  onRefresh: () {
                    BlocProvider.of<FavoritesBloc>(context)
                        .add(GetFavoritesEvent(offset: 0, order: orderedBy));
                  },
                ),
              ],
              if (state is NoLoginState) ...[
                Expanded(
                  child: NoLogin2(
                      title: "!هنوز وارد حساب کاربریتان نشدید",
                      subTitle:
                          "برای مشاهده لیست علاقه مندیهایتان وارد حساب کاربریتان شوید"),
                ),
              ],
              if (state is FavoritesLoadingState) ...[
                LoadingRing(
                  lineWidth: 1.5,
                  size: 50,
                ),
              ],
              if (state is FavoritesDataState) ...[
                state.bookmarksList.fold((l) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Refresh(onRefresh: () {
                        docs = [];
                        BlocProvider.of<FavoritesBloc>(context).add(
                            GetFavoritesEvent(offset: 0, order: orderedBy));
                      })
                    ],
                  );
                }, (r) {
                  for (var i in r.documents) {
                    if (docs.contains(i) == false) {
                      docs.add(i);
                    }
                  }
                  return Expanded(
                      child: RefreshIndicator(
                    color: black,
                    backgroundColor: Colors.white,
                    strokeWidth: 1.8,
                    onRefresh: () async {
                      order(orderedBy);
                    },
                    child: ListView(children: [
                      const SizedBox(height: 10),
                      ...r.documents.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            children: [
                              HorizontalFullDetailsItem(
                                document: e,
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
                                                "از حذف این مطلب از علاقه مندیهای تان مطمعن هستید؟",
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
                                                        BlocProvider.of<
                                                                    FavoritesBloc>(
                                                                this.context)
                                                            .add(RemoveFromFavoritesEvent(
                                                                ctx: this
                                                                    .context,
                                                                id: id));
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
                              const SizedBox(height: 14),
                              const Divider(),
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
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
