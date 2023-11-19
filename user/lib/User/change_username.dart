import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:user/Bloc/ProfileBloc/profile_block.dart';
import 'package:user/Bloc/ProfileBloc/profile_event.dart';
import 'package:user/Bloc/ProfileBloc/profile_state.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/MainScreen/main_screen.dart';
import 'package:user/User/user.dart';
import 'package:user/iconsax_icons.dart';

class ChangeUserName extends StatefulWidget {
  ChangeUserName({super.key});

  @override
  State<ChangeUserName> createState() => _ChangeUserNameState();
}

class _ChangeUserNameState extends State<ChangeUserName> {
  final TextEditingController _curentUserName = TextEditingController();
  final TextEditingController _newUserName = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  late Timer countDown;
  Duration duration = const Duration(minutes: 1);

  void setCountDown() {
    int reduceSeconsBy = 1;
    setState(() {
      final curentSeconds = duration.inSeconds - reduceSeconsBy;
      if (curentSeconds < 0) {
        countDown.cancel();
      } else {
        duration = Duration(seconds: curentSeconds);
      }
    });
  }

  @override
  void initState() {
    if (isUserLogin()) {
      _curentUserName.text = userData()!.phone;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return BlocBuilder<Profilebloc, ProfileState>(
      builder: (context, state) => Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Icon(
                              Iconsax.arrow_left,
                              color: blue,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          const Text(
                            "شماره موبایل",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14),
                          ),
                        ],
                      ),
                      if (state is ProfileInitState) ...[
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text("شماره موبایل فعلی",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  border: Border.all(
                                      color: const Color(0xffF1F5FF), width: 4),
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    controller: _curentUserName,
                                    textDirection: TextDirection.ltr,
                                    maxLines: 1,
                                    minLines: 1,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(14)),
                                          borderSide: BorderSide(
                                              color: midBlue, width: 1.4)),
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(14)),
                                          borderSide: BorderSide(
                                              color: lightblue, width: 1)),
                                      hintTextDirection: TextDirection.rtl,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                      labelStyle: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "به خاطر ارسال کد تایید به شماره موبایل جدیدتان، لطفا با دقت آن را وارد نمایید.",
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "شماره موبایل جدیدتان را وارد کنید",
                                      style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                      border: Border.all(
                                          color: const Color(0xffF1F5FF),
                                          width: 4),
                                    ),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextField(
                                        controller: _newUserName,
                                        textDirection: TextDirection.ltr,
                                        maxLines: 1,
                                        minLines: 1,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14)),
                                              borderSide: BorderSide(
                                                  color: midBlue, width: 1.4)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14)),
                                              borderSide: BorderSide(
                                                  color: lightblue, width: 1)),
                                          hintTextDirection: TextDirection.rtl,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 15),
                                          labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _newUserName,
                              builder: (context, value, child) =>
                                  ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(240, 44),
                                  elevation: 0,
                                  shadowColor: Colors.white,
                                  backgroundColor: blue,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: midPurple,
                                  disabledForegroundColor: lightgray,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                ),
                                onPressed: state.onWating || value.text.isEmpty
                                    ? null
                                    : () {
                                        BlocProvider.of<Profilebloc>(context)
                                            .add(
                                                GetChangeUserNameValidCodeEvent(
                                          newUserName: _newUserName.text,
                                          setTimer: () {
                                            countDown = Timer.periodic(
                                              const Duration(seconds: 1),
                                              (_) => setCountDown(),
                                            );
                                          },
                                        ));
                                      },
                                child: state.onWating
                                    ? LoadingRing(
                                        lineWidth: 1.5,
                                        size: 20,
                                      )
                                    : const Text(
                                        "ادامه",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (state is ProfileValidCodeState) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text(".لطفا کد ارسال شده را وارد کنید"),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Pinput(
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                submittedPinTheme: submittedPinTheme,
                                enabled: duration.inSeconds != 0,
                                androidSmsAutofillMethod:
                                    AndroidSmsAutofillMethod.smsUserConsentApi,
                                // validator: (s) {
                                //   return state.error
                                //       ? 'رمز ارسال شده نادرست است'
                                //       : null;
                                // },
                                pinputAutovalidateMode:
                                    PinputAutovalidateMode.onSubmit,
                                showCursor: true,
                                onCompleted: state.onWating
                                    ? null
                                    : (pin) {
                                        BlocProvider.of<Profilebloc>(context)
                                            .add(
                                          ChangeUserNameEvent(
                                            newUserName: _newUserName.text,
                                            validCode: pin,
                                            saveData: () {
                                              BlocProvider.of<MainScreenBloc>(
                                                      mainScreenContext.get())
                                                  .add(
                                                      MainScreenDefaultEvent());
                                              Get.back();
                                            },
                                          ),
                                        );
                                      },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: duration.inSeconds != 0,
                                    child: Text(
                                        "(${(duration.inSeconds / 60).floor()}:${(duration.inSeconds % 60).floor() < 10 ? 00 : ''}${(duration.inSeconds % 60).floor()})"),
                                  ),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: almond,
                                        disabledForegroundColor: lightgray,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16))),
                                      ),
                                      onPressed: duration.inSeconds != 0
                                          ? null
                                          : () {
                                              BlocProvider.of<Profilebloc>(
                                                      context)
                                                  .add(GetValidCodeEvent(
                                                setTimer: () {
                                                  countDown = Timer.periodic(
                                                    const Duration(seconds: 1),
                                                    (_) => setCountDown(),
                                                  );
                                                },
                                              ));
                                            },
                                      child: Text(duration.inSeconds != 0
                                          ? "ارسال مجدد کد پس از"
                                          : "ارسال مجدد کد")),
                                  Visibility(
                                    visible: duration.inSeconds == 0,
                                    child: const Text("کد رو دریافت نکردی؟"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
