import 'dart:async';
import 'package:admin/Bloc/DocumentBloc/document_block.dart';
import 'package:admin/Constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:admin/DocumentOnline/document_online.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../iconsax_icons.dart';

class PersianNumber extends StatelessWidget {
  const PersianNumber(
      {super.key, required this.number, this.style = const TextStyle()});

  final String number;
  final TextStyle style;

  String persianNumber(String enNumber) {
    String date = enNumber;
    Map numbers = {
      "0": "۰",
      "1": "۱",
      "2": "۲",
      "3": "۳",
      "4": "۴",
      "5": "۵",
      "6": "۶",
      "7": "۷",
      "8": "۸",
      "9": "۹",
    };

    for (String i in numbers.keys) {
      date = date.replaceAll(RegExp(i), numbers[i]);
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      persianNumber(number),
      style: style,
    );
  }
}

class DateElement extends StatelessWidget {
  const DateElement({
    super.key,
    required this.date,
    this.strStyle = const TextStyle(color: gray, fontSize: 10),
    this.numberStyle = const TextStyle(color: gray, fontSize: 10),
  });

  final Map date;

  final TextStyle strStyle;
  final TextStyle numberStyle;

  Widget dateConverter(Map dateTime) {
    Widget elapsedTime = Row(
      children: [
        Text(
          " دقیقه قبل",
          style: strStyle,
        ),
        const SizedBox(width: 2),
        PersianNumber(
          number: "1",
          style: numberStyle,
        ),
      ],
    );
    if (int.parse(dateTime["year"]) != 0 ||
        int.parse(dateTime["month"]) != 0 ||
        int.parse(dateTime["day"]) != 0) {
      elapsedTime = Text(
        dateTime["date"],
        style: strStyle,
      );
    } else if (int.parse(dateTime["hour"]) != 0) {
      elapsedTime = Row(
        children: [
          Text(
            "ساعت پیش",
            style: strStyle,
          ),
          const SizedBox(width: 2),
          PersianNumber(
            number: dateTime["hour"],
            style: numberStyle,
          ),
        ],
      );
    } else if (int.parse(dateTime["minute"]) != 0) {
      elapsedTime = Row(
        children: [
          Text(
            " دقیقه پیش",
            style: strStyle,
          ),
          const SizedBox(width: 2),
          PersianNumber(
            number: dateTime["minute"],
            style: numberStyle,
          ),
        ],
      );
    }
    return elapsedTime;
  }

  @override
  Widget build(BuildContext context) {
    return dateConverter(date);
  }
}

class FullDetailsItem extends StatefulWidget {
  const FullDetailsItem({
    super.key,
    required this.document,
    required this.showInWrap,
    this.thenFunction,
  });
  final Map document;
  final bool showInWrap;
  final Function? thenFunction;
  @override
  State<FullDetailsItem> createState() => _FullDetailsItemState();
}

