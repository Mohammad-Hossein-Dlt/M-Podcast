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

class Monitoring {
  int usersNumber;
  int documentNumber;
  int categoriesNumber;
  double smsCredit;
  Monitoring({
    required this.usersNumber,
    required this.documentNumber,
    required this.categoriesNumber,
    required this.smsCredit,
  });
}

class HomeDataModel {
  List categories;
  List main;
  HomeDataModel({required this.main, required this.categories});
}

class CategoryPageDataModel {
  String? image;
  List page;

  CategoryPageDataModel({
    required this.image,
    required this.page,
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

class GroupSubGroup {
  String group;
  String subGroup;
  GroupSubGroup({
    required this.group,
    required this.subGroup,
  });
}

class SingleCategoryDataModel {
  String name;
  String newName;
  String image;
  Map subGroups;
  bool showinhomepage;
  bool specialGroup;
  // ---------------------
  String prevImage;
  SingleCategoryDataModel({
    required this.name,
    required this.newName,
    required this.image,
    required this.subGroups,
    required this.showinhomepage,
    required this.specialGroup,
    this.prevImage = "",
  });
}

class OrdinaryDocumentDataModel {
  String name = "";
  int id = -1;
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
  // ----------------------------------
  List audioList;
  List recommended = [];
  OrdinaryDocumentDataModel({
    required this.name,
    required this.id,
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
    required this.audioList,
    required this.recommended,
  });
}

class EditDocumentDataModel {
  String newName = "";
  String name = "";
  int id = -1;
  String mainimage = "";
  List body = [];
  bool isSubscription;
  List labels = [];
  List audioList;
  String groupId = "";
  String subGroupId = "";
  String group = "";
  String subGroup = "";
  List deletedFiles = [];
  EditDocumentDataModel({
    required this.newName,
    required this.name,
    required this.id,
    required this.mainimage,
    required this.body,
    required this.isSubscription,
    required this.labels,
    required this.audioList,
    required this.groupId,
    required this.subGroupId,
    required this.group,
    required this.subGroup,
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

class UserDataModel {
  String nameAndFamily;
  String userName;
  String email;
  String subscription;
  String registryDate;
  UserDataModel({
    required this.nameAndFamily,
    required this.userName,
    required this.email,
    required this.subscription,
    required this.registryDate,
  });
}

class AllSubscriptionDataModel {
  List subscriptions;
  AllSubscriptionDataModel({
    required this.subscriptions,
  });
}

class SingleSubscriptionDataModel {
  String? id;
  String title;
  String price;
  String discount;
  String period;
  bool specialSubscription;
  bool discountCodeApply;
  SingleSubscriptionDataModel({
    required this.id,
    required this.title,
    required this.price,
    required this.discount,
    required this.period,
    required this.specialSubscription,
    required this.discountCodeApply,
  });
}

class AllDiscountCodeDataModel {
  List discountCodes;
  AllDiscountCodeDataModel({
    required this.discountCodes,
  });
}

class SingleDiscountCodeDataModel {
  String? id;
  String code;
  String normalPercent;
  String specialPercent;
  SingleDiscountCodeDataModel({
    required this.id,
    required this.code,
    required this.normalPercent,
    required this.specialPercent,
  });
}
