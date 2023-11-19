import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_event.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../Bloc/FetchDocumentsBloc/fetch_documents_bloc.dart';
import '../Bloc/FetchDocumentsBloc/fetch_documents_state.dart';

class GroupSubgroup {
  final String group;
  final String subGroup;
  GroupSubgroup({required this.group, required this.subGroup});
}

class FetchDocuments extends StatefulWidget {
  FetchDocuments({
    super.key,
    required this.title,
    required this.by,
    this.ignoredDocumentId = -1,
    required this.fromCategories,
  });
  final String title;
  final String by;
  final int ignoredDocumentId;
  final GroupSubgroup? fromCategories;

  @override
  State<FetchDocuments> createState() => _FetchDocumentsState();
}

class _FetchDocumentsState extends State<FetchDocuments> {
  final ScrollController _controller = ScrollController();
  List docs = [];
  bool showIndicator = true;
  Widget loading = Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: LoadingRing(
      lineWidth: 1.5,
      size: 20,
    ),
  );
  ValueNotifier showLoading = ValueNotifier(false);
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

      _controller.addListener(() {
        if (_controller.position.maxScrollExtent == _controller.offset) {
          if (showIndicator) {
            showLoading.value = true;
          }
          BlocProvider.of<FetchDocumentsBloc>(context).add(
            FetchMoreByEvent(
              offset: docs.length,
              by: widget.by,
              group: widget.fromCategories!.group,
              subGroup: widget.fromCategories!.subGroup,
            ),
          );
        }
      });
    } else {
      BlocProvider.of<FetchDocumentsBloc>(context)
          .add(FetchFirstDocumentsEvent(offset: 0, by: widget.by));

      _controller.addListener(() {
        if (_controller.position.maxScrollExtent == _controller.offset) {
          if (showIndicator) {
            showLoading.value = true;
          }
          BlocProvider.of<FetchDocumentsBloc>(context)
              .add(FetchMoreDocumentsEvent(offset: docs.length, by: widget.by));
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffFAFAFA),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white.withOpacity(0.6),
        elevation: 2.5,
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 40),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: BlocBuilder<FetchDocumentsBloc, FetchDocumentsState>(
        builder: (context, state) => Stack(
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
                    // const SizedBox(height: 20),
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
                        showLoading.value = false;
                        return Refresh(onRefresh: () {
                          if (widget.fromCategories != null) {
                            BlocProvider.of<FetchDocumentsBloc>(context)
                                .add(FetchFirstDocumentsByEvent(
                              offset: 0,
                              by: widget.by,
                              group: widget.fromCategories!.group,
                              subGroup: widget.fromCategories!.subGroup,
                            ));
                          } else {
                            BlocProvider.of<FetchDocumentsBloc>(context).add(
                                FetchFirstDocumentsEvent(
                                    offset: 0, by: widget.by));
                          }
                        });
                      },
                      (r) {
                        showLoading.value = false;

                        for (var i in r.documents) {
                          if (docs.contains(i) == false) {
                            docs.add(i);
                          }
                        }
                        showIndicator = r.next;
                        return Expanded(
                          child: SingleChildScrollView(
                            controller: _controller,
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                ...docs.map(
                                  (e) => e["id"] !=
                                          widget.ignoredDocumentId.toString()
                                      ? AnimatedOpacity(
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
                                        )
                                      : const SizedBox(),
                                ),
                                Visibility(
                                  visible: showIndicator,
                                  child: loading,
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
                          lineWidth: 2,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      )),
    );
  }
}

class AllDocumentsPageShimmer extends StatelessWidget {
  const AllDocumentsPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          item(context),
          item(context),
          item(context),
          item(context),
          item(context),
          item(context),
        ],
      ),
    );
  }

  Widget item(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 200,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xffF0F0EE),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 200,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xffF0F0EE),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 60,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xffF0F0EE),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 116,
                height: 116,
                decoration: const BoxDecoration(
                  color: Color(0xffF0F0EE),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Container(
            height: 1,
            width: double.infinity,
            color: Color(0xffF0F0EE),
          ),
        ],
      ),
    );
  }
}
