import 'package:hive_flutter/hive_flutter.dart';

import 'SettingsData.dart';

String _boxName = "SettingsData";
Box<SettingsData> settingsBox = Hive.box<SettingsData>("Settings");

SettingsData? settingsData() => settingsBox.get(_boxName);
