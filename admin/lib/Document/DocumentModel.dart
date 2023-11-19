import 'package:hive/hive.dart';
part 'DocumentModel.g.dart';

@HiveType(typeId: 1)
class DocumentModel extends HiveObject {
  DocumentModel({
    required this.name,
    required this.creationDate,
  });
  @HiveField(0)
  String name;
  @HiveField(1)
  String mainImage = "";
  @HiveField(2)
  String creationDate;
  @HiveField(3)
  Map category = {"Group": "", "SubGroup": ""};
  @HiveField(4)
  List audios = [];
  @HiveField(5)
  List body = [];
  @HiveField(6)
  List labels = [];
  @HiveField(7)
  bool isSubscription = false;
  // ---------------------------
  @HiveField(8)
  List deletedFiles = [];
}
