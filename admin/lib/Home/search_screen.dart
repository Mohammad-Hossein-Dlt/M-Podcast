import 'package:admin/Bloc/SearchBloc/search_block.dart';
import 'package:admin/Bloc/SearchBloc/search_event.dart';
import 'package:admin/Bloc/SearchBloc/search_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/Home/fetch_documents.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({
    super.key,
    required this.onDelete,
    this.bannerData,
    this.selectedList,
    this.replaceSelectedListItem,
    this.preSearch = "",
    this.preDocumentId = -1,
    this.back,
  });
  final bool onDelete;
  final Map? bannerData;
  final Map? selectedList;
  final int? replaceSelectedListItem;
  final String preSearch;
  final int preDocumentId;
  final ValueNotifier? back;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController name = TextEditingController();

  final ScrollController _controller = ScrollController();
  List docs = [];
  ValueNotifier showLoading = ValueNotifier(false);
  int offset = 0;
  String searchBy = "name";
  @override
  void initState() {
    name.text = widget.preSearch;
    if (widget.preSearch.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(FirstSearchByLabelResultData(
          offset: offset, topic: widget.preSearch, by: searchBy));
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
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            forceElevated: true,
            elevation: 2.5,
            shadowColor: Colors.white.withOpacity(0.5),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
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
                              color: searchBy == "text" ? blue : Colors.white,
                              border: Border.all(
                                color: searchBy == "text" ? blue : lightblue,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              "متن مطالب",
                              style: TextStyle(
                                color: searchBy == "text"
                                    ? Colors.white
                                    : const Color(0xff0B1B3F),
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
                              color: searchBy == "name" ? blue : Colors.white,
                              border: Border.all(
                                color: searchBy == "name" ? blue : lightblue,
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
                                    : const Color(0xff0B1B3F),
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
                        const Text(":جستجو در"),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (state is SearchLoadingState) ...[
            SliverFillRemaining(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Shimmer(
                      period: const Duration(milliseconds: 600),
                      gradient: LinearGradient(
                        colors: [
                          white,
                          const Color(0xffF4F4F4),
                          white,
                        ],
                        stops: const [
                          0.1,
                          0.3,
                          0.4,
                        ],
                        begin: const Alignment(-1.0, -0.3),
                        end: const Alignment(1.0, 0.3),
                        tileMode: TileMode.clamp,
                      ),
                      child: const AllDocumentsPageShimmer(),
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
                        decoration: BoxDecoration(
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
              offset = r.offset;
              showLoading.value = r.next;
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
                                  const Text(" نتایج جست‌وجو برای"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              textDirection: TextDirection.rtl,
                              runSpacing: 20,
                              spacing: 10,
                              children: [
                                ...docs.map((e) => e["name"] != ""
                                    ? Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: widget.bannerData !=
                                                        null ||
                                                    widget.selectedList !=
                                                        null ||
                                                    widget.replaceSelectedListItem !=
                                                        null,
                                                child: TextButton(
                                                  onPressed: () {
                                                    print(
                                                        docs[docs.indexOf(e)]);
                                                    if (widget.bannerData !=
                                                        null) {
                                                      widget.bannerData![
                                                              "documentName"] =
                                                          docs[docs.indexOf(e)]
                                                              ["name"];
                                                      widget.bannerData![
                                                              "documentId"] =
                                                          docs[docs.indexOf(e)]
                                                                  ["id"]
                                                              .toString();
                                                    }
                                                    if (widget.selectedList !=
                                                            null &&
                                                        widget.replaceSelectedListItem ==
                                                            null) {
                                                      widget
                                                          .selectedList!["list"]
                                                          .add(docs[docs
                                                                  .indexOf(e)]
                                                              ["name"]);
                                                    }
                                                    if (widget
                                                            .replaceSelectedListItem !=
                                                        null) {
                                                      widget.selectedList![
                                                                  "list"][
                                                              widget
                                                                  .replaceSelectedListItem] =
                                                          docs[docs.indexOf(e)]
                                                              ["name"];
                                                    }

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/images/add.svg",
                                                    color: green,
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: widget.onDelete,
                                                child: TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        // alignment: Alignment.bottomCenter,
                                                        backgroundColor:
                                                            const Color(
                                                                0xffF0F0F2),
                                                        elevation: 2,
                                                        content: Text(
                                                          "از حذف ${docs[docs.indexOf(e)]['name']} اطمینان دارید؟",
                                                          textAlign:
                                                              TextAlign.center,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        ),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    OutlinedButton(
                                                                        style: OutlinedButton
                                                                            .styleFrom(
                                                                          foregroundColor:
                                                                              const Color(0xff4BCB81),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            "خیر")),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              const Color(0xff4BCB81),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          BlocProvider.of<SearchBloc>(this.context)
                                                                              .add(
                                                                            DocumentDeleteEvent(
                                                                              name: docs[docs.indexOf(e)]["name"],
                                                                              id: int.parse(docs[docs.indexOf(e)]["id"]),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child: const Text(
                                                                            "بله")),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/images/trash.svg",
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          AnimatedOpacity(
                                            duration: const Duration(
                                                microseconds: 800),
                                            opacity: 1,
                                            child: e["text"].isEmpty
                                                ? FullDetailsItem(
                                                    document: e,
                                                    showInWrap: true,
                                                  )
                                                : FullDetailsItemWithSearchedText(
                                                    document: e,
                                                    searched: name.text),
                                          ),
                                        ],
                                      )
                                    : const SizedBox()),
                              ],
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
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: white,
                                ),
                                child: LoadingRing(
                                  lineWidth: 2,
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
            child: Icon(
              Iconsax.arrow_left,
              color: black,
            ),
            onPressed: () {
              if (widget.back != null) {
                widget.back!.value = false;
              } else {
                Navigator.of(context).pop();
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
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                            borderSide: BorderSide(color: midBlue, width: 1.4)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
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
                              child: Icon(
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
            // height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    widget.preSearch,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: black),
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          child: SvgPicture.asset(
            "assets/images/arrow-right2.svg",
            color: black,
          ),
          onPressed: () {
            if (widget.back == null) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
