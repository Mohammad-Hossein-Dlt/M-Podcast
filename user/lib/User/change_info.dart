import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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

class ChangeInfo extends StatefulWidget {
  ChangeInfo({super.key});

  @override
  State<ChangeInfo> createState() => _ChangeInfoState();
}

class _ChangeInfoState extends State<ChangeInfo> {
  bool isSinIn = true;

  final TextEditingController _nameAndFamily = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();

  ValueNotifier<bool> validData = ValueNotifier<bool>(false);
  @override
  void initState() {
    if (isUserLogin()) {
      _nameAndFamily.text = userData()!.nameAndFamily;
      _phone.text = userData()!.phone;
      _email.text = userData()!.email;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Profilebloc, ProfileState>(
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: const Icon(
                                  Iconsax.arrow_left,
                                  color: blue,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              const Text(
                                "اطلاعات حساب کاربری",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("شماره موبایل",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
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
                                          enabled: false,
                                          decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                                borderSide: BorderSide(
                                                    color: midBlue,
                                                    width: 1.4)),
                                            disabledBorder: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
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
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "برای تغییر شماره موبایل به پروفایل > تغییر شماره موبایل بروید.",
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("نام و نام خانوادگی",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                                          controller: _nameAndFamily,
                                          // textDirection: TextDirection.ltr,
                                          maxLines: 1,
                                          minLines: 1,
                                          decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                                borderSide: BorderSide(
                                                    color: midBlue,
                                                    width: 1.4)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
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
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              validData.value = false;
                                            } else {
                                              if (_email.text.isNotEmpty) {
                                                validData.value = true;
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("ایمیل",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                                          controller: _email,
                                          textDirection: TextDirection.ltr,
                                          maxLines: 1,
                                          minLines: 1,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                                borderSide: BorderSide(
                                                    color: midBlue,
                                                    width: 1.4)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
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
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              validData.value = false;
                                            } else {
                                              if (_nameAndFamily
                                                  .text.isNotEmpty) {
                                                validData.value = true;
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ValueListenableBuilder<bool>(
                                valueListenable: validData,
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
                                  onPressed: state is ProfileInitState &&
                                              state.onWating ||
                                          !value
                                      ? null
                                      : () {
                                          BlocProvider.of<Profilebloc>(context)
                                              .add(ChangeInfoEvent(
                                            nameAndFamily: _nameAndFamily.text,
                                            email: _email.text,
                                            saveData: () {
                                              BlocProvider.of<MainScreenBloc>(
                                                      mainScreenContext.get())
                                                  .add(
                                                      MainScreenDefaultEvent());
                                              Get.back();
                                            },
                                          ));
                                        },
                                  child: state is ProfileInitState &&
                                          state.onWating
                                      ? SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: LoadingRing(
                                            lineWidth: 1.5,
                                            size: 20,
                                          ),
                                        )
                                      : const Text(
                                          "تایید",
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
