abstract class CategoriesPageEvent {}

class GetCategoriesPageData implements CategoriesPageEvent {
  String mainGroupId;
  GetCategoriesPageData({required this.mainGroupId});
}
