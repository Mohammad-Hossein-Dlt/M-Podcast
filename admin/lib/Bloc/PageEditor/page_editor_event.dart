abstract class PageEditorEvent {}

class PageEditorDefaultEvent implements PageEditorEvent {}

class GetHomePageDataEvent implements PageEditorEvent {}

class GetCategoryPageDataEvent implements PageEditorEvent {
  String mainGroupId;
  GetCategoryPageDataEvent({required this.mainGroupId});
}

class InitUploadPageEvent implements PageEditorEvent {
  InitUploadPageEvent();
}

class UploadHomePageEvent implements PageEditorEvent {
  List page;
  List removeImages;

  UploadHomePageEvent({
    required this.page,
    required this.removeImages,
  });
}

class UploadCategoryPageEvent implements PageEditorEvent {
  String id;
  List page;
  List removeImages;
  UploadCategoryPageEvent({
    required this.id,
    required this.page,
    required this.removeImages,
  });
}
