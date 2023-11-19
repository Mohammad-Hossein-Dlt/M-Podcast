import 'package:admin/Bloc/CategoriesBloc/categories_block.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_event.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_state.dart';
import 'package:admin/Bloc/CategoriesPageBloc/categories_page_block.dart';
import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_bloc.dart';
import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_event.dart';
import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_state.dart';
import 'package:admin/Bloc/SubGroupsBloc/subgroups_block.dart';
import 'package:admin/Bloc/SubGroupsBloc/subgroups_event.dart';
import 'package:admin/Bloc/SubGroupsBloc/subgroups_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:admin/Home/fetch_documents.dart';
import 'package:admin/Home/pagescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ShowMore extends StatelessWidget {
  const ShowMore({super.key, this.color = red});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        "مشاهده بیشتر",
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12
            // fontSize: 12,
            ),
      ),
    );
  }
}

class AllDocumentsItemStyle1 extends StatefulWidget {
  const AllDocumentsItemStyle1({
    super.key,
    required this.title,
    this.by = "newest",
    required this.preTitle,
    required this.shimmerColor,
    this.fromCategories,
  });

  final String title;
  final String by;
  final String preTitle;
  final Color shimmerColor;
  final GroupSubgroup? fromCategories;
  @override
  State<AllDocumentsItemStyle1> createState() => _AllDocumentsItemStyle1State();
}

