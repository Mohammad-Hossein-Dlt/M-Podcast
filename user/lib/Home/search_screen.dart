import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/Bloc/SearchBloc/search_block.dart';
import 'package:user/Bloc/SearchBloc/search_event.dart';
import 'package:user/Bloc/SearchBloc/search_state.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DocumentOnline/document_item.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/main.dart';

import '../iconsax_icons.dart';
import 'fetch_documents.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({
    super.key,
    this.preSearch = "",
    this.back,
    this.ignoredDocumentId = -1,
  });

  final ValueNotifier? back;
  final String preSearch;
  final int ignoredDocumentId;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController name = TextEditingController();
  final ScrollController _controller = ScrollController();

  List docs = [];
  bool showIndicator = true;
  ValueNotifier showLoading = ValueNotifier(false);
  int offset = 0;
  String searchBy = "name";
  @override
  void initState() {
    name.text = widget.preSearch;
    if (widget.preSearch.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(FirstSearchByLabelResultData(
          offset: offset, topic: widget.preSearch, by: searchBy));
    } else {
      BlocProvider.of<SearchBloc>(context).add(SearchDefaultEvent());
    }
    _controller.addListener(() async {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (widget.preSearch.isNotEmpty) {
          BlocProvider.of<SearchBloc>(context).add(FirstSearchByLabelResultData(
              offset: offset, topic: widget.preSearch, by: searchBy));
        } else {
          BlocProvider.of<SearchBloc>(context).add(LoadMoreSearchResultData(
              offset: offset, topic: widget.preSearch, by: searchBy));
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void order(String order) {
    docs = [];
    searchBy = order;
    offset = 0;
    if (widget.preSearch.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(FirstSearchByLabelResultData(
          offset: offset, topic: widget.preSearch, by: searchBy));
    } else {
      BlocProvider.of<SearchBloc>(context).add(FirstSearchResultData(
          offset: offset, topic: name.text, by: searchBy));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) => CustomScrollView(
        // controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            forceElevated: true,
            elevation: 2.5,
            shadowColor: Colors.white.withOpacity(0.6),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            toolbarHeight:
                kToolbarHeight + (widget.preSearch.isNotEmpty ? 40 : 50),
            leading: const SizedBox(),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Column(
                children: [
                  widget.preSearch.isEmpty ? srch() : preSearched(),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: searchBy == "text"
                                  ? accent_blue
                                  : Colors.white,
                              border: Border.all(
                                color: searchBy == "text"
                                    ? accent_blue
                                    : lightblue,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              "متن مطالب",
                              style: TextStyle(
                                color: searchBy == "text"
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: searchBy == "text"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (searchBy != "text") {
                              order("text");
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: searchBy == "name"
                                  ? accent_blue
                                  : Colors.white,
                              border: Border.all(
                                color: searchBy == "name"
                                    ? accent_blue
                                    : lightblue,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              widget.preSearch.isEmpty
                                  ? "عنوان مطالب"
                                  : "برچسب مطالب",
                              style: TextStyle(
                                color: searchBy == "name"
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: searchBy == "name"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (searchBy != "name") {
                              order("name");
                            }
                          },
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          ":جستجو در",
                          style: TextStyle(
                            color: black,
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (state is SearchLoadingState) ...[
            const SliverFillRemaining(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 46,
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
                  // Positioned(
                  //   top: 20,
                  //   child: Material(
                  //     elevation: 2,
                  //     color: Colors.white,
                  //     shadowColor: Colors.white,
                  //     shape: const CircleBorder(),
                  //     child: Container(
                  //       padding: const EdgeInsets.all(10),
                  //       width: 40,
                  //       height: 40,
                  //       decoration: const BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: midWhite,
                  //       ),
                  //       child: LoadingRing(
                  //         lineWidth: 1.5,
                  //         size: 20,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
          if (state is InitSearchLoadingState) ...[
            SliverFillRemaining(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xffF1F5FF),
                          ),
                          child: const Text("جستجو در عنوان یا متن مطالب",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, color: black)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (state is SearchDataState) ...[
            state.data.fold((l) {
              showLoading.value = false;

              return SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Refresh(
                      onRefresh: () {
                        if (widget.preSearch.isNotEmpty) {
                          BlocProvider.of<SearchBloc>(this.context).add(
                              FirstSearchByLabelResultData(
                                  offset: 0,
                                  topic: widget.preSearch,
                                  by: searchBy));
                        } else {
                          BlocProvider.of<SearchBloc>(this.context).add(
                              FirstSearchResultData(
                                  offset: 0, topic: name.text, by: searchBy));
                        }
                      },
                    ),
                  ],
                ),
              );
            }, (r) {
              showLoading.value = r.next;
              showIndicator = r.next;

              for (var i in r.documents) {
                if (docs.contains(i) == false) {
                  docs.add(i);
                }
              }
              return SliverFillRemaining(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SingleChildScrollView(
                        controller: _controller,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        name.text,
                                        maxLines: null,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    " نتایج جست‌وجو برای",
                                    style: TextStyle(
                                      color: black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...docs.map(
                              (e) =>
                                  e["id"] != widget.ignoredDocumentId.toString()
                                      ? AnimatedOpacity(
                                          duration:
                                              const Duration(microseconds: 800),
                                          opacity: 1,
                                          child: e["text"].isEmpty
                                              ? Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                      child:
                                                          HorizontalFullDetailsItem(
                                                        document: e,
                                                        remove: null,
                                                        // showInWrap: true,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 14),
                                                    const Divider(),
                                                  ],
                                                )
                                              : FullDetailsItemWithSearchedText(
                                                  document: e,
                                                  searched: name.text),
                                        )
                                      : const SizedBox(),
                            ),
                          ],
                        ),
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
              );
            })
          ]
        ],
      ),
    );
  }

  Widget srch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: const Icon(
              Iconsax.arrow_left,
              color: black,
            ),
            onPressed: () {
              if (widget.back != null) {
                widget.back!.value = false;
              } else {
                Get.back();
              }
            },
          ),
          Expanded(
            child: Container(
              height: 54,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: const Color(0xffF1F5FF), width: 4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: name,
                      textDirection: TextDirection.rtl,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            borderSide:
                                BorderSide(color: accent_blue, width: 1.4)),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            borderSide: BorderSide(color: lightblue, width: 1)),
                        hintTextDirection: TextDirection.rtl,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(right: 8),
                        hintText: "جستجو در $appName  ...",
                        prefixIcon: ValueListenableBuilder(
                          valueListenable: name,
                          builder: (context, value, child) => Visibility(
                            visible: name.text.isNotEmpty,
                            child: TextButton(
                              child: const Icon(
                                Icons.close_rounded,
                                color: black,
                                size: 20,
                              ),
                              onPressed: () {
                                BlocProvider.of<SearchBloc>(context)
                                    .add(SearchDefaultEvent());
                                name.text = "";
                                offset = 0;
                                docs = [];
                              },
                            ),
                          ),
                        ),
                      ),
                      onSubmitted: (value) {
                        offset = 0;

                        docs = [];
                        BlocProvider.of<SearchBloc>(context).add(
                            FirstSearchResultData(
                                offset: 0, topic: value, by: searchBy));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget preSearched() {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    widget.preSearch,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: black),
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          child: const Icon(
            Iconsax.arrow_right_1,
            color: black,
          ),
          onPressed: () {
            if (widget.back == null) {
              Get.back();
            }
          },
        ),
      ],
    );
  }

  Widget searchPreContentItemShimmer() {
    return Column(
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: const BoxDecoration(
            color: Color(0xffF0F0EE),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: 160,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xffF0F0EE),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: 160,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xffF0F0EE),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
