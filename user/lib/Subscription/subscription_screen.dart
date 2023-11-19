import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/Bloc/SubscriptionBloc/subscription_block.dart';
import 'package:user/Bloc/SubscriptionBloc/subscription_event.dart';
import 'package:user/DocumentOnline/document_item.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/refresh.dart';
import 'package:user/Subscription/single_subscription_item.dart';
import 'package:user/iconsax_icons.dart';
import 'package:user/main.dart';

import '../Bloc/SubscriptionBloc/subscription_state.dart';
import '../Constants/colors.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final TextEditingController discountCode = TextEditingController();
  List subscription = [];
  bool isSetDiscountCode = false;
  String discountCodeResult = "";
  String selectedId = "";

  bool onDiscount = false;
  @override
  void initState() {
    BlocProvider.of<SubscriptionBloc>(context)
        .add(GetAllSubscriptionsEvent(discountCode: null));
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
            child: CustomScrollView(
              // physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  elevation: 2.5,
                  forceElevated: true,
                  shadowColor: Colors.white.withOpacity(0.5),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  centerTitle: true,
                  actions: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "خرید/تمدید اشتراک",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  leading: TextButton(
                    child: const Icon(Iconsax.arrow_left, color: Colors.black),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                if (state is SubscriptionLoadingState) ...[
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingRing(
                          lineWidth: 1.5,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ],
                if (state is SubscriptionsDataState) ...[
                  state.data.fold(
                      (l) => SliverFillRemaining(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Refresh(
                                  onRefresh: () {
                                    BlocProvider.of<SubscriptionBloc>(context)
                                        .add(GetAllSubscriptionsEvent(
                                            discountCode: null));
                                  },
                                ),
                              ],
                            ),
                          ), (r) {
                    subscription = r.subscriptions;
                    isSetDiscountCode = r.isSetDiscountCode;
                    discountCodeResult = r.discountCodeResult;
                    return content(onLoadingDiscountCode: false);
                  })
                ],
                if (state is SubscriptionWithDiscountCodeLoadingState) ...[
                  content(onLoadingDiscountCode: true),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget content({required bool onLoadingDiscountCode}) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          if (subscription.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...subscription.map((e) {
              return categorieItem(
                id: e["id"],
                title: e["title"],
                price: e["price"],
                discount: e["discount"],
                discountedPrice: e["discountedPrice"],
                preiod: e["period"],
                specialSubscription: e["specialSubscription"],
              );
            }).toList(),
            const SizedBox(height: 10),
            enterDiscountCode(onLoadingDiscountCode: onLoadingDiscountCode),
            const SizedBox(height: 40),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size(320, 50),
                  maximumSize: const Size(320, 50),
                  shadowColor: Colors.white,
                  backgroundColor: blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  side: const BorderSide(color: blue),
                ),
                onPressed: () async {
                  // Get.to(
                  //   () => BlocProvider(
                  //     create: (context) => SubscriptionBloc(),
                  //     child: SingleSubscriptionItem(
                  //         id: selectedId),
                  //   ),
                  // );
                  Map sub = subscription
                      .where((element) => element["id"] == selectedId)
                      .first;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => SubscriptionBloc(),
                        child: SingleSubscriptionItem(
                          id: selectedId,
                          title: sub["title"],
                          price: sub["price"],
                          discount: sub["discount"],
                          discountedPrice: sub["discountedPrice"],
                          preiod: sub["period"],
                          specialSubscription: sub["specialSubscription"],
                        ),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "ادامه",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 25),
                    Container(
                      color: white,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ضمانت بازگشت وجه",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 6),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "اگر به هر دلیلی از خرید اشتراک خود منصرف شدید، بدون هیچ سوالی مبلغ پرداختی شما با احترام بازگردانده میشود.",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                elevation: 0,
                                minimumSize: const Size(320, 50),
                                maximumSize: const Size(320, 50),
                                shadowColor: Colors.white,
                                // backgroundColor: green,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                side: const BorderSide(color: lightblue),
                              ),
                              onPressed: () async {
                                if (!await launchUrl(Uri.parse(contactUs),
                                    mode: LaunchMode.externalApplication)) {
                                  throw "";
                                }
                              },
                              child: const Text(
                                "ارتباط با پشتیبانی",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: green,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Iconsax.verify5,
                  size: 40,
                  color: green,
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget enterDiscountCode({required bool onLoadingDiscountCode}) {
    if (onDiscount) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    discountCodeResult,
                    textAlign: TextAlign.end,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: isSetDiscountCode ? green : red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size(100, 48),
                      maximumSize: const Size(100, 48),
                      shadowColor: Colors.white,
                      // backgroundColor: ,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      side: const BorderSide(color: lightblue),
                    ),
                    onPressed: onLoadingDiscountCode
                        ? null
                        : () {
                            BlocProvider.of<SubscriptionBloc>(context).add(
                                GetAllSubscriptionsEvent(
                                    discountCode: discountCode.text));
                          },
                    child: onLoadingDiscountCode
                        ? LoadingRing(
                            lineWidth: 1.5,
                            size: 20,
                          )
                        : const Text(
                            "اعمال کد",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blue,
                            ),
                          )),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border:
                          Border.all(color: const Color(0xffF1F5FF), width: 4),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        autofocus: false,
                        controller: discountCode,
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        minLines: 1,
                        decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                borderSide:
                                    BorderSide(color: midBlue, width: 1.4)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                borderSide:
                                    BorderSide(color: lightblue, width: 1)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            hintText: "کد تخفیف خود را وارد کنید",
                            hintStyle: TextStyle(
                              color: lightgray,
                              fontSize: 14,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: lightblue,
          ),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: () {
            setState(() {
              onDiscount = true;
            });
          },
          child: const Center(
            child: Text(
              "!کد تخفیف دارم",
              style: TextStyle(color: gray, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
  }

  Widget categorieItem({
    required String id,
    required String title,
    required String price,
    required String discount,
    required String discountedPrice,
    required String preiod,
    required bool specialSubscription,
  }) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: lightblue,
        ),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        onTap: () {
          setState(() {
            selectedId = id;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Iconsax.arrow_left_2,
                    color: blue,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "تومان",
                            style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          PersianNumber(
                            number: discountedPrice,
                            style: const TextStyle(
                              color: blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      discount != "0"
                          ? Row(
                              children: [
                                Text(
                                  "تومان",
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: red.withOpacity(0.75),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                PersianNumber(
                                  number: price,
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: red.withOpacity(0.75),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  discount != "0"
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: const BoxDecoration(
                                color: midWhite,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PersianNumber(
                                        number: (discount).toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: gray,
                                        )),
                                    const SizedBox(width: 2),
                                    const Text(
                                      "%",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: gray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: black,
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          color: specialSubscription
                              ? midRed.withOpacity(0.4)
                              : black,
                        ),
                        child: Center(
                          child: Text(
                            specialSubscription ? "ویژه" : "معمولی",
                            style: TextStyle(
                                color: specialSubscription
                                    ? red.withOpacity(0.8)
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: lightblue),
                      color: id == selectedId ? blue : Colors.transparent,
                    ),
                    child: const Visibility(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
