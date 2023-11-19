class PageinationDataModel {
  List documents;
  bool next;
  PageinationDataModel({required this.documents, required this.next});
}

class SearchPageinationDataModel {
  List documents;
  bool next;
  int offset;
  SearchPageinationDataModel(
      {required this.documents, required this.next, required this.offset});
}

class HomeDataModel {
  List main;
  HomeDataModel({
    required this.main,
  });
}

class CategoryPageDataModel {
  String? image;
  List page;

  bool permission;

  CategoryPageDataModel({
    required this.image,
    required this.page,
    required this.permission,
  });
}

class CategoriesDataModel {
  List categoriesList;
  CategoriesDataModel({
    required this.categoriesList,
  });
}

class SubGroupsDataModel {
  List subGroups;
  SubGroupsDataModel({
    required this.subGroups,
  });
}

class NotesDataModel {
  List notes;
  bool next;
  NotesDataModel({required this.notes, required this.next});
}

class DocumentDataModel {
  String name = "";
  String mainimage = "";
  List body = [];
  bool isSubscription;
  List labels = [];
  String group = "";
  String subGroup = "";
  String groupId = "";
  String subGroupId = "";
  String likes = "";
  Map creationDate = {};
  int id;
  bool permission;
  // ----------------------------------
  bool isLiked = false;
  bool isBookmarked = false;
  // ----------------------------------
  List audioList;
  List recommended = [];
  DocumentDataModel({
    required this.name,
    required this.mainimage,
    required this.body,
    required this.isSubscription,
    required this.labels,
    required this.group,
    required this.subGroup,
    required this.groupId,
    required this.subGroupId,
    required this.likes,
    required this.creationDate,
    required this.id,
    required this.permission,
    required this.isLiked,
    required this.isBookmarked,
    required this.audioList,
    required this.recommended,
  });
}

class FetchSubscriptionDataModel {
  List subscriptions;
  bool isSetDiscountCode;
  String discountCodeResult;
  FetchSubscriptionDataModel({
    required this.subscriptions,
    required this.isSetDiscountCode,
    required this.discountCodeResult,
  });
}

class SingleSubscriptionDataModel {
  String? id;
  String title;
  String price;
  String discount;
  String period;
  bool specialSubscription;
  SingleSubscriptionDataModel({
    required this.id,
    required this.title,
    required this.price,
    required this.discount,
    required this.period,
    required this.specialSubscription,
  });
}

class NotificationDataModel {
  String message;
  bool enable;
  NotificationDataModel({
    required this.message,
    required this.enable,
  });
}
