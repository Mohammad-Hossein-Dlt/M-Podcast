import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:user/Bloc/LoginBloc/login_block.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/Login/login.dart';

class NoLogin extends StatelessWidget {
  final String? title;
  final Color? titleColor;
  final Function()? reload;

  NoLogin({
    super.key,
    this.title,
    this.titleColor,
    this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title ?? ".برای ادامه، واردحساب کاربری شوید",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                elevation: 0,
                minimumSize: const Size(320, 50),
                maximumSize: const Size(320, 50),
                shadowColor: Colors.white,
                backgroundColor: blue,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                side: const BorderSide(color: blue),
              ),
              onPressed: () async {
                Get.to(
                  BlocProvider(
                    create: (context) => LoginBloc(),
                    child: Login(
                      reload: reload,
                    ),
                  ),
                );
              },
              child: const Text(
                // "دریافت نسخه جدید",
                "ورود / ثبت نام",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}

class NoLogin2 extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color? titleColor;
  final Function()? reload;

  NoLogin2({
    super.key,
    required this.title,
    required this.subTitle,
    this.titleColor,
    this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          // height: 200,
          child: Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Transform.scale(
                scaleX: -1,
                child: Image.asset("assets/images/coffee2.png"),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subTitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
            onPressed: () {
              Get.to(
                BlocProvider(
                  create: (context) => LoginBloc(),
                  child: Login(
                    reload: reload,
                  ),
                ),
              );
            },
            child: const Text(
              "ورود / ثبت نام",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),

        //         OutlinedButton(
        // style: OutlinedButton.styleFrom(
        //   elevation: 0,
        //   minimumSize: const Size(320, 50),
        //   maximumSize: const Size(320, 50),
        //   shadowColor: Colors.white,
        //   backgroundColor: blue,
        //   foregroundColor: Colors.white,
        //   shape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(14))),
        //   side: const BorderSide(color: blue),
        // ),
        // onPressed: () async {
        //   Get.to(
        //     BlocProvider(
        //       create: (context) => LoginBloc(),
        //       child: Login(
        //         reload: reload,
        //       ),
        //     ),
        //   );
        // },
        // child: const Text(
        //   // "دریافت نسخه جدید",
        //   "ورود / ثبت نام",
        //   style:
        //       TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        // )),
        const SizedBox(),
      ],
    );
  }
}
