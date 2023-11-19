import 'package:admin/Bloc/EditCategoriesBloc/edit_categories_block.dart';
import 'package:admin/Bloc/EditCategoriesBloc/edit_categories_event.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/EditCategoriesBloc/edit_categories_state.dart';

class ReorderCategories extends StatefulWidget {
  const ReorderCategories({super.key});

  @override
  State<ReorderCategories> createState() => _ReorderCategoriesState();
}

class _ReorderCategoriesState extends State<ReorderCategories> {
  List categories = [];
  List unGroupingDocuments = [];
  List remove = [];
  bool isremove = false;
  @override
  void initState() {
    BlocProvider.of<EditCategoriesBloc>(context).add(GetCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<EditCategoriesBloc, EditCategoriesState>(
          builder: (context, state) => DefaultTabController(
            length: 2,
            initialIndex: 1,
            child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    elevation: 2.5,
                    forceElevated: true,
                    shadowColor: Colors.white.withOpacity(0.5),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    title: Text(""),
                    leading: TextButton(
                      child:
                          const Icon(Iconsax.arrow_left, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    actions: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              List groupsId =
                                  categories.map((e) => e["id"]).toList();
                              BlocProvider.of<EditCategoriesBloc>(context).add(
                                  ReorderCategoriesEvent(groupsId: groupsId));
                            },
                            child: const Icon(
                              Icons.check,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ];
              },
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is CategoriesDataLoadingState) ...[
                    LoadingRing(
                      lineWidth: 1.5,
                      size: 40,
                    ),
                  ],
                  if (state is CategoriesDataState) ...[
                    state.data.fold(
                        (l) => Refresh(
                              onRefresh: () {
                                BlocProvider.of<EditCategoriesBloc>(context)
                                    .add(GetCategoriesEvent());
                              },
                            ), (r) {
                      categories = r.categoriesList;
                      return Expanded(
                        child: RefreshIndicator(
                          backgroundColor: green,
                          color: Colors.white,
                          child: ReorderableListView(
                            onReorder: (oldIndex, newIndex) {
                              if (oldIndex < newIndex) {
                                newIndex--;
                              }
                              var old = categories.removeAt(oldIndex);
                              categories.insert(newIndex, old);
                              setState(() {});
                            },
                            children: [
                              if (categories.isNotEmpty) ...[
                                ...categories.map((e) {
                                  var x = e["subgroups"];
                                  if (x.isEmpty) {
                                    x = {};
                                  }
                                  return categorieItem(
                                    id: e["id"],
                                    groupName: e["name"],
                                    showInHomePage: e["showinhomepage"],
                                    specialGroup: e["specialGroup"],
                                    subGroup: x,
                                  );
                                }).toList(),
                              ]
                            ],
                          ),
                          onRefresh: () async {
                            BlocProvider.of<EditCategoriesBloc>(context)
                                .add(GetCategoriesEvent());
                          },
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

  Widget categorieItem({
    required String id,
    required String groupName,
    required bool showInHomePage,
    required bool specialGroup,
    required Map subGroup,
  }) {
    return Container(
      key: UniqueKey(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // height: 10,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: midWhite,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                groupName,
              ),
              const Text(
                ":عنوان",
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                showInHomePage ? "بله" : "خیر",
              ),
              const Text(
                ":فعال",
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                specialGroup ? "بله" : "خیر",
              ),
              const Text(
                ":گروه ویژه",
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                ":زیر گروه ها",
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            direction: Axis.horizontal,
            textDirection: TextDirection.rtl,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              ...subGroup.values.map(
                (e) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: const BoxDecoration(
                    color: midGreen,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Text(e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
