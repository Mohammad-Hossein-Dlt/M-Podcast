import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:user/Bloc/InfoBlock/info_block.dart';
import 'package:user/Bloc/LoginBloc/login_block.dart';
import 'package:user/Bloc/LoginBloc/login_event.dart';
import 'package:user/Bloc/LoginBloc/login_state.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/InfoScreen/info_screen.dart';
import 'package:user/MainScreen/main_screen.dart';
import 'package:user/iconsax_icons.dart';

class Login extends StatefulWidget {
  Login({
    super.key,
    this.reload,
  });
  final Function()? reload;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = true;
  bool isSinIn = true;
  bool isSinUp = false;
  bool sinInWithPassword = false;

  final TextEditingController _nameAndFamily = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late Timer countDown;
  Duration duration = const Duration(minutes: 1);

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

  void setCountDown() {
    int reduceSeconsBy = 1;
    setState(() {
      final curentSeconds = duration.inSeconds - reduceSeconsBy;
      if (curentSeconds <= 0) {
        countDown.cancel();
      } else {
        duration = Duration(seconds: curentSeconds);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       statusBarColor: Colors.white,
  //       statusBarIconBrightness: Brightness.dark,
  //       statusBarBrightness: Brightness.dark,
  //     ),
  //   );
  //   super.dispose();
  // }

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
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) => Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/ic_launcher.png",
                                  height: 40,
                                  // cacheHeight: 50 ,
                                ),
                                Positioned(
                                  left: 0,
                                  child: TextButton(
                                    child: const Icon(
                                      Iconsax.arrow_left,
                                      color: blue,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (state is EnterLoginDataState) ...[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Text(
                                              isSinIn
                                                  ? "برای ورود شماره تلفن خود را وارد کنید"
                                                  : "برای ثبت نام شماره تلفن خود را وارد کنید",
                                              style: const TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
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
                                            controller: _phone,
                                            textDirection: TextDirection.ltr,
                                            maxLines: 1,
                                            minLines: 1,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(14)),
                                                  borderSide: BorderSide(
                                                      color: midBlue,
                                                      width: 1.4)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(14)),
                                                  borderSide: BorderSide(
                                                      color: lightblue,
                                                      width: 1)),
                                              hintTextDirection:
                                                  TextDirection.rtl,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ValueListenableBuilder(
                                  valueListenable: _phone,
                                  builder: (context, value, child) =>
                                      ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(240, 44),
                                      elevation: 0,
                                      shadowColor: white,
                                      backgroundColor: blue,
                                      foregroundColor: white,
                                      disabledBackgroundColor: midPurple,
                                      disabledForegroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                    ),
                                    onPressed: state.onWating ||
                                            value.text.isEmpty
                                        ? null
                                        : () {
                                            if (isSinIn) {
                                              BlocProvider.of<LoginBloc>(
                                                      context)
                                                  .add(
                                                SinInValidCodeEvent(
                                                  userName: _phone.text,
                                                  function: () {
                                                    countDown = Timer.periodic(
                                                      const Duration(
                                                          seconds: 1),
                                                      (_) => setCountDown(),
                                                    );
                                                  },
                                                ),
                                              );
                                            } else {
                                              BlocProvider.of<LoginBloc>(
                                                      context)
                                                  .add(
                                                SinUpValidCodeEvent(
                                                  userName: _phone.text,
                                                  function: () {
                                                    if (countDown.isActive) {
                                                      countDown.cancel();
                                                    }
                                                    countDown = Timer.periodic(
                                                      const Duration(
                                                          seconds: 1),
                                                      (_) => setCountDown(),
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                          },
                                    child: state.onWating
                                        ? LoadingRing(
                                            lineWidth: 1.5,
                                            size: 20,
                                          )
                                        // ignore: prefer_const_constructors
                                        : Text(
                                            "دریافت کد فعال سازی",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: blue,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isSinIn = !isSinIn;
                                        });
                                      },
                                      child: Text(
                                        isSinIn ? "ثبت نام" : "ورود",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Text(isSinIn
                                        ? "حساب کاربری نداری؟"
                                        : "حساب کاربری داری؟"),
                                  ],
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: blue,
                                  ),
                                  onPressed: () {
                                    Get.to(
                                      BlocProvider(
                                        create: (context) => InfoBloc(),
                                        child: InfoScreen(
                                            info: Info.termsAndConditions),
                                      ),
                                    );
                                  },
                                  child: const Text(" قوانین و شرایط استفاده "),
                                ),
                              ],
                            ),
                          ],
                          if (state is ValidCodeState) ...[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (sinInWithPassword) ...[
                                  const SizedBox(height: 20),
                                  Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Text(
                                              "رمز عبور",
                                              style: TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(16)),
                                            border: Border.all(
                                                color: const Color(0xffF1F5FF),
                                                width: 4),
                                          ),
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: TextField(
                                              controller: _password,
                                              textDirection: TextDirection.ltr,
                                              maxLines: 1,
                                              minLines: 1,
                                              obscureText: _showPassword,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14)),
                                                        borderSide: BorderSide(
                                                            color: midBlue,
                                                            width: 1.4)),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14)),
                                                        borderSide: BorderSide(
                                                            color: lightblue,
                                                            width: 1)),
                                                hintTextDirection:
                                                    TextDirection.rtl,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 15),
                                                labelStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _showPassword =
                                                            !_showPassword;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      _showPassword
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                      color: const Color(
                                                          0xff848DA2),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  if (!isSinUp) ...[
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 40),
                                      child: Column(
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "لطفا کد ارسال شده را وارد کنید",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Pinput(
                                            defaultPinTheme: defaultPinTheme,
                                            focusedPinTheme: focusedPinTheme,
                                            submittedPinTheme:
                                                submittedPinTheme,
                                            enabled: duration.inSeconds != 0,
                                            androidSmsAutofillMethod:
                                                AndroidSmsAutofillMethod
                                                    .smsUserConsentApi,
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
                                                    if (isSinIn) {
                                                      BlocProvider.of<
                                                                  LoginBloc>(
                                                              context)
                                                          .add(
                                                        SinInEvent(
                                                          userName: _phone.text,
                                                          validCode: pin,
                                                          saveData: () {
                                                            BlocProvider.of<
                                                                        MainScreenBloc>(
                                                                    mainScreenContext
                                                                        .get())
                                                                .add(
                                                                    MainScreenDefaultEvent());
                                                            if (widget.reload !=
                                                                null) {
                                                              widget.reload!();
                                                            }
                                                            Get.back();
                                                          },
                                                        ),
                                                      );
                                                    } else {
                                                      if (pin ==
                                                          state.validCode) {
                                                        setState(() {
                                                          isSinUp = true;
                                                        });
                                                      }
                                                    }
                                                  },
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible:
                                                    duration.inSeconds != 0,
                                                child: Text(
                                                  "(${(duration.inSeconds / 60).floor()}:${(duration.inSeconds % 60).floor() < 10 ? 00 : ''}${(duration.inSeconds % 60).floor()})",
                                                  style: const TextStyle(
                                                    color: blue,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: almond,
                                                    disabledForegroundColor:
                                                        lightgray,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    16))),
                                                  ),
                                                  onPressed: duration
                                                              .inSeconds !=
                                                          0
                                                      ? null
                                                      : () {
                                                          duration =
                                                              const Duration(
                                                                  minutes: 1);
                                                          BlocProvider.of<
                                                                      LoginBloc>(
                                                                  context)
                                                              .add(
                                                            SinInValidCodeEvent(
                                                              userName:
                                                                  _phone.text,
                                                              function: () {
                                                                countDown = Timer
                                                                    .periodic(
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  (_) =>
                                                                      setCountDown(),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                  child: duration.inSeconds != 0
                                                      ? const Text(
                                                          "ارسال مجدد کد پس از",
                                                        )
                                                      : const Text(
                                                          "ارسال مجدد کد",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff3052AC)),
                                                        )),
                                              Visibility(
                                                visible:
                                                    duration.inSeconds == 0,
                                                child: const Text(
                                                    "کد رو دریافت نکردی؟"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                                if (isSinIn) ...[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xff848DA2),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        sinInWithPassword = !sinInWithPassword;
                                      });
                                    },
                                    child: Text(
                                      sinInWithPassword
                                          ? "ورود با کد ارسال شده"
                                          : "ورود با رمز عبور",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: blue),
                                    ),
                                  ),
                                  if (sinInWithPassword) ...[
                                    ValueListenableBuilder(
                                      valueListenable: _password,
                                      builder: (context, value, child) =>
                                          ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(240, 44),
                                          elevation: 0,
                                          shadowColor: white,
                                          backgroundColor: blue,
                                          foregroundColor: white,
                                          disabledBackgroundColor: midPurple,
                                          disabledForegroundColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16))),
                                        ),
                                        onPressed: value.text.isEmpty ||
                                                state.onWating
                                            ? null
                                            : () {
                                                BlocProvider.of<LoginBloc>(
                                                        context)
                                                    .add(
                                                  SinInEvent(
                                                    userName: _phone.text,
                                                    validCode: _password.text,
                                                    saveData: () {
                                                      BlocProvider.of<
                                                                  MainScreenBloc>(
                                                              mainScreenContext
                                                                  .get())
                                                          .add(
                                                              MainScreenDefaultEvent());
                                                      if (widget.reload !=
                                                          null) {
                                                        widget.reload!();
                                                      }
                                                      Get.back();
                                                    },
                                                  ),
                                                );
                                              },
                                        child: state.onWating
                                            ? LoadingRing(
                                                lineWidth: 1.5,
                                                size: 20,
                                              )
                                            : const Text(
                                                "تایید",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                    ),
                                  ],
                                ],
                                if (isSinUp) ...[
                                  const SizedBox(height: 20),
                                  Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Text(
                                              "نام و نام خانوادگی",
                                              style: TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(16)),
                                            border: Border.all(
                                                color: const Color(0xffF1F5FF),
                                                width: 4),
                                          ),
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: TextField(
                                              controller: _nameAndFamily,
                                              textDirection: TextDirection.rtl,
                                              maxLines: 1,
                                              minLines: 1,
                                              decoration: const InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14)),
                                                        borderSide: BorderSide(
                                                            color: midBlue,
                                                            width: 1.4)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14)),
                                                        borderSide: BorderSide(
                                                            color: lightblue,
                                                            width: 1)),
                                                hintTextDirection:
                                                    TextDirection.rtl,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 15),
                                                labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Text(
                                              "رمز عبور",
                                              style: TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(16)),
                                            border: Border.all(
                                                color: const Color(0xffF1F5FF),
                                                width: 4),
                                          ),
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: TextField(
                                              controller: _password,
                                              textDirection: TextDirection.ltr,
                                              maxLines: 1,
                                              minLines: 1,
                                              obscureText: _showPassword,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14)),
                                                        borderSide: BorderSide(
                                                            color: midBlue,
                                                            width: 1.4)),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14)),
                                                        borderSide: BorderSide(
                                                            color: lightblue,
                                                            width: 1)),
                                                hintTextDirection:
                                                    TextDirection.rtl,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 15),
                                                labelStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _showPassword =
                                                            !_showPassword;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      _showPassword
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                      color: const Color(
                                                          0xff848DA2),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(240, 44),
                                      elevation: 0,
                                      shadowColor: white,
                                      backgroundColor: blue,
                                      foregroundColor: white,
                                      disabledBackgroundColor: midPurple,
                                      disabledForegroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                    ),
                                    onPressed: state.onWating
                                        ? null
                                        : () {
                                            BlocProvider.of<LoginBloc>(context)
                                                .add(
                                              SinUpEvent(
                                                nameAndFamily:
                                                    _nameAndFamily.text,
                                                userName: _phone.text,
                                                password: _password.text,
                                                saveData: () {
                                                  BlocProvider.of<
                                                              MainScreenBloc>(
                                                          mainScreenContext
                                                              .get())
                                                      .add(
                                                          MainScreenDefaultEvent());
                                                  if (widget.reload != null) {
                                                    widget.reload!();
                                                  }
                                                  Get.back();
                                                },
                                              ),
                                            );
                                          },
                                    child: state.onWating
                                        ? LoadingRing(
                                            lineWidth: 1.5,
                                            size: 20,
                                          )
                                        : const Text(
                                            "تایید",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ]
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
