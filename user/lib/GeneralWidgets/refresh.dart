import 'package:user/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Refresh extends StatelessWidget {
  Refresh({super.key, required this.onRefresh});
  final Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            // color: black,
          ),
          child: SvgPicture.asset(
            "assets/images/no-wifi.svg",
            color: black,
            width: 40,
          ),
        ),
        // const SizedBox(height: 10),
        // const Text("!به اینترنت وصل نیستی"),
        TextButton(
            style: TextButton.styleFrom(
              // backgroundColor: black,
              foregroundColor: black,
              elevation: 0,
              // disabledBackgroundColor: const Color(0xffF5F5F5),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: onRefresh,
            child: const Text(
              "تلاش دوباره",
              style: TextStyle(
                color: black,
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }
}
