import 'package:admin/Bloc/SubscriptionBloc/subscription_block.dart';
import 'package:admin/Bloc/SubscriptionBloc/subscription_event.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/Subscription/single_subscription_item.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Bloc/SubscriptionBloc/subscription_state.dart';
import 'discountcode.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  List subscription = [];
  @override
  void initState() {
    BlocProvider.of<SubscriptionBloc>(context).add(GetAllSubscriptionsEvent());
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
                      "اشتراک",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    // centerTitle: true,
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
                          visible: value is SubscriptionsDataState,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => SubscriptionBloc(),
                                        child: const DiscountCode(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "کد تخفیف",
                                  style: TextStyle(
                                      color: blue, fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => SubscriptionBloc(),
                                        child: SingleSubscriptionItem(),
                                      ),
                                    ),
                                  )
                                      .then((value) {
                                    BlocProvider.of<SubscriptionBloc>(context)
                                        .add(GetAllSubscriptionsEvent());
                                  });
                                },
                                child: SvgPicture.asset(
                                  "assets/images/add.svg",
                                  color: black,
                                ),
                              ),
                            ],
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
                  if (state is SubscriptionsDataState) ...[
                    state.data.fold(
                        (l) => Refresh(
                              onRefresh: () {
                                BlocProvider.of<SubscriptionBloc>(context)
                                    .add(GetAllSubscriptionsEvent());
                              },
                            ), (r) {
                      subscription = r.subscriptions;
                      return Expanded(
                        child: RefreshIndicator(
                          backgroundColor: green,
                          color: Colors.white,
                          child: ListView(
                            children: [
                              if (subscription.isNotEmpty) ...[
                                ...subscription.map((e) {
                                  return categorieItem(
                                    id: e["id"],
                                    title: e["title"],
                                    price: e["price"],
                                    discount: e["discount"],
                                    discountedPrice: e["discountedPrice"],
                                    preiod: e["period"],
                                    specialSubscription:
                                        e["specialSubscription"],
                                    forcedSelfDiscount: e["DiscountCodeApply"],
                                  );
                                }).toList(),
                              ]
                            ],
                          ),
                          onRefresh: () async {
                            BlocProvider.of<SubscriptionBloc>(context)
                                .add(GetAllSubscriptionsEvent());
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
    required String title,
    required String price,
    required String discount,
    required String discountedPrice,
    required String preiod,
    required bool specialSubscription,
    required bool forcedSelfDiscount,
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
              Text(title),
              const Text(" :عنوان"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price),
              const Text(" :قیمت"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$discount% درصد",
                textDirection: TextDirection.rtl,
              ),
              const Text(" :(درصد) تخفیف"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(discountedPrice),
              const Text(" :قیمت با تخفیف"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$preiod ماهه",
                textDirection: TextDirection.rtl,
              ),
              const Text(" :(ماهانه) مدت اشتراک"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(specialSubscription ? "بله" : "خیر"),
              const Text(" :اشتراک ویژه"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(forcedSelfDiscount ? "بله" : "خیر"),
              const Text(" :کد تخفیف اعمال شود؟"),
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
                        child: SingleSubscriptionItem(id: id),
                      ),
                    ),
                  )
                      .then((value) {
                    BlocProvider.of<SubscriptionBloc>(context)
                        .add(GetAllSubscriptionsEvent());
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