class _FullDetailsItemState extends State<FullDetailsItem> {
  double imgWidth = 270;
  double imgHeight = 160;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showInWrap) {
      imgWidth = MediaQuery.of(context).size.width / 2 - 10;
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // border: Border.all(color: Color(0xFFE6EFFC), width: 2),
      ),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => DocumentOnlineBloc(),
                child: DocumentOnline(
                  id: widget.document["id"],
                ),
              ),
            ),
          );
        },
        child: Container(
          width: imgWidth,
          height: imgHeight + 78,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Material(
                    elevation: 4,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    shadowColor: white,
                    child: Container(
                      width: imgWidth,
                      height: imgHeight,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: ImageItem.Item(
                            documentName: widget.document["name"],
                            imageName: widget.document["mainimage"],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        color: const Color(0xffFF033E).withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          widget.document["isSubscription"]
                              ? "اشتراکی"
                              : "رایگان",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: imgWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                ),
                                color:
                                    const Color(0xff66728C).withOpacity(0.45),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Expanded(
                                      child: Text(
                                        widget.document["group"],
                                        maxLines: 1,
                                        // textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            // color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.document["haveAudio"],
                    child: Positioned(
                      bottom: 25,
                      left: 8,
                      child: Material(
                        elevation: 4,
                        shape: const CircleBorder(),
                        color: const Color(0xffFF033E).withOpacity(0.5),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Iconsax.headphone5,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Expanded(
                                child: Text(
                                  widget.document["name"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Iconsax.heart,
                                color: black,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              PersianNumber(
                                number: widget.document['likes'],
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: lightgray,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          DateElement(date: widget.document["creationDate"]),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalFullDetailsItem extends StatefulWidget {
  const HorizontalFullDetailsItem({
    super.key,
    required this.document,
    required this.remove,
  });
  final Map document;
  final Function(int id)? remove;
  @override
  State<HorizontalFullDetailsItem> createState() =>
      _HorizontalFullDetailsItemState();
}

class _HorizontalFullDetailsItemState extends State<HorizontalFullDetailsItem> {
  double imgWidth = 116;

  double imgHeight = 116;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: imgHeight + 10,
      // padding: const EdgeInsets.all(5),
      // margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: Colors.white,
      ),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => DocumentOnlineBloc(),
                child: DocumentOnline(
                  id: widget.document["id"],
                ),
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 14,
                          right: 8,
                          left: 4,
                          bottom: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: widget.remove != null,
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              widget.remove!(int.parse(
                                                  widget.document['id']));
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4, vertical: 8),
                                              child: Icon(
                                                Icons.more_vert_rounded,
                                                color: gray,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                widget.document['name'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),

                                          color: midRed.withOpacity(0.4),
                                          // color: green,
                                        ),
                                        child: Text(
                                          widget.document["subgroup"],
                                          style: TextStyle(
                                              color: red.withOpacity(0.5),
                                              // color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          // color: green,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),

                                          color: midRed.withOpacity(0.4),
                                          // color: green,
                                        ),
                                        child: Text(widget.document["group"],
                                            style: TextStyle(
                                              color: red.withOpacity(0.5),
                                              // color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Iconsax.heart,
                                        color: black,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      PersianNumber(
                                        number: widget.document['likes'],
                                        style: const TextStyle(
                                            fontSize: 12, color: black),
                                      ),
                                    ],
                                  ),
                                  DateElement(
                                    date: widget.document["creationDate"],
                                    strStyle: const TextStyle(
                                        color: black, fontSize: 10),
                                    numberStyle: const TextStyle(
                                        color: black, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  width: imgWidth,
                  height: imgHeight,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: ImageItem.Item(
                        documentName: widget.document['name'],
                        imageName: widget.document['mainimage'],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FullDetailsItemWithSearchedText extends StatefulWidget {
  const FullDetailsItemWithSearchedText({
    super.key,
    required this.document,
    required this.searched,
  });
  final Map document;
  final String searched;
  String text() => document["text"];
  @override
  State<FullDetailsItemWithSearchedText> createState() =>
      _FullDetailsItemWithSearchedTextState();
}

class _FullDetailsItemWithSearchedTextState
    extends State<FullDetailsItemWithSearchedText> {
  double imgWidth = 96;

  double imgHeight = 96;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => DocumentOnlineBloc(),
                child: DocumentOnline(
                  id: widget.document["id"],
                ),
              ),
            ),
          );
        },
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: imgHeight + 14,
                padding: const EdgeInsets.all(5),
                // margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  // color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    widget.document['name'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),

                                      color: midRed.withOpacity(0.4),
                                      // color: green,
                                    ),
                                    child: Text(
                                      widget.document["subgroup"],
                                      style: TextStyle(
                                          color: red.withOpacity(0.5),
                                          // color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 8),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      // color: green,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),

                                      color: midRed.withOpacity(0.4),
                                      // color: green,
                                    ),
                                    child: Text(widget.document["group"],
                                        style: TextStyle(
                                          color: red.withOpacity(0.5),
                                          // color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.heart,
                                    color: black,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  PersianNumber(
                                    number: widget.document['likes'],
                                    style:
                                        TextStyle(fontSize: 12, color: black),
                                  ),
                                ],
                              ),
                              // SizedBox(width: 50),
                              DateElement(
                                date: widget.document["creationDate"],
                                strStyle: TextStyle(color: black, fontSize: 10),
                                numberStyle:
                                    TextStyle(color: black, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: imgWidth,
                      height: imgHeight,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: ImageItem.Item(
                            documentName: widget.document['name'],
                            imageName: widget.document['mainimage'],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                  color: Colors.white,
                ),
                child: Text.rich(
                  TextSpan(
                    text: widget.text().substring(
                          0,
                          widget.text().indexOf(widget.searched),
                        ),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                        text: widget.searched,
                        style: const TextStyle(
                          backgroundColor: Color(0xff66728C),
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: widget.text().substring(
                              widget.text().indexOf(widget.searched) +
                                  widget.searched.length,
                              widget.text().length,
                            ),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  textDirection: TextDirection.rtl,
                ),

                //  Text(
                //   widget.document["text"],
                //   textDirection: TextDirection.rtl,
                // ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageItem extends StatefulWidget {
  ImageItem({
    super.key,
    required this.address,
    this.height = 100,
    this.width = 100,
  });
  final String address;
  final double width;
  final double height;

  factory ImageItem.Banner({
    required String imageName,
    required double height,
    required double width,
  }) {
    return ImageItem(
      address: "https://mhdlt.ir/Banners/$imageName",
      height: height,
      width: width,
    );
  }

  factory ImageItem.Item({
    required String documentName,
    required String imageName,
  }) {
    return ImageItem(
      address: "https://mhdlt.ir/DocumentsData/$documentName/$imageName",
    );
  }
  factory ImageItem.Category({
    required String imageName,
  }) {
    return ImageItem(
      address: "https://mhdlt.ir/CategoriesImage/$imageName",
    );
  }
  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CachedNetworkImage(
      imageUrl: widget.address,
      errorWidget: (context, url, error) =>
          // Image.asset("assets/images/place_holder.png"),
          Container(
        width: 100,
        height: 100,
        color: const Color(0xffF0F0EE),
      ),
      placeholder: (context, url) =>
          // Image.asset("assets/images/place_holder.png"),
          Container(
        color: const Color(0xffF0F0EE),
      ),
      fadeInCurve: Curves.linear,
      fadeOutCurve: Curves.linear,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BannerItem extends StatefulWidget {
  BannerItem({
    super.key,
    required this.bannerData,
    required this.isSetRadios,
    required this.isSetPadding,
  });
  final Map bannerData;
  final bool isSetRadios;
  final bool isSetPadding;

  @override
  State<BannerItem> createState() => _BannerItemState();
}

class _BannerItemState extends State<BannerItem>
    with AutomaticKeepAliveClientMixin {
  String name = "";
  String documentName_ = "";
  String documentId_ = "";
  @override
  void initState() {
    name = widget.bannerData['name'];
    documentName_ = widget.bannerData["documentName"];
    documentId_ = widget.bannerData["documentId"] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 200,
      child: InkWell(
        onTap: documentId_.isNotEmpty
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => DocumentOnlineBloc(),
                      child: DocumentOnline(
                        id: documentId_,
                      ),
                    ),
                  ),
                );
              }
            : null,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isSetPadding ? 10 : 0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.isSetRadios ? 10 : 0),
            ),
            child: FittedBox(
              fit: BoxFit.cover,
              child: ImageItem.Banner(
                imageName: name,
                height: 200,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class BannerList extends StatefulWidget {
  BannerList({super.key, required this.banners});
  final List banners;
  @override
  State<BannerList> createState() => _BannerListState();
}

class _BannerListState extends State<BannerList> {
  PageController controller = PageController(viewportFraction: 1);
  int curentPage = 0;
  bool end = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (curentPage == widget.banners.length - 1) {
        end = true;
      } else if (curentPage == 0) {
        end = false;
      }

      if (end == false) {
        curentPage++;
      } else {
        curentPage = 0;
      }

      controller.animateToPage(curentPage,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ClipRRect(
        // borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Stack(
          children: [
            Container(
              height: 200,
              child: PageView(
                controller: controller,
                reverse: true,
                children: widget.banners
                    .map((e) => BannerItem(
                          bannerData: e,
                          isSetRadios: true,
                          isSetPadding: true,
                        ))
                    .toList(),
                onPageChanged: (value) {
                  curentPage = value;
                },
              ),
            ),
            // const SizedBox(height: 2),
            Positioned(
              bottom: 20,
              left: 20,
              child: SmoothPageIndicator(
                controller: controller,
                count: widget.banners.length,
                textDirection: TextDirection.rtl,
                effect: const ExpandingDotsEffect(
                  dotHeight: 4,
                  dotWidth: 4,

                  // activeDotColor: green,
                  // dotColor: Color.fromARGB(255, 197, 235, 186),
                  dotColor: Colors.white,
                  activeDotColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
