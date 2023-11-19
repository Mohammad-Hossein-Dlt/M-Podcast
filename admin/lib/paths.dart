import 'dart:io';

class AppDataDirectory {
  static Directory appDataDirectory = Directory("");
  static Directory mainpage() => Directory('${appDataDirectory.path}/MainPage');
  static Directory documentOnlineEdit() =>
      Directory('${appDataDirectory.path}/DocumentOnlineEdit');
  static Directory documents() =>
      Directory('${appDataDirectory.path}/Documents');
  static Directory categories() =>
      Directory('${appDataDirectory.path}/CategoriesImage');

  static Directory documentPath(String documentname) =>
      Directory('${appDataDirectory.path}/Documents/$documentname');
}