class _AllDocumentsItemStyle1State extends State<AllDocumentsItemStyle1> {
  @override
  void initState() {
    if (widget.fromCategories != null) {
      BlocProvider.of<FetchDocumentsBloc>(context)
          .add(FetchFirstDocumentsByEvent(
        offset: 0,
        by: widget.by,
        group: widget.fromCategories!.group,
        subGroup: widget.fromCategories!.subGroup,
      ));
    } else {
      BlocProvider.of<FetchDocumentsBloc>(context)
          .add(FetchFirstDocumentsEvent(offset: 0, by: widget.by));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchDocumentsBloc, FetchDocumentsState>(
        builder: (context, state) => Column(
              children: [
                if (state is FetchDocumentsLoading) ...[
                  shimmer(),
                ],
                if (state is FetchDocumentsData) ...[
                  state.data.fold((l) {
                    return shimmer();
                  }, (r) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: ShowMore(),
                                onPressed: () {
                                  if (widget.fromCategories != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) =>
                                              FetchDocumentsBloc(),
                                          child: FetchDocuments(
                                            title: widget.title,
                                            by: "newest",
                                            fromCategories:
                                                widget.fromCategories,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) =>
                                              FetchDocumentsBloc(),
                                          child: FetchDocuments(
                                            title: widget.title,
                                            by: widget.by,
                                            fromCategories: null,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Expanded(
                                  child: Text(
                                    widget.title.isNotEmpty
                                        ? widget.title
                                        : widget.preTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            children: [
                              ...r.documents.reversed.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: FullDetailsItem(
                                    document: e,
                                    showInWrap: false,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ]
              ],
            ));
  }

  Widget shimmer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: ShowMore(),
                onPressed: () {
                  if (widget.fromCategories != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => FetchDocumentsBloc(),
                          child: FetchDocuments(
                            title: widget.title,
                            by: "newest",
                            fromCategories: widget.fromCategories,
                          ),
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => FetchDocumentsBloc(),
                          child: FetchDocuments(
                            title: widget.title,
                            by: widget.by,
                            fromCategories: null,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Expanded(
                  child: Text(
                    widget.title.isNotEmpty ? widget.title : widget.preTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Shimmer(
          period: const Duration(milliseconds: 800),
          gradient: LinearGradient(
            colors: [
              widget.shimmerColor,
              Colors.white,
              widget.shimmerColor,
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
          child: const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: HorizontalDocumentShimmer(),
          ),
        ),
      ],
    );
  }
}

class AllDocumentsItemStyle2 extends StatefulWidget {
  const AllDocumentsItemStyle2({
    super.key,
    required this.title,
    this.by = "newest",
    required this.preTitle,
    required this.shimmerColor,
    this.fromCategories,
  });

  final String title;
  final String by;
  final String preTitle;
  final Color shimmerColor;
  final GroupSubgroup? fromCategories;
  @override
  State<AllDocumentsItemStyle2> createState() => _AllDocumentsItemStyle2State();
}

class _AllDocumentsItemStyle2State extends State<AllDocumentsItemStyle2> {
  @override
  void initState() {
    if (widget.fromCategories != null) {
      BlocProvider.of<FetchDocumentsBloc>(context)
          .add(FetchFirstDocumentsByEvent(
        offset: 0,
        by: widget.by,
        group: widget.fromCategories!.group,
        subGroup: widget.fromCategories!.subGroup,
      ));
    } else {
      BlocProvider.of<FetchDocumentsBloc>(context)
          .add(FetchFirstDocumentsEvent(offset: 0, by: widget.by));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchDocumentsBloc, FetchDocumentsState>(
        builder: (context, state) => Column(
              children: [
                if (state is FetchDocumentsLoading) ...[
                  shimmer(),
                ],
                if (state is FetchDocumentsData) ...[
                  state.data.fold((l) {
                    return shimmer();
                  }, (r) {
                    return Container(
                      height: 260,
                      color: black,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 240,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              child: Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: ShowMore(color: Colors.white),
                                    onPressed: () {
                                      if (widget.fromCategories != null) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  FetchDocumentsBloc(),
                                              child: FetchDocuments(
                                                title: widget.title,
                                                by: "newest",
                                                fromCategories:
                                                    widget.fromCategories,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  FetchDocumentsBloc(),
                                              child: FetchDocuments(
                                                title: widget.title,
                                                by: widget.by,
                                                fromCategories: null,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  ...r.documents.reversed.map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: FullDetailsItem(
                                        document: e,
                                        showInWrap: false,
                                      ),
                                    );
                                  }),
                                  Container(
                                    width: 104,
                                    height: 240,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 14),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                      color: black,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Text(
                                                    widget.title,
                                                    // maxLines: 1,
                                                    // overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            backgroundColor: Colors.white,
                                            minimumSize: const Size(100, 38),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          child: ShowMore(color: black),
                                          onPressed: () {
                                            if (widget.fromCategories != null) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlocProvider(
                                                    create: (context) =>
                                                        FetchDocumentsBloc(),
                                                    child: FetchDocuments(
                                                      title: widget.title,
                                                      by: "newest",
                                                      fromCategories:
                                                          widget.fromCategories,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlocProvider(
                                                    create: (context) =>
                                                        FetchDocumentsBloc(),
                                                    child: FetchDocuments(
                                                      title: widget.title,
                                                      by: widget.by,
                                                      fromCategories: null,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  }),
                ]
              ],
            ));
  }

  Widget shimmer() {
    return Container(
      height: 260,
      color: black,
      child: Column(
        children: [
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: [
                const Shimmer(
                  period: Duration(milliseconds: 1200),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff3F3F3F),
                      Color(0xff272727),
                      Color(0xff3F3F3F),
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
                  child: HorizontalDocumentShimmer(),
                ),
                Container(
                  width: 104,
                  height: 240,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: black,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(100, 38),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: ShowMore(color: black),
                        onPressed: () {
                          if (widget.fromCategories != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => FetchDocumentsBloc(),
                                  child: FetchDocuments(
                                    title: widget.title,
                                    by: "newest",
                                    fromCategories: widget.fromCategories,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => FetchDocumentsBloc(),
                                  child: FetchDocuments(
                                    title: widget.title,
                                    by: widget.by,
                                    fromCategories: null,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CategoriesItem extends StatefulWidget {
  const CategoriesItem({
    super.key,
    required this.title,
    required this.preTitle,
  });
  final String title;
  final String preTitle;
  @override
  State<CategoriesItem> createState() => _CategoriesItemState();
}

class _CategoriesItemState extends State<CategoriesItem> {
  @override
  void initState() {
    BlocProvider.of<CategoriesBloc>(context).add(GetCategoriesData());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) => Column(
              children: [
                if (state is CategoriesLoadingState) ...[
                  shimmer(),
                ],
                if (state is CategoriesDataState) ...[
                  state.data.fold((l) {
                    return shimmer();
                  }, (r) {
                    return Container(
                      color: const Color(0xffF5F5F5),
                      child: SizedBox(
                        height: 70,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (r.categoriesList.isNotEmpty) ...[
                                ...r.categoriesList.reversed.map((e) => e[
                                        "showinhomepage"]
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
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
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                  create: (context) =>
                                                      CategoriesPageBloc(),
                                                  child: PageScreen(
                                                    id: e["id"],
                                                    groupName: e["name"],
                                                    image: e["image"],
                                                  ),
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
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 6),
                                                  child: Text(
                                                    e["name"],
                                                    style: const TextStyle(
                                                      color: black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                e["image"] != null &&
                                                        e["image"].isNotEmpty
                                                    ? SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 32,
                                                              height: 32,
                                                              child: FittedBox(
                                                                fit:
                                                                    BoxFit.fill,
                                                                child: ImageItem
                                                                    .Category(
                                                                  imageName: e[
                                                                      "image"],
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 14),
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
                                        widget.title.isNotEmpty
                                            ? widget.title
                                            : widget.preTitle,
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
                  }),
                ]
              ],
            ));
  }

  Widget shimmer() {
    return Stack(
      children: [
        Shimmer(
          period: const Duration(milliseconds: 800),
          gradient: const LinearGradient(
            colors: [
              Color(0xffF5F5F5),
              Colors.white,
              Color(0xffF5F5F5),
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            decoration: const BoxDecoration(
              color: midWhite,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
                  widget.title.isNotEmpty ? widget.title : widget.preTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubGroupsItem extends StatefulWidget {
  const SubGroupsItem({
    super.key,
    required this.id,
    required this.title,
    required this.preTitle,
  });
  final String id;
  final String title;
  final String preTitle;
  @override
  State<SubGroupsItem> createState() => _SubGroupsItemtate();
}

class _SubGroupsItemtate extends State<SubGroupsItem> {
  @override
  void initState() {
    BlocProvider.of<SubGroupsBloc>(context)
        .add(GetSubGroupsData(mainGroupId: widget.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubGroupsBloc, SubGroupsState>(
        builder: (context, state) => Column(
              children: [
                if (state is SubGroupsLoadingState) ...[
                  shimmer(),
                ],
                if (state is SubGroupsDataState) ...[
                  state.data.fold((l) {
                    return shimmer();
                  }, (r) {
                    return Container(
                      color: const Color(0xffF5F5F5),
                      child: SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (r.subGroups.isNotEmpty) ...[
                                ...r.subGroups.reversed.map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                create: (context) =>
                                                    FetchDocumentsBloc(),
                                                child: SubGroupPage(
                                                  mainGroupId: widget.id,
                                                  subGroupId: e["id"],
                                                  subGroup: e["name"],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            e["name"],
                                            style: const TextStyle(
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                              // fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                Container(
                                  height: 70,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 14),
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
                                        widget.title.isNotEmpty
                                            ? widget.title
                                            : widget.preTitle,
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
                  }),
                ]
              ],
            ));
  }

  Widget shimmer() {
    return Stack(
      children: [
        Shimmer(
          period: const Duration(milliseconds: 800),
          gradient: const LinearGradient(
            colors: [
              Color(0xffF5F5F5),
              Colors.white,
              Color(0xffF5F5F5),
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            decoration: const BoxDecoration(
              color: midWhite,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
                  widget.title.isNotEmpty ? widget.title : widget.preTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HorizontalDocumentShimmer extends StatelessWidget {
  const HorizontalDocumentShimmer({super.key});

  final Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        item(context),
        item(context),
        item(context),
        item(context),
        item(context),
        item(context),
      ],
    );
  }

  Widget item(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: 270,
            height: 160,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 270,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 270,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 270,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 200,
                        height: 20,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
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
    );
  }
}
