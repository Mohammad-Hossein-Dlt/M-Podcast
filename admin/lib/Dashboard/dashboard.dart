import 'package:admin/Bloc/DashboardBloc/dashboard_block.dart';
import 'package:admin/Bloc/DashboardBloc/dashboard_event.dart';
import 'package:admin/Bloc/DashboardBloc/dashboard_state.dart';
import 'package:admin/Bloc/EditCategoriesBloc/edit_categories_block.dart';
import 'package:admin/Bloc/InfoBlock/info_block.dart';
import 'package:admin/Bloc/NotificationBloc/notification_block.dart';
import 'package:admin/Bloc/SearchBloc/search_block.dart';
import 'package:admin/Bloc/SendMessageBloc/sendmessage_block.dart';
import 'package:admin/Bloc/SubscriptionBloc/subscription_block.dart';
import 'package:admin/Bloc/UserManagementBloc/usermanagement_block.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/Document/documents_list.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/Home/search_screen.dart';
import 'package:admin/InfoScreen/info_screen.dart';
import 'package:admin/Notification/notification.dart';
import 'package:admin/SendMessage/sendmessage_screen.dart';
import 'package:admin/Subscription/subscription_screen.dart';
import 'package:admin/UserManagement/user_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin/iconsax_icons.dart';

import '../Categories/categories.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    BlocProvider.of<DashboardBloc>(context).add(MonitoringEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: black,
        elevation: 0,
        title: const Text(
          "داشبورد",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              BlocProvider.of<DashboardBloc>(context).add(MonitoringEvent());
            },
            child: SvgPicture.asset(
              "assets/images/refresh.svg",
              color: Colors.white,
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) => SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      color: black,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          if (state is DashboardLoadingState) ...[
                            SizedBox(
                              height: 202,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LoadingRing(
                                    lineWidth: 1.5,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (state is MonitoringState) ...[
                            state.data.fold((l) => Text(l), (r) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 132,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                r.usersNumber.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                ":تعداد کاربران",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                r.documentNumber.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                ":تعداد اسناد",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                r.categoriesNumber.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                ":تعداد دسته بندی ها",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 60,
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            r.smsCredit.floor().toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            ":اعتبار پنل پیامکی",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            })
                          ],
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DocumentsList(),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                              color: midWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.document,
                                  color: accent_blue,
                                  size: 60,
                                ),
                                Text(
                                  "اسناد",
                                  style: TextStyle(
                                    color: accent_blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => EditCategoriesBloc(),
                                  child: const Categories(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              color: midWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.category,
                                  color: accent_blue,
                                  size: 60,
                                ),
                                Text(
                                  "دسته‌بندی‌ ها",
                                  style: TextStyle(
                                    color: accent_blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => NotificationBloc(),
                                  child: NotificationEdit(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              color: midWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.notification_status,
                                  color: accent_blue,
                                  size: 60,
                                ),
                                Text(
                                  "اعلان‌ صفحه‌اصلی",
                                  style: TextStyle(
                                    color: accent_blue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => SearchBloc(),
                                  child: Scaffold(
                                    backgroundColor: Colors.white,
                                    body: SearchScreen(
                                      onDelete: true,
                                      preSearch: "",
                                      back: null,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              color: midWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.trash,
                                  color: accent_blue,
                                  size: 60,
                                ),
                                Text(
                                  "حذف اسناد",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: accent_blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => SearchBloc(),
                                  child: BlocProvider(
                                    create: (context) => UserManagementBloc(),
                                    child: UserManagement(),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              color: midWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.user_edit,
                                  color: accent_blue,
                                  size: 50,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "مدیریت کاربران",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: accent_blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => SubscriptionBloc(),
                                  child: const Subscription(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                              color: midWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.dollar_square,
                                  color: accent_blue,
                                  size: 60,
                                ),
                                Text(
                                  "اشتراک",
                                  style: TextStyle(
                                    color: accent_blue,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => InfoBloc(),
                                  child:
                                      InfoScreen(info: Info.termsAndConditions),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              color: midWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.book,
                                  color: accent_blue,
                                  size: 60,
                                ),
                                Text(
                                  "قوانین و مقررات",
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: accent_blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => InfoBloc(),
                                  child: InfoScreen(info: Info.aboutUs),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              color: midWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.information,
                                  color: accent_blue,
                                  size: 60,
                                ),
                                Text(
                                  "درباره ما",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: accent_blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => SendMessageBloc(),
                                  child: SendMessage(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              color: midWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.message,
                                  color: accent_blue,
                                  size: 60,
                                ),
                                Text(
                                  "ارسال پیام عمومی",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: accent_blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) => BlocProvider(
                        //           create: (context) => InfoBloc(),
                        //           child: ContactUsScreen(),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   child: Container(
                        //     height: 100,
                        //     width: 100,
                        //     padding: const EdgeInsets.symmetric(horizontal: 10),
                        //     decoration: const BoxDecoration(
                        //       color: midWhite,
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(10),
                        //       ),
                        //     ),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         SvgPicture.asset(
                        //           "assets/images/contactus.svg",
                        //           color: blue,
                        //           width: 50,
                        //         ),
                        //         const SizedBox(height: 4),
                        //         Text(
                        //           "ارتباط با ما",
                        //           textAlign: TextAlign.center,
                        //           style: TextStyle(
                        //             fontSize: 10,
                        //             color: accent_blue,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
