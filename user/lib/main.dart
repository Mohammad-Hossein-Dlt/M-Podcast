import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/MainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/User/UserData.dart';
import 'package:user/UserProfile/SettingsData.dart';
import 'package:user/paths.dart';

import 'UserProfile/settings_.dart';

String appName = "M پادکست";
String marketLink = "https://cafebazaar.ir";
String contactUs = "https://cafebazaar.ir";

Future<void> main() async {
  await getItInit();
  await Hive.initFlutter();
  // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  Hive.registerAdapter(UserDataAdapter());
  await Hive.openBox<UserData>("User");

  Hive.registerAdapter(SettingsDataAdapter());
  await Hive.openBox<SettingsData>("Settings");

  if (settingsBox.isEmpty) {
    settingsBox.put(
      "SettingsData",
      SettingsData(autoDownload: false, autoPlyaNextAudio: false),
    );
  }

  AppDataDirectory.appDataDirectory = (await getExternalStorageDirectory())!;
  if (!await AppDataDirectory.tempDirectory().exists()) {
    AppDataDirectory.tempDirectory().create(recursive: true);
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "Vazir",
          textTheme: const TextTheme(
            titleMedium: TextStyle(color: Colors.black, fontFamily: "Vazir"),
          ),
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark,
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder()
          })),
      home: BlocProvider(
        create: (context) => MainScreenBloc(),
        child: const MainScreen(),
      ),
    );
  }
}
