import 'dart:io';

class AppDataDirectory {
  static Directory appDataDirectory = Directory("");
  static Directory tempDirectory() =>
      Directory('${appDataDirectory.path}/temp');
}
