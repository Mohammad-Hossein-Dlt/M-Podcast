import 'package:get/get.dart';
import 'package:user/Bloc/BookmarksBloc/favorites_block.dart';
import 'package:user/Bloc/CategoriesBloc/categories_block.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_state.dart';
import 'package:user/Bloc/NotesBloc/notes_block.dart';
import 'package:user/Bloc/ProfileBloc/profile_block.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/MainScreen/splash_screen.dart';
import 'package:user/Notes/notes_screen.dart';
import 'package:user/Home/home.dart';
import 'package:user/Bloc/HomeBloc/home_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/UserProfile/profile.dart';
import 'package:user/Favorites/favorites_screen.dart';
import 'package:get_it/get_it.dart';

import '../iconsax_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int curentIndex = 4;

  @override
  void initState() {
    BlocProvider.of<MainScreenBloc>(context)
        .add(GetMainScreenDataEvent(notification: notification));
    getMainScreenContext(this.context);

    // linkStream.listen((event) {
    //   if (event!.toLowerCase().contains("authority")) {
    //     Fluttertoast.showToast(
    //       msg: event,
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER_RIGHT,
    //       backgroundColor: purple,
    //       textColor: Colors.white,
    //     );
    //   }
    // });
    super.initState();
  }

  void notification({required String message}) {
    Get.defaultDialog(
        title: "",
        titlePadding: EdgeInsets.zero,
        backgroundColor: const Color(0xffF0F0F2),
        content: Text(
          message,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xffF0F0F2),
                    enableFeedback: false,
                    minimumSize: const Size(200, 40),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    // side: BorderSide(color: blue),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "باشه",
                    style: TextStyle(color: Color(0xff848DA2)),
                  )),
            ],
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        if (state is MainScreenSplashState) {
          return SplashScreen(
            isRefresh: false,
            onRefresh: () {},
          );
        }
        if (state is MainScreenErrorSplashState) {
          return SplashScreen(
            isRefresh: true,
            onRefresh: () {
              BlocProvider.of<MainScreenBloc>(context)
                  .add(GetMainScreenDataEvent(notification: notification));
            },
          );
        }
        if (state is MainScreentMainState) {
          return mainScreen(state.uniqueKey);
        }
        return const Text("خطایی رخ داد!");
      },
    );
  }

  UniqueKey _uniqueKey = UniqueKey();

  Widget mainScreen(UniqueKey uniqueKey) {
    _uniqueKey = uniqueKey;
    return Scaffold(
      key: _uniqueKey,
      extendBody: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: curentIndex,
        // elevation: 10,
        onTap: (index) {
          setState(() {
            curentIndex = index;
          });
        },
        selectedFontSize: 12,
        selectedItemColor: black,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedFontSize: 12,
        unselectedItemColor: const Color(0xff848DA2),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.user,
                color: Color(0xff848DA2),
              ),
              activeIcon: Icon(
                Iconsax.user,
                color: black,
              ),
              label: "پروفایل"),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.heart,
                color: Color(0xff848DA2),
              ),
              activeIcon: Icon(
                Iconsax.heart,
                color: black,
              ),
              label: "علافه مندی ها"),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.document_text_1,
                color: Color(0xff848DA2),
              ),
              activeIcon: Icon(
                Iconsax.document_text_1,
                color: black,
              ),
              label: "یادداشت ها"),
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Iconsax.search_normal_1,
          //       color: Color(0xff848DA2),
          //     ),
          //     activeIcon: Icon(
          //       Iconsax.search_normal_1,
          //       color: black,
          //     ),
          //     label: "جستجو"),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.category,
                color: Color(0xff848DA2),
              ),
              activeIcon: Icon(
                Iconsax.category,
                color: black,
              ),
              label: "دسته بندی ها"),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.home,
                color: Color(0xff848DA2),
              ),
              activeIcon: Icon(
                Iconsax.home4,
                color: black,
              ),
              label: "خانه"),
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            IndexedStack(
              index: curentIndex,
              children: [
                BlocProvider(
                  create: (context) => Profilebloc(),
                  child: const Profile(),
                ),
                BlocProvider(
                  create: (context) => FavoritesBloc(),
                  child: const Favorites(),
                ),
                BlocProvider(
                  create: (context) => NotesBloc(),
                  child: const Notes(),
                ),
                // BlocProvider(
                //   create: (context) => SearchBloc(),
                //   child: Scaffold(
                //     backgroundColor: Colors.white,
                //     body: SearchScreen(),
                //   ),
                // ),
                BlocProvider(
                  create: (context) => CategoriesBloc(),
                  child: CategoriesList(),
                ),
                BlocProvider(
                  create: (context) => HomeBloc(),
                  child: Home(),
                ),
              ],
            ),
            // if (state is MainScreenAudioState) ...[
            //   smalMusicPlayer(
            //     name: state.name,
            //     pm: state.curentAudio,
            //     mainImage: state.mainImage,
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  // Widget smalMusicPlayer({
  //   required DocumentDataModel document,
  //   required PageManager pm,
  //   required String mainImage,
  // }) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.of(context).push(PageRouteBuilder(
  //         pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
  //             create: (context) => DocumentOnlineBloc(),
  //             child: DocumentOnline(
  //               id: document.id.toString(),
  //               pm: pm,
  //             )),
  //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //           var begin = const Offset(0.0, 1.0);
  //           var end = Offset.zero;
  //           var tween = Tween(begin: begin, end: end)
  //               .chain(CurveTween(curve: Curves.ease));

  //           return SlideTransition(
  //             position: animation.drive(tween),
  //             child: child,
  //           );
  //         },
  //       ));
  //     },
  //     child: Container(
  //       height: 60,
  //       decoration: BoxDecoration(
  //         color: white,
  //       ),
  //       child: Column(
  //         children: [
  //           ValueListenableBuilder(
  //             valueListenable: pm.progressNotifier,
  //             builder: (context, value, child) => SliderTheme(
  //               data: SliderTheme.of(context).copyWith(
  //                   inactiveTrackColor: silver,
  //                   thumbShape:
  //                       const RoundSliderThumbShape(enabledThumbRadius: 0),
  //                   overlayShape:
  //                       const RoundSliderOverlayShape(overlayRadius: 0),
  //                   trackHeight: 0.5),
  //               child: Slider(
  //                 // min: 0,
  //                 max: value.total.inSeconds.toDouble(),
  //                 value: value.position.inSeconds.toDouble(),
  //                 thumbColor: green,
  //                 activeColor: green,
  //                 onChanged: (value) {},
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 15,
  //             ),
  //             child: Row(
  //               children: [
  //                 IconButton(
  //                   onPressed: () {
  //                     pm.dispose();
  //                     BlocProvider.of<MainScreenBloc>(context).add(
  //                         MainScreenDisposeAudioEvent(name: document.name));
  //                   },
  //                   icon: Icon(
  //                     Iconsax.close_circle,
  //                     color: lightgray,
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 6),
  //                   child: ValueListenableBuilder(
  //                     valueListenable: pm.isLoaded,
  //                     builder: (context, value, child) => value
  //                         ? ValueListenableBuilder<AudioState>(
  //                             valueListenable: pm.buttonNotifier,
  //                             builder: (context, value, child) {
  //                               switch (value) {
  //                                 case AudioState.paused:
  //                                   return TextButton(
  //                                     style: TextButton.styleFrom(
  //                                       padding: EdgeInsets.zero,
  //                                     ),
  //                                     onPressed: () {
  //                                       pm.play();
  //                                     },
  //                                     child: Icon(
  //                                       Iconsax.play4,
  //                                       color: green,
  //                                     ),
  //                                   );
  //                                 case AudioState.playing:
  //                                   return TextButton(
  //                                     style: TextButton.styleFrom(
  //                                       padding: EdgeInsets.zero,
  //                                     ),
  //                                     onPressed: () {
  //                                       pm.pause();
  //                                     },
  //                                     child: Icon(
  //                                       Iconsax.pause4,
  //                                       color: green,
  //                                     ),
  //                                   );
  //                               }
  //                             },
  //                           )
  //                         : LoadingRing(),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       ValueListenableBuilder(
  //                         valueListenable: pm.isLoaded,
  //                         builder: (context, value, child) {
  //                           return Row(
  //                             mainAxisAlignment: MainAxisAlignment.end,
  //                             children: [
  //                               Expanded(
  //                                 child: Column(
  //                                   children: [
  //                                     Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.end,
  //                                       children: [
  //                                         Expanded(
  //                                           child: Directionality(
  //                                             textDirection: TextDirection.rtl,
  //                                             child: Text(
  //                                               document.name,
  //                                               overflow: TextOverflow.ellipsis,
  //                                               maxLines: 2,
  //                                               style: TextStyle(
  //                                                 color: black,
  //                                                 fontSize: 10,
  //                                                 // fontWeight: FontWeight.bold,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.end,
  //                                       children: [
  //                                         Text(" ثانیه ",
  //                                             style: TextStyle(
  //                                                 fontSize: 10, color: green)),
  //                                         Text(
  //                                           "${(pm.progressNotifier.value.total.inSeconds % 60).floor() < 10 ? 0 : ''}${(pm.progressNotifier.value.total.inSeconds % 60).floor()}",
  //                                           style: TextStyle(
  //                                               fontSize: 10, color: green),
  //                                         ),
  //                                         Text(
  //                                           " دقیقه و ",
  //                                           style: TextStyle(
  //                                             fontSize: 10,
  //                                             color: green,
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           (pm.progressNotifier.value.total
  //                                                       .inSeconds /
  //                                                   60)
  //                                               .floor()
  //                                               .toString(),
  //                                           style: TextStyle(
  //                                             fontSize: 10,
  //                                             color: green,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           );
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Container(
  //                   width: 50,
  //                   height: 50,
  //                   // padding: EdgeInsets.only(right: 10),
  //                   decoration: const BoxDecoration(
  //                     borderRadius: BorderRadius.all(Radius.circular(6)),
  //                   ),
  //                   child: ClipRRect(
  //                     borderRadius: const BorderRadius.all(Radius.circular(6)),
  //                     child: FittedBox(
  //                       fit: BoxFit.cover,
  //                       child: ImageItem.Item(
  //                         documentName: document.name,
  //                         imageName: mainImage,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

GetIt mainScreenContext = GetIt.instance;

Future<void> getMainScreenContext(BuildContext context) async {
  mainScreenContext.registerSingleton<BuildContext>(context);
}
