import 'package:admin/Constants/colors.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:flutter/material.dart';

class UploadProgress extends StatefulWidget {
  UploadProgress(
      {super.key,
      required this.uploadSuccessTitle,
      required this.title1,
      required this.title2,
      required this.title3,
      required this.error,
      required this.uploadProgress,
      required this.back,
      required this.tryAgain});
  final String uploadSuccessTitle;
  final String title1;
  final String title2;
  final String title3;
  final ValueNotifier error;
  final ValueNotifier uploadProgress;
  final Function() back;
  final Function() tryAgain;
  @override
  State<UploadProgress> createState() => _UploadProgressState();
}

class _UploadProgressState extends State<UploadProgress> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: widget.error,
            builder: (context, value, child) => !value
                ? ValueListenableBuilder(
                    valueListenable: widget.uploadProgress,
                    builder: (context, value, child) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: !value.contains(false),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          widget.uploadSuccessTitle,
                                          style: TextStyle(color: black),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: Color(0xff18DAA3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: value.contains(false),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: LoadingRing(
                                            lineWidth: 1.5,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "درحال آپلود",
                                          style: TextStyle(color: black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.title1,
                                        style: TextStyle(
                                            color:
                                                value[0] ? black : lightgray),
                                      ),
                                      const SizedBox(width: 4),
                                      Visibility(
                                          visible: value[0],
                                          child: const Icon(
                                            Icons.check_circle_outline_rounded,
                                            color: Color(0xff18DAA3),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.title2,
                                        style: TextStyle(
                                            color:
                                                value[1] ? black : lightgray),
                                      ),
                                      const SizedBox(width: 4),
                                      Visibility(
                                          visible: value[1],
                                          child: const Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: Color(0xff18DAA3))),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.title3,
                                        style: TextStyle(
                                            color:
                                                value[2] ? black : lightgray),
                                      ),
                                      const SizedBox(width: 4),
                                      Visibility(
                                          visible: value[2],
                                          child: const Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: Color(0xff18DAA3))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: green,
                              disabledBackgroundColor: const Color(0xffF5F5F5),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onPressed:
                                !value.contains(false) ? widget.back : null,
                            child: const Text("بازگشت")),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("خطایی رخ داد"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                disabledBackgroundColor:
                                    const Color(0xffF5F5F5),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onPressed: widget.tryAgain,
                              child: const Text("تلاش دوباره")),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                disabledBackgroundColor:
                                    const Color(0xffF5F5F5),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onPressed: widget.back,
                              child: const Text("بازگشت")),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class UploadError extends StatelessWidget {
  UploadError(
      {super.key,
      required this.error,
      required this.back,
      required this.tryAgain});
  final String error;
  final Function() back;
  final Function() tryAgain;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  disabledBackgroundColor: const Color(0xffF5F5F5),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onPressed: tryAgain,
                child: const Text("تلاش دوباره")),
            const SizedBox(width: 10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  disabledBackgroundColor: const Color(0xffF5F5F5),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onPressed: back,
                child: const Text("بازگشت")),
          ],
        ),
      ],
    );
  }
}

class ExistName extends StatelessWidget {
  ExistName(
      {super.key,
      required this.validNameTrue,
      required this.validNameFalse,
      required this.exist,
      required this.upload,
      required this.back});
  final String validNameTrue;
  final String validNameFalse;
  final bool exist;
  final Function() upload;
  final Function() back;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              exist ? validNameTrue : validNameFalse,
              style: TextStyle(color: black),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.check_sharp),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  disabledBackgroundColor: const Color(0xffF5F5F5),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onPressed: upload,
                child: Text(exist ? "آپلود" : "جایگذینی")),
            const SizedBox(width: 10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  disabledBackgroundColor: const Color(0xffF5F5F5),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onPressed: back,
                child: const Text("بازگشت")),
          ],
        ),
      ],
    );
  }
}
