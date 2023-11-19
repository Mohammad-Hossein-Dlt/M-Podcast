import 'package:admin/Bloc/UnGroupingDocumentsBloc/ungrouping_documents_block.dart';
import 'package:admin/Bloc/UnGroupingDocumentsBloc/ungrouping_documents_event.dart';
import 'package:admin/Bloc/UnGroupingDocumentsBloc/ungrouping_documents_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DocumentOnline/document_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class UnGroupingDocuments extends StatefulWidget {
  const UnGroupingDocuments({super.key});

  @override
  State<UnGroupingDocuments> createState() => _UnGroupingDocumentsState();
}

class _UnGroupingDocumentsState extends State<UnGroupingDocuments>
    with SingleTickerProviderStateMixin {
  List unGroupingDocuments = [];
  List remove = [];
  bool isremove = false;
  @override
  void initState() {
    BlocProvider.of<UnGroupingDocumentsBloc>(context)
        .add(GetUnGroupingDocumentsEvent());
    // BlocProvider.of<EditCategoriesBloc>(context)
    //     .add(GetUnGroupingDocumentsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: BlocBuilder<UnGroupingDocumentsBloc, UnGroupingDocumentsState>(
          builder: (context, state) => DefaultTabController(
            length: 2,
            initialIndex: 1,
            child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    // floating: true,
                    pinned: true,
                    forceElevated: true,
                    elevation: 0,
                    shadowColor: white,
                    backgroundColor: white,
                    foregroundColor: Colors.black,
                    title: Text(
                      "اسناد خارج از دسته بندی",
                      style: TextStyle(
                          color: lightgray,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                    leading: Container(),
                    actions: [
                      TextButton(
                        child: SvgPicture.asset(
                          "assets/images/arrow-right2.svg",
                          color: gray,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ];
              },
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is UnGroupingDocumentsDataLoadingState) ...[
                    SpinKitRing(
                      color: black,
                      duration: const Duration(milliseconds: 800),
                      size: 40,
                      lineWidth: 1.4,
                    ),
                  ],
                  if (state is UnGroupingDocumentsDataState) ...[
                    state.data.fold((l) => Text(l), (r) {
                      unGroupingDocuments = r;
                      print(unGroupingDocuments);
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            BlocProvider.of<UnGroupingDocumentsBloc>(context)
                                .add(GetUnGroupingDocumentsEvent());
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...unGroupingDocuments.map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: HorizontalFullDetailsItem(
                                        document: e,
                                        remove: null,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
