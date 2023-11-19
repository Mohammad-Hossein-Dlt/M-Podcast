import 'package:admin/Bloc/SubscriptionBloc/subscription_block.dart';
import 'package:admin/Bloc/SubscriptionBloc/subscription_event.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/Subscription/discountcode_item.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Bloc/SubscriptionBloc/subscription_state.dart';

class DiscountCode extends StatefulWidget {
  const DiscountCode({super.key});

  @override
  State<DiscountCode> createState() => _DiscountCodeState();
}

class _DiscountCodeState extends State<DiscountCode> {
  List discountCodes = [];
  @override
  void initState() {
    BlocProvider.of<SubscriptionBloc>(context).add(GetAllDiscountCodeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
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
                    foregroundColor: black,
                    title: const Text(
                      "کد تخفیف",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    leading: TextButton(
                      child:
                          const Icon(Iconsax.arrow_left, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    actions: [
                      ValueListenableBuilder(
                        valueListenable: ValueNotifier(state),
                        builder: (context, value, child) => Visibility(
                          visible: value is DiscountCodeDataState,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => SubscriptionBloc(),
                                    child: SingleDiscountCodeItem(),
                                  ),
                                ),
                              )
                                  .then((value) {
                                BlocProvider.of<SubscriptionBloc>(context)
                                    .add(GetAllDiscountCodeEvent());
                              });
                            },
                            child: SvgPicture.asset(
                              "assets/images/add.svg",
                              color: black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ];
              },
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is SubscriptionLoadingState) ...[
                    LoadingRing(
                      lineWidth: 1.5,
                      size: 40,
                    ),
                  ],
                  if (state is DiscountCodeDataState) ...[
                    state.data.fold(
                        (l) => Refresh(
                              onRefresh: () {
                                BlocProvider.of<SubscriptionBloc>(context)
                                    .add(GetAllDiscountCodeEvent());
                              },
                            ), (r) {
                      discountCodes = r.discountCodes;
                      return Expanded(
                        child: RefreshIndicator(
                          backgroundColor: green,
                          color: Colors.white,
                          child: ListView(
                            children: [
                              if (discountCodes.isNotEmpty) ...[
                                ...discountCodes.map((e) {
                                  return categorieItem(
                                    id: e["id"],
                                    code: e["code"],
                                    normalPercent: e["normalPercent"],
                                    specialPercent: e["specialPercent"],
                                  );
                                }).toList(),
                              ]
                            ],
                          ),
                          onRefresh: () async {
                            BlocProvider.of<SubscriptionBloc>(context)
                                .add(GetAllDiscountCodeEvent());
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
    required String code,
    required String normalPercent,
    required String specialPercent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // height: 10,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(code),
              const Text(" :کد تخفیف"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(normalPercent),
              const Text(" :درصد تخفیف معمولی"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(specialPercent),
              const Text(" :درصد تخفیف ویژه"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => SubscriptionBloc(),
                        child: SingleDiscountCodeItem(id: id),
                      ),
                    ),
                  )
                      .then((value) {
                    BlocProvider.of<SubscriptionBloc>(context)
                        .add(GetAllDiscountCodeEvent());
                  });
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: const BoxDecoration(
                    // color: Color(0xffEDF8EA),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: Text(
                      "ویرایش",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
