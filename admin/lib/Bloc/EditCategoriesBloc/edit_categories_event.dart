import 'package:admin/DataModel/data_model.dart';

abstract class EditCategoriesEvent {}

class GetCategoriesEvent implements EditCategoriesEvent {}

class GetSingleCategoryDataEvent implements EditCategoriesEvent {
  String mainGroupId;
  GetSingleCategoryDataEvent({required this.mainGroupId});
}

class SingleCategoriesDefaultEvent implements EditCategoriesEvent {}

class CategoryInitUploadEvent implements EditCategoriesEvent {
  String name;
  CategoryInitUploadEvent({required this.name});
}

class CategoryUploadEvent implements EditCategoriesEvent {
  SingleCategoryDataModel singleCategoryDataModel;
  CategoryUploadEvent({
    required this.singleCategoryDataModel,
  });
}

class ReorderCategoriesEvent implements EditCategoriesEvent {
  List groupsId;
  ReorderCategoriesEvent({
    required this.groupsId,
  });
}

class CategoriyDeleteEvent implements EditCategoriesEvent {
  String mainGroupId;
  CategoriyDeleteEvent({required this.mainGroupId});
}
