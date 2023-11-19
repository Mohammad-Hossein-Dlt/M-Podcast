import 'package:admin/Bloc/SubscriptionBloc/subscription_block.dart';
import 'package:admin/Bloc/SubscriptionBloc/subscription_event.dart';
import 'package:admin/Bloc/SubscriptionBloc/subscription_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../DataModel/data_model.dart';

class SingleDiscountCodeItem extends StatefulWidget {
  SingleDiscountCodeItem({
    super.key,
    this.id,
  });
  final String? id;
  @override
  State<SingleDiscountCodeItem> createState() => _SingleDiscountCodeItemState();
}

class _SingleDiscountCodeItemState extends State<SingleDiscountCodeItem> {
  TextEditingController code = TextEditingController();
  TextEditingController normalPercent = TextEditingController();
  TextEditingController specialPercent = TextEditingController();

  FocusNode fNode = FocusNode();

  bool loaded = false;
  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<SubscriptionBloc>(context)
          .add(GetSingleDiscountCodeEvent(id: widget.id!));
    } else {
      BlocProvider.of<SubscriptionBloc>(context)
          .add(SingleDiscountCodeDefaultEvent());

      code.text = "code";
      normalPercent.text = "0";
      specialPercent.text = "0";
    }
    super.initState();
  }

  Widget content() {
    return Expanded(
      child: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            elevation: 2.5,
            shadowColor: Colors.white.withOpacity(0.5),
            backgroundColor: Colors.white,
            forceElevated: true,
            stretch: false,
            // toolbarHeight: 50,
            foregroundColor: black,
            leadingWidth: 140,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    BuildContext ctx = this.context;
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        // alignment: Alignment.bottomCenter,
                        backgroundColor: const Color(0xffF0F0F2),
                        elevation: 2,
                        content: const Text(
                          "این کد نخفیف ایجاد شود؟",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: green,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("خیر")),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: green,
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<SubscriptionBloc>(ctx)
                                          .add(
                                        DiscountCodeUploadEvent(
                                          singleSubscriptionDataModel:
                                              SingleDiscountCodeDataModel(
                                            id: widget.id,
                                            code: code.text,
                                            normalPercent: normalPercent.text,
                                            specialPercent: specialPercent.text,
                                          ),
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("بله")),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    "assets/images/document-upload.svg",
                    width: 30,
                    height: 30,
                  ),
                ),
                TextButton(
                  onPressed: widget.id != null
                      ? () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              // alignment: Alignment.bottomCenter,
                              backgroundColor: const Color(0xffF0F0F2),
                              elevation: 2,
                              content: const Text(
                                "از حذف این کد تخفیف اطمینان دارید؟",
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: green,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("خیر")),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: green,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            BlocProvider.of<SubscriptionBloc>(
                                                    this.context)
                                                .add(DiscountCodeDeleteEvent(
                                                    id: widget.id ?? ""));
                                          },
                                          child: const Text("بله")),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      : null,
                  child: SvgPicture.asset(
                    "assets/images/trash.svg",
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  "assets/images/arrow-right2.svg",
                ),
              ),
            ],
          ),
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "کد تخفیف",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                            color: const Color(0xffF1F5FF), width: 4),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: code,
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
                                horizontal: 15, vertical: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            "درصد تخفیف معمولی",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                            color: const Color(0xffF1F5FF), width: 4),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: normalPercent,
                          textDirection: TextDirection.rtl,
                          maxLines: 2,
                          minLines: 1,
                          keyboardType: TextInputType.number,
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
                                horizontal: 15, vertical: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            "درصد تخفیف ویژه",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                            color: const Color(0xffF1F5FF), width: 4),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: specialPercent,
                          textDirection: TextDirection.rtl,
                          maxLines: 2,
                          minLines: 1,
                          keyboardType: TextInputType.number,
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
                                horizontal: 15, vertical: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is SubscriptionLoadingState) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingRing(
                      lineWidth: 1.5,
                      size: 40,
                    ),
                  ],
                ),
              ],
              if (state is SubscriptionUploadState) ...[
                ValueListenableBuilder(
                  valueListenable: state.error,
                  builder: (context, error, child) => !error
                      ? ValueListenableBuilder(
                          valueListenable: state.uploadProgress,
                          builder: (context, progress, child) => Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Column(
                                            children: [
                                              Visibility(
                                                visible: progress,
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "با موفقیت آپلود شد",
                                                      style: TextStyle(
                                                          color: black),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline_rounded,
                                                      color: green,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: !progress,
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: SpinKitThreeBounce(
                                                        color: green,
                                                        duration: Duration(
                                                            milliseconds: 800),
                                                        size: 16,
                                                        // strokeWidth: 2,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "درحال آپلود",
                                                      style: TextStyle(
                                                          color: black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: green,
                                          disabledBackgroundColor:
                                              const Color(0xffF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: progress
                                            ? () {
                                                BlocProvider.of<
                                                            SubscriptionBloc>(
                                                        context)
                                                    .add(
                                                        SingleDiscountCodeDefaultEvent());
                                              }
                                            : null,
                                        child: const Text("بازگشت")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("خطایی رخ داد"),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: green,
                                          disabledBackgroundColor:
                                              const Color(0xffF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: () async {
                                          BlocProvider.of<SubscriptionBloc>(
                                                  context)
                                              .add(
                                            DiscountCodeUploadEvent(
                                              singleSubscriptionDataModel:
                                                  SingleDiscountCodeDataModel(
                                                id: widget.id,
                                                code: code.text,
                                                normalPercent:
                                                    normalPercent.text,
                                                specialPercent:
                                                    specialPercent.text,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text("تلاش دوباره")),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: green,
                                          disabledBackgroundColor:
                                              const Color(0xffF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<SubscriptionBloc>(
                                                  context)
                                              .add(
                                                  SingleDiscountCodeDefaultEvent());
                                        },
                                        child: const Text("بازگشت")),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
              if (state is SingleDiscountCodeDataState) ...[
                state.data.fold(
                    (l) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Refresh(
                              onRefresh: () {
                                if (widget.id != null) {
                                  BlocProvider.of<SubscriptionBloc>(context)
                                      .add(GetSingleSubscriptionEvent(
                                          id: widget.id!));
                                } else {
                                  BlocProvider.of<SubscriptionBloc>(context)
                                      .add(SingleDiscountCodeDefaultEvent());
                                }
                              },
                            ),
                          ],
                        ), (r) {
                  if (!loaded) {
                    code.text = r.code;
                    normalPercent.text = r.normalPercent;
                    specialPercent.text = r.specialPercent;

                    loaded = true;
                  }
                  return content();
                })
              ],
              if (state is SingleDiscountCodeDefaultState) ...[content()],
              if (state is SubscriptionDeleteState) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: state.error,
                      builder: (context, error, child) => !error
                          ? ValueListenableBuilder(
                              valueListenable: state.uploadProgress,
                              builder: (context, progress, child) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  progress
                                      ? const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "دسته بندی با موفقیت حذف شد",
                                              style: TextStyle(color: black),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: Color(0xff18DAA3),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: LoadingRing(
                                                lineWidth: 1.5,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              "درحال حذف دسته بندی",
                                              style: TextStyle(color: black),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: black,
                                        disabledBackgroundColor:
                                            const Color(0xffF5F5F5),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      onPressed: progress == true
                                          ? () {
                                              Navigator.of(context).pop();
                                            }
                                          : null,
                                      child: const Text("بازگشت")),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("خطایی رخ داد"),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: black,
                                          disabledBackgroundColor:
                                              const Color(0xffF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          BlocProvider.of<SubscriptionBloc>(
                                                  this.context)
                                              .add(SubscriptionDeleteEvent(
                                                  id: widget.id ?? ""));
                                        },
                                        child: const Text("تلاش دوباره")),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: black,
                                          disabledBackgroundColor:
                                              const Color(0xffF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<SubscriptionBloc>(
                                                  context)
                                              .add(
                                                  SingleDiscountCodeDefaultEvent());
                                        },
                                        child: const Text("بازگشت")),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
