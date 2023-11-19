import 'package:admin/Bloc/CategoriesBloc/categories_block.dart';
import 'package:admin/Bloc/DashboardBloc/dashboard_block.dart';
import 'package:admin/Bloc/DocumentBloc/document_block.dart';
import 'package:admin/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:admin/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:admin/Bloc/MainScreenBloc/main_screen_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/Dashboard/dashboard.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/DocumentOnline/document_online.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/PageManager/pagemanager.dart';
import 'package:admin/Home/home.dart';
import 'package:admin/Bloc/HomeBloc/home_block.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../DocumentOnline/document_item.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int curentIndex = 2;

  @override
  void initState() {
    BlocProvider.of<MainScreenBloc>(context)
        .add(GetMainScreenDataEvent(ctx: this.context));
    getMainScreenContext(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      extendBody: true,
      backgroundColor: const Color(0xffFAFAFA),
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
        unselectedItemColor: lightgray,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(
                Iconsax.setting_2,
                color: Color(0xff848DA2),
              ),
              activeIcon: Icon(
                Iconsax.setting_2,
                color: black,
              ),
              label: "داشبورد"),
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
              icon: const Icon(
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
        child: BlocBuilder<MainScreenBloc, MainScreenState>(
          builder: (context, state) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: state is MainScreenAudioState ? 60 : 0),
                child: IndexedStack(
                  index: curentIndex,
                  children: [
                    // const Subscription(),
                    BlocProvider(
                        create: (context) => DashboardBloc(),
                        child: const Dashboard()),
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
      ),
    );
  }

  Widget smalMusicPlayer({
    required OrdinaryDocumentDataModel document,
    required PageManager pm,
    required String mainImage,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
              create: (context) => DocumentOnlineBloc(),
              child: DocumentOnline(
                id: document.id.toString(),
                // pm: pm,
              )),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.ease));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: pm.progressNotifier,
              builder: (context, value, child) => SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    inactiveTrackColor: silver,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 0),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 0),
                    trackHeight: 0.5),
                child: Slider(
                  // min: 0,
                  max: value.total.inSeconds.toDouble(),
                  value: value.position.inSeconds.toDouble(),
                  thumbColor: green,
                  activeColor: green,
                  onChanged: (value) {},
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        pm.dispose();
                        BlocProvider.of<MainScreenBloc>(context).add(
                            MainScreenDisposeAudioEvent(name: document.name));
                      },
                      icon: SvgPicture.asset(
                        "assets/images/close.svg",
                        color: lightgray,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: ValueListenableBuilder(
                      valueListenable: pm.isLoaded,
                      builder: (context, value, child) => value
                          ? ValueListenableBuilder<AudioState>(
                              valueListenable: pm.buttonNotifier,
                              builder: (context, value, child) {
                                switch (value) {
                                  case AudioState.paused:
                                    return InkWell(
                                      onTap: () {
                                        pm.play();
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/play.svg",
                                        color: green,
                                      ),
                                    );
                                  case AudioState.playing:
                                    return InkWell(
                                      onTap: () {
                                        pm.pause();
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/pause.svg",
                                        color: green,
                                      ),
                                    );
                                }
                              },
                            )
                          : LoadingRing(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: pm.isLoaded,
                          builder: (context, value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                document.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: black,
                                                  fontSize: 10,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(" ثانیه ",
                                              style: TextStyle(
                                                  fontSize: 10, color: green)),
                                          Text(
                                            "${(pm.progressNotifier.value.total.inSeconds % 60).floor() < 10 ? 0 : ''}${(pm.progressNotifier.value.total.inSeconds % 60).floor()}",
                                            style: TextStyle(
                                                fontSize: 10, color: green),
                                          ),
                                          Text(
                                            " دقیقه و ",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: green,
                                            ),
                                          ),
                                          Text(
                                            (pm.progressNotifier.value.total
                                                        .inSeconds /
                                                    60)
                                                .floor()
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 50,
                    height: 50,
                    // padding: EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: ImageItem.Item(
                          documentName: document.name,
                          imageName: mainImage,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

GetIt mainScreenContext = GetIt.instance;

Future<void> getMainScreenContext(BuildContext context) async {
  mainScreenContext.registerSingleton<BuildContext>(context);
}
