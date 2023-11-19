import 'package:flutter/material.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/refresh.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({
    super.key,
    required this.isRefresh,
    required this.onRefresh,
  });
  final bool isRefresh;
  final Function() onRefresh;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  IconWidget icon = const IconWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF7F7F7),
      backgroundColor: const Color(0xffFFF1D7),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 120),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
            ],
          ),
          const SizedBox(height: 20),
          // Column(
          //   children: const [
          //     Text(
          //       "ما عاقبت به خیر تو در روضه ها شدیم",
          //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          //     ),
          //     Text(
          //       "با گریه بر تو بود عزیز خدا شدیم",
          //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 200),
          if (widget.isRefresh)
            Refresh(onRefresh: widget.onRefresh)
          else
            Column(
              children: [
                const Text(
                  "...درحال دریافت اطلاعات",
                ),
                const SizedBox(height: 10),
                LoadingRing(),
              ],
            ),
        ],
      )),
    );
  }
}

class IconWidget extends StatefulWidget {
  const IconWidget({super.key});

  @override
  State<IconWidget> createState() => _IconWidgetState();
}

class _IconWidgetState extends State<IconWidget>
    with AutomaticKeepAliveClientMixin {
  Image icon = Image.asset(
    "assets/images/ic_transparent.jpg",
    height: 200,
  );
  @override
  void didChangeDependencies() {
    precacheImage(icon.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return icon;
  }

  @override
  bool get wantKeepAlive => true;
}
