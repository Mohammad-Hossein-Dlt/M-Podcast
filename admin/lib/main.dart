import 'package:admin/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/paths.dart';
import 'package:admin/MainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'Document/DocumentModel.dart';

String appName = "M ادمین پادکست";

Future<void> main() async {
  await getItInit();
  await Hive.initFlutter();
  // -----------------------------------------------
  Hive.registerAdapter(DocumentModelAdapter());
  await Hive.openBox<DocumentModel>("Documents");
  // -----------------------------------------------
  AppDataDirectory.appDataDirectory = (await getExternalStorageDirectory())!;
  if (!await AppDataDirectory.documents().exists()) {
    AppDataDirectory.documents().create(recursive: true);
  }
  if (!await AppDataDirectory.mainpage().exists()) {
    AppDataDirectory.mainpage().create(recursive: true);
  }
  if (!await AppDataDirectory.documentOnlineEdit().exists()) {
    AppDataDirectory.documentOnlineEdit().create(recursive: true);
  }
  if (!await AppDataDirectory.categories().exists()) {
    AppDataDirectory.categories().create(recursive: true);
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const Admin());
}

class Admin extends StatelessWidget {
  const Admin({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Shabnam",
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.black, fontFamily: "Shabnam"),
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => MainScreenBloc(),
        child: MainScreen(),
      ),
    );
  }
}
