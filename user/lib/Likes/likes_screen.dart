import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/Bloc/LikedBloc/liked_block.dart';
import 'package:user/Bloc/LikedBloc/liked_event.dart';
import 'package:user/Bloc/LikedBloc/liked_state.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DocumentOnline/document_item.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/no_login.dart';
import 'package:user/GeneralWidgets/refresh.dart';
import 'package:user/Home/fetch_documents.dart';
import 'package:user/iconsax_icons.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  final ScrollController _controller = ScrollController();
  List docs = [];

  String orderedBy = "default";

  ValueNotifier showLoading = ValueNotifier(false);

  @override
  void initState() {
    BlocProvider.of<LikedBloc>(context)
        .add(GetLikedEvent(offset: 0, order: orderedBy));
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        BlocProvider.of<LikedBloc>(context)
            .add(LoadMoreLikedEvent(offset: docs.length, order: orderedBy));
      }
    });
    super.initState();
  }

  void order(String order) {
    docs = [];
    orderedBy = order;
    BlocProvider.of<LikedBloc>(context)
        .add(GetLikedEvent(offset: 0, order: orderedBy));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<LikedBloc, LikedState>(
        builder: (context, state) => NestedScrollView(
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
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Text(
                            "مطالب پسندیده",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0B1B3F),
                                fontSize: 16),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Iconsax.like,
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
                              onPressed: state is LikedLoadingState
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
                              onPressed: state is LikedLoadingState
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
                                  "همه پسندیده شده ها",
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
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    if (state is LikedErrorState) ...[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Refresh(
                              onRefresh: () {
                                BlocProvider.of<LikedBloc>(context).add(
                                    GetLikedEvent(offset: 0, order: orderedBy));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (state is NoLoginState) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NoLogin(
                              title:
                                  "برای مشاهده لیست علاقه مندیهایتان\n وارد حساب کاربریتان شوید"),
                        ],
                      ),
                    ],
                    if (state is LikedLoadingState) ...[
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
                    if (state is LikedDataState) ...[
                      state.bookmarksList.fold((l) {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Refresh(onRefresh: () {
                                docs = [];

                                BlocProvider.of<LikedBloc>(context).add(
                                    GetLikedEvent(offset: 0, order: orderedBy));
                              })
                            ],
                          ),
                        );
                      }, (r) {
                        showLoading.value = r.next;
                        for (var i in r.documents) {
                          if (docs.contains(i) == false) {
                            docs.add(i);
                          }
                        }
                        if (r.documents.isNotEmpty) {
                          return Expanded(
                            child: ListView(children: [
                              ...r.documents.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    children: [
                                      HorizontalFullDetailsItem(
                                        document: e,
                                        remove: null,
                                      ),
                                      const SizedBox(height: 14),
                                      const Divider(),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: false,
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
                                ),
                              ),
                            ]),
                          );
                        } else {
                          return const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset("assets/images/empty_screen.png",
                                //     width: 300),
                                // const SizedBox(height: 10),
                                Text(
                                  "هنوز هیچ مطبی را نپسندیدید!",
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                    ],
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
    );
  }
}
