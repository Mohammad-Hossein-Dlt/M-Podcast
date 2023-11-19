import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/Bloc/SubscriptionBloc/subscription_block.dart';
import 'package:user/Bloc/SubscriptionBloc/subscription_event.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DocumentOnline/document_item.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/iconsax_icons.dart';
import 'package:zarinpal/zarinpal.dart';

class SingleSubscriptionItem extends StatefulWidget {
  SingleSubscriptionItem({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.preiod,
    required this.specialSubscription,
  });
  final String id;

  final String title;
  final String price;
  final String discount;
  final String discountedPrice;
  final String preiod;
  final bool specialSubscription;
  @override
  State<SingleSubscriptionItem> createState() => _SingleSubscriptionItemState();
}

class _SingleSubscriptionItemState extends State<SingleSubscriptionItem> {
  final PaymentRequest _paymentRequest = PaymentRequest();
  bool loaded = false;

  bool onrequest = false;
  @override
  void initState() {
    BlocProvider.of<SubscriptionBloc>(context)
        .add(GetSingleSubscriptionEvent(id: widget.id));

    _paymentRequest.setIsSandBox(true);
    _paymentRequest.setAmount(int.parse(widget.discountedPrice));
    _paymentRequest.setMerchantID("d8dfb41e-881c-41cb-a4f2-20ff025f8c57");
    _paymentRequest.setDescription("خرید اشتراک ${widget.title}");
    _paymentRequest.setCallbackURL("ruzehkhan://payment");

    linkStream.listen((event) {
      if (event!.toLowerCase().contains("authority")) {
        Fluttertoast.showToast(
          msg: event,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER_RIGHT,
          backgroundColor: purple,
          textColor: Colors.white,
        );
      }
    });

    super.initState();
  }

  Widget content({
    required String title,
    required String price,
    required String discount,
    required String discountedPrice,
    required String preiod,
    required bool specialSubscription,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  Card(
                    elevation: 2.5,
                    color: white,
                    shadowColor: Colors.white.withOpacity(0.5),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 26),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  color: specialSubscription
                                      ? const Color(0xffFFF4E2)
                                      : midGreen,
                                ),
                                child: Center(
                                  child: Text(
                                    specialSubscription ? "ویژه" : "معمولی",
                                    style: TextStyle(
                                        color: specialSubscription
                                            ? const Color(0xffEB6116)
                                            : green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "خرید اشتراک ${title}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "تومان",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  PersianNumber(
                                    number: price,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(" :قیمت"),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: lightblue,
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "تومان",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  PersianNumber(
                                    number: discountedPrice,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  discount != "0"
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                              decoration: const BoxDecoration(
                                                // color: midWhite,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    PersianNumber(
                                                        number: (discount)
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: gray,
                                                        )),
                                                    const SizedBox(width: 2),
                                                    const Text(
                                                      "%",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  const Text(" قیمت کل"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "!توجه",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "قبل از کلیک روی دکمه پرداخت از خاموش بودن فیلترشکن خود به منظور عدم اختلال در کارکرد صفحه بانک اطمینان حاصل کنید.",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "لطفا از باز بودن برنامه هنگام انجام فرایند پرداخت مطمئن شوید، چراکه در غیر این صورت عواقب آن بر عهده کاربر میباشد.",
                            textDirection: TextDirection.rtl,
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
                                backgroundColor: blue,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                side: const BorderSide(color: blue),
                              ),
                              onPressed: onrequest
                                  ? null
                                  : () async {
                                      setState(() {
                                        onrequest = true;
                                      });
                                      ZarinPal().startPayment(_paymentRequest,
                                          (status, paymentGatewayUri) async {
                                        if (status == 100) {
                                          if (!await launchUrl(
                                              Uri.parse(paymentGatewayUri!),
                                              mode: LaunchMode
                                                  .externalApplication)) {
                                            throw "";
                                          }
                                        }
                                        setState(() {
                                          onrequest = false;
                                        });
                                      });
                                    },
                              child: onrequest
                                  ? LoadingRing()
                                  : const Text(
                                      "پرداخت",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Column(
                      children: [
                        Icon(
                          Iconsax.verify5,
                          size: 40,
                          color: green,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "اگر به هر دلیلی از خرید اشتراک خود منصرف شدید، بدون هیچ سوالی مبلغ پرداختی شما با احترام بازگردانده میشود.",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Material(
              shape: const CircleBorder(),
              shadowColor: Colors.white.withOpacity(0.5),
              elevation: 2.5,
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: green,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2.5,
        shadowColor: Colors.white.withOpacity(0.5),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "پرداخت",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
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
      body: SafeArea(
        child: content(
            title: widget.title,
            price: widget.price,
            discount: widget.discount,
            discountedPrice: widget.discountedPrice,
            preiod: widget.preiod,
            specialSubscription: widget.specialSubscription),
        // child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        //   builder: (context, state) => Column(
        //     children: [
        //       if (state is SubscriptionLoadingState) ...[
        //         Expanded(
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   LoadingRing(
        //                     lineWidth: 1.5,
        //                     size: 40,
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         )
        //       ],
        //       if (state is SingleSubscriptionDataState) ...[
        //         state.data.fold(
        //             (l) => Expanded(
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         children: [
        //                           Refresh(
        //                             onRefresh: () {
        //                               BlocProvider.of<SubscriptionBloc>(context)
        //                                   .add(GetSingleSubscriptionEvent(
        //                                       id: widget.id));
        //                             },
        //                           ),
        //                         ],
        //                       ),
        //                     ],
        //                   ),
        //                 ), (r) {
        //           if (!loaded) {
        //             loaded = true;
        //           }
        //           return content(
        //             title: r.title,
        //             price: r.price,
        //             discount: r.discount,
        //             discountedPrice: "",
        //             preiod: r.period,
        //             specialGroup: r.specialGroup,
        //           );
        //         })
        //       ],
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
