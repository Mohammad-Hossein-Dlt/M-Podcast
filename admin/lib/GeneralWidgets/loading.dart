import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

// class LoadingThreeBounce extends StatelessWidget {
//   double? size = 24;
//   Color? color = black;
//   LoadingThreeBounce({super.key, required this.size, this.color}) {
//     color = color ?? black;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: SpinKitThreeBounce(
//         color: color,
//         duration: const Duration(milliseconds: 900),
//         size: size!,
//         // strokeWidth: 2,
//       ),
//     );
//   }
// }

// class LoadingRing extends StatelessWidget {
//   LoadingRing(
//       {super.key,
//       this.color = Colors.black,
//       this.lineWidth = 1.4,
//       this.size = 20});
//   Color color = black;
//   double lineWidth = 1.4;
//   double size = 20;

//   @override
//   Widget build(BuildContext context) {
//     return SpinKitRing(
//       color: color,
//       duration: const Duration(milliseconds: 900),
//       size: size,
//       lineWidth: lineWidth,
//     );
//   }
// }

class LoadingRing extends StatelessWidget {
  LoadingRing({
    super.key,
    this.color = Colors.black,
    this.lineWidth = 1.4,
    this.size = 20,
  });
  final Color color;
  final double lineWidth;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: LoadingIndicator(
        indicatorType: Indicator.circleStrokeSpin,
        colors: [
          color,
        ],
        backgroundColor: Colors.transparent,
        pathBackgroundColor: Colors.white,
        strokeWidth: lineWidth,
      ),
    );
  }
}
