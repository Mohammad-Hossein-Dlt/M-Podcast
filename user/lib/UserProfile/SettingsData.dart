import 'package:hive/hive.dart';
part 'SettingsData.g.dart';

@HiveType(typeId: 1)
class SettingsData extends HiveObject {
  SettingsData({
    required this.autoDownload,
    required this.autoPlyaNextAudio,
  });
  @HiveField(0)
  bool autoDownload;
  @HiveField(1)
  bool autoPlyaNextAudio;
}
