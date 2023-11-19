import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/Bloc/InfoBlock/info_block.dart';
import 'package:user/Bloc/LikedBloc/liked_block.dart';
import 'package:user/Bloc/LoginBloc/login_block.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:user/Bloc/ProfileBloc/profile_block.dart';
import 'package:user/Bloc/ProfileBloc/profile_event.dart';
import 'package:user/Bloc/ProfileBloc/profile_state.dart';
import 'package:user/Bloc/SubscriptionBloc/subscription_block.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/InfoScreen/info_screen.dart';
import 'package:user/Likes/likes_screen.dart';
import 'package:user/Login/login.dart';
import 'package:user/MainScreen/main_screen.dart';
import 'package:user/User/User.dart';
import 'package:user/User/change_info.dart';
import 'package:user/User/change_password.dart';
import 'package:user/User/change_username.dart';
import 'package:user/UserProfile/settings_.dart';
import 'package:user/iconsax_icons.dart';
import 'package:user/main.dart';
import 'package:user/paths.dart';

import '../Subscription/subscription_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Timer countDown = Timer(const Duration(seconds: 5), () {});
  bool isCountingDown = false;
  Duration duration = const Duration(seconds: 5);
  void setCountDown() {
    int reduceSeconsBy = 1;
    setState(() {
      final curentSeconds = duration.inSeconds - reduceSeconsBy;
      if (curentSeconds <= 0) {
        countDown.cancel();
        isCountingDown = false;
        List flist = AppDataDirectory.tempDirectory().listSync();
        for (File f in flist) {
          f.delete();
        }
      } else {
        duration = Duration(seconds: curentSeconds);
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<Profilebloc>(context).add(ProfileDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: BlocBuilder<Profilebloc, ProfileState>(
        builder: (context, state) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    pinned: true,
                    forceElevated: true,
                    backgroundColor: Colors.white,
                    elevation: 1,
                    shadowColor: Colors.white,
                    title: Text(
                      "حساب کاربری",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    centerTitle: true,
                    leading: SizedBox(),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // if (state is ProfileDataState) ...[
                          //   Container(
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 10, vertical: 6),
                          //     decoration: const BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(20),
                          //       ),
                          //     ),
                          //     child: userLogin(),
                          //   ),
                          // ],
                          if (state is NoLoginState) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: noLogin(),
                            ),
                            const SizedBox(height: 20),
                          ],
                          const SizedBox(height: 20),
                          if (state is ProfileDataState) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  userLogin(),
                                  const SizedBox(height: 10),
                                  item(
                                    title: "اطلاعات حساب کاربری",
                                    subTitle: "مشاهده و ویرایش حساب کاربری",
                                    icon: const Icon(
                                      Iconsax.user,
                                      color: black,
                                    ),
                                    iconContainerColor: const Color(0xffF1F5FF),
                                    function: () {
                                      Get.to(
                                        BlocProvider(
                                          create: (context) => Profilebloc(),
                                          child: ChangeInfo(),
                                        ),
                                      );
                                    },
                                  ),
                                  item(
                                    title: "شماره موبایل",
                                    subTitle: "مشاهده و ویرایش شماره موبایل",
                                    icon: Transform.scale(
                                      scaleX: -1,
                                      child: const Icon(
                                        Icons.phone_enabled_outlined,
                                        color: black,
                                      ),
                                    ),
                                    iconContainerColor: const Color(0xffF1F5FF),
                                    function: () {
                                      Get.to(
                                        BlocProvider(
                                          create: (context) => Profilebloc(),
                                          child: ChangeUserName(),
                                        ),
                                      );
                                    },
                                  ),
                                  item(
                                    title: "رمز عبور",
                                    subTitle: "تنظیمات و تغییرات رمز عبور",
                                    icon: const Icon(
                                      Iconsax.password_check,
                                      color: black,
                                    ),
                                    iconContainerColor: const Color(0xffF1F5FF),
                                    function: () {
                                      Get.to(
                                        BlocProvider(
                                          create: (context) => Profilebloc(),
                                          child: ChangePassword(),
                                        ),
                                      );
                                    },
                                  ),
                                  item(
                                    title: "مطالب پسندیده",
                                    subTitle: "مشاهده مطالب پسندیده شده",
                                    icon: const Icon(
                                      Iconsax.like,
                                      color: black,
                                    ),
                                    iconContainerColor: const Color(0xffF1F5FF),
                                    function: () {
                                      Get.to(
                                        BlocProvider(
                                          create: (context) => LikedBloc(),
                                          child: const LikesScreen(),
                                        ),
                                      );
                                    },
                                    hideDivider: true,
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 20),
                          ],
                          // settings(),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                item(
                                  title: "قوانین و مقررات",
                                  icon: const Icon(
                                    Iconsax.book,
                                    color: black,
                                  ),
                                  iconContainerColor: const Color(0xffF1F5FF),
                                  function: () {
                                    Get.to(
                                      BlocProvider(
                                        create: (context) => InfoBloc(),
                                        child: InfoScreen(
                                            info: Info.termsAndConditions),
                                      ),
                                    );
                                  },
                                ),
                                item(
                                  title: "درباره ما",
                                  icon: const Icon(
                                    Iconsax.information,
                                    color: black,
                                  ),
                                  iconContainerColor: const Color(0xffF1F5FF),
                                  function: () {
                                    Get.to(
                                      BlocProvider(
                                        create: (context) => InfoBloc(),
                                        child: InfoScreen(info: Info.aboutUs),
                                      ),
                                    );
                                  },
                                  hideDivider: false,
                                ),
                                item(
                                  title: "ارتباط با ما",
                                  icon: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: SvgPicture.asset(
                                      "assets/images/contactus.svg",
                                      color: black,
                                    ),
                                  ),
                                  iconContainerColor: const Color(0xffF1F5FF),
                                  function: () async {
                                    if (!await launchUrl(Uri.parse(contactUs),
                                        mode: LaunchMode.externalApplication)) {
                                      throw "";
                                    }
                                  },
                                  hideDivider: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 10),
                          //   child: Text("نسخه 1.0.0"),
                          // ),
                          if (state is ProfileDataState) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: item(
                                title: "خروج از حساب کاربری",
                                titleColor: Colors.red,
                                icon: Transform.scale(
                                  scaleX: -1,
                                  child: const Icon(
                                    Iconsax.logout,
                                    color: Colors.red,
                                  ),
                                ),
                                iconContainerColor: const Color(0xffF1F5FF),
                                hideDivider: true,
                                function: () {
                                  Get.bottomSheet(
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "آیا میخواهید از حساب کاربری خود خارج شوید؟",
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                                0xffF5F5F5),
                                                        foregroundColor: black,
                                                        minimumSize:
                                                            const Size(100, 40),
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text("خیر")),
                                                  const SizedBox(width: 20),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: red,
                                                        minimumSize:
                                                            const Size(120, 40),
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                      ),
                                                      onPressed: () {
                                                        userLogout();
                                                        BlocProvider.of<
                                                                    MainScreenBloc>(
                                                                mainScreenContext
                                                                    .get())
                                                            .add(
                                                                MainScreenDefaultEvent());
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                          "بله، خروج از حساب")),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // const SizedBox(height: 20),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              child: Visibility(
                visible: isCountingDown,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xff26303A).withOpacity(0.8),
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            elevation: 0,
                            shadowColor: Colors.white,
                            // backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            // shape: const RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(6))),
                            // side: const BorderSide(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              countDown.cancel();
                              isCountingDown = false;
                            });
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Iconsax.redo,
                                color: Color(0xff84C9FD),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "برگرداندن",
                                style: TextStyle(
                                  color: Color(0xff84C9FD),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(width: 40),
                      Row(
                        children: [
                          const Text(
                            "همه دانلودهای شما پاک شد",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 26,
                            height: 26,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: duration.inSeconds.toDouble() / 5,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  // "${(duration.inSeconds / 60).floor()}:${(duration.inSeconds % 60).floor() < 10 ? 00 : ''}${(duration.inSeconds % 60).floor()}",
                                  duration.inSeconds.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget settings() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          item(
            leading: Directionality(
              textDirection: TextDirection.rtl,
              child: Switch(
                activeTrackColor: purple,
                activeColor: Colors.white,
                value: settingsData()!.autoDownload,
                onChanged: (value) {
                  settingsData()!.autoDownload = value;
                  settingsData()!.save();
                  setState(() {});
                },
              ),
            ),
            title: "دانلود خودکار فایل های صوتی",
            icon: const Icon(
              Iconsax.book,
              color: black,
            ),
            iconContainerColor: const Color(0xffF1F5FF),
            function: () {},
          ),
          item(
            leading: Directionality(
              textDirection: TextDirection.rtl,
              child: Switch(
                activeTrackColor: purple,
                activeColor: Colors.white,
                value: settingsData()!.autoPlyaNextAudio,
                onChanged: (value) {
                  settingsData()!.autoPlyaNextAudio = value;
                  settingsData()!.save();
                  setState(() {});
                },
              ),
            ),
            title: "پخش خودکار فایل صوتی بعدی",
            icon: const Icon(
              Iconsax.book,
              color: black,
            ),
            iconContainerColor: const Color(0xffF1F5FF),
            function: () {},
          ),
          item(
            leading: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
              onPressed: () {
                Get.defaultDialog(
                  titlePadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  title: "همه دانلود های شما حذف شود؟",
                  content: const SizedBox(),
                  contentPadding: EdgeInsets.zero,
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: const Color(0xff848DA2),
                            enableFeedback: false,

                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            // side: BorderSide(color: blue),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("خیر"),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: black,
                            enableFeedback: false,

                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            // side: BorderSide(color: blue),
                          ),
                          onPressed: () async {
                            setState(() {
                              isCountingDown = true;
                              duration = const Duration(seconds: 5);
                              if (countDown.isActive) {
                                countDown.cancel();
                              }
                              countDown = Timer.periodic(
                                const Duration(seconds: 1),
                                (_) => setCountDown(),
                              );
                            });
                            Get.back();
                          },
                          child: const Text("بله"),
                        ),
                      ],
                    ),
                  ],
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: const BoxDecoration(
                  color: midPurple,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: const Text(
                  "پاک کردن",
                  style: TextStyle(
                    color: purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: "پاک کردن فایل های دانلود شده",
            icon: const Icon(
              Iconsax.book,
              color: black,
            ),
            iconContainerColor: const Color(0xffF1F5FF),
            hideDivider: true,
            function: () {},
          ),
        ],
      ),
    );
  }

  Widget item({
    Widget? leading,
    required String title,
    Color? titleColor,
    String? subTitle,
    Color? subTitleColor,
    required Widget icon,
    Color? iconContainerColor,
    bool? hideDivider,
    required Function() function,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () {
              function();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                leading ??
                                    const Icon(
                                      Iconsax.arrow_left_2,
                                      size: 14,
                                      color: Color(0xff848DA2),
                                    ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                                color: titleColor ?? black),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: subTitle != null,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              subTitle ?? "",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: subTitleColor ??
                                                      lightgray,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   width: 50,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     color: iconContainerColor ?? const Color(0xffF5F5F5),
                    //     borderRadius:
                    //         const BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       icon,
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: hideDivider == null || !hideDivider,
          child: Divider(
            thickness: 1.2,
            color: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Widget noLogin() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "ورود یا ثبت نام",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        const SizedBox(height: 10),
        RichText(
            // textAlign: TextAlign.,
            textDirection: TextDirection.rtl,
            text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  const TextSpan(
                    text: "برای استفاده از تمام امکانات ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: appName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const TextSpan(
                    text:
                        " مثل یادداشت برداری از مطالب و افزودن مطالب به علاقه مندی ها ",
                    style: TextStyle(color: Colors.black),
                  ),
                  const TextSpan(
                    text: "وارد شوید",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const TextSpan(
                    text: " یا ",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                  const TextSpan(
                    text: "ثبت نام ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const TextSpan(
                    text: "کنید ",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                ])),
        const SizedBox(height: 10),
        Row(
          children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size(120, 45),
                  maximumSize: const Size(120, 45),
                  shadowColor: Colors.white,
                  // backgroundColor: Colors.white,
                  foregroundColor: purple,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  side: const BorderSide(color: Colors.white),
                ),
                onPressed: () {
                  Get.to(
                    BlocProvider(
                      create: (context) => LoginBloc(),
                      child: Login(),
                    ),
                  );
                },
                child: const Text(
                  "ورود / ثبت نام",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ],
    );
  }

  Widget userLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              userData()!.nameAndFamily,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                // fontSize:,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              userData()!.phone,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                // fontSize:,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: midPurple, width: 2.5),
                color: accent_blue.withOpacity(0.9),
              ),
              child: SvgPicture.asset(
                "assets/images/person.svg",
                color: Colors.white,
                width: 30,
              ),
            ),
          ],
        ),
        // Divider(
        //   thickness: 1.2,
        //   color: Colors.grey.shade200,
        // ),
        userData()!.haveSubscription
            ? Column(
                children: [
                  const SizedBox(height: 8),
                ],
              )
            : const SizedBox(),
        const SizedBox(height: 8),

        Column(
          children: [
            userData()!.haveSubscription
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${userData()!.remainingSubscription.floor()} روز باقی مانده",
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              color: userData()!.haveSpecialSubscription
                                  ? midRed.withOpacity(0.4)
                                  : Color(0xffF2F2F2),
                            ),
                            child: Center(
                              child: Text(
                                userData()!.haveSpecialSubscription
                                    ? "ویژه"
                                    : "معمولی",
                                style: TextStyle(
                                    color: userData()!.haveSpecialSubscription
                                        ? red.withOpacity(0.5)
                                        : black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${userData()!.subscription.floor()} ماهه",
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Text(
                        " :اشتراک",
                        style: TextStyle(color: black),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            // backgroundColor: Colors.white,
                            minimumSize: const Size(86, 36),
                            maximumSize: const Size(86, 36),
                            shadowColor: Colors.white,
                            // backgroundColor: lightblue,
                            foregroundColor: accent_blue,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            side: BorderSide(
                              color: accent_blue.withOpacity(0.2),
                            ),
                          ),
                          onPressed: () {
                            Get.to(
                              BlocProvider(
                                create: (context) => SubscriptionBloc(),
                                child: const Subscription(),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.keyboard_double_arrow_left_rounded,
                                color: accent_blue,
                                size: 16,
                              ),
                              Text(
                                "خرید اشتراک",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: accent_blue,
                                ),
                              ),
                            ],
                          )),
                      const Text(
                        " !اشتراک ندارید",
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Text(
                        " :وضعیت اشتراک",
                        style: TextStyle(color: black),
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
          ],
        ),

        Divider(
          thickness: 1.2,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }
}
