import 'dart:convert';
import 'package:admin/ApiException/api_exception.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:dio/dio.dart';

abstract class IGetDataRemote {
  Future<Monitoring> monitoring();
  Future<NotificationDataModel> getNotification();
  Future<HomeDataModel> mainData();

  Future<CategoryPageDataModel> getPage({required String mainGroupId});

  Future<PageinationDataModel> getDocumentsBy(
      {required int ofsset,
      required String group,
      required String subGroup,
      required String by});

  Future<PageinationDataModel> getAllDocumentsBy(
      {required int ofsset, required String by});

  Future<OrdinaryDocumentDataModel> getDocument({required int id});
  Future<EditDocumentDataModel> getDocumentToEdit({required int id});

  Future<SearchPageinationDataModel> search({
    required int ofsset,
    required String topic,
    required String by,
  });
  Future<SearchPageinationDataModel> searchByLabel({
    required int ofsset,
    required String topic,
    required String by,
  });

  Future<CategoriesDataModel> getCategories();
  Future<SingleCategoryDataModel> getSingleCategoriy(String id);
  Future<GroupSubGroup> getGroupSubGroupById(String groupId, String subGroupId);
  Future<List> getUnGroupingDocuments();
  Future<SubGroupsDataModel> getSubGroups(String mainGroupId);

  Future<List> getTermsAndConditions();
  Future<List> getAboutUs();
  Future<List> getContactUs();

  Future<UserDataModel> userInfo({required String userName});

  Future<AllSubscriptionDataModel> getSubscriptions();
  Future<SingleSubscriptionDataModel> getSingleSubscription(
      {required String subscriptionId});

  Future<AllDiscountCodeDataModel> getDiscountCodes();
  Future<SingleDiscountCodeDataModel> getSingleDiscountCode(
      {required String discountCodeId});
}

class GetDataRemote implements IGetDataRemote {
  final Dio _dio = locator.get();

  String adminPassword = "GX6P3TdrHCb^q#Ln";

  @override
  Future<Monitoring> monitoring() async {
    try {
      var register = await _dio.request(
        "monitoring.php",
      );
      var registerData = jsonDecode(register.data);
      return Monitoring(
        usersNumber: registerData["usersNumber"],
        documentNumber: registerData["documentNumber"],
        categoriesNumber: registerData["categoriesNumber"],
        smsCredit: registerData["smsCredit"],
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<HomeDataModel> mainData() async {
    List categories = [];
    List main = [];
    try {
      var register = await _dio.request(
        "pages/fetch-mainpage.php",
      );
      var registerData = jsonDecode(register.data);

      main = jsonDecode(registerData["data"]);

      register = await _dio.request(
        "categories/fetch-categories.php",
      );
      categories = jsonDecode(register.data) ?? [];

      return HomeDataModel(main: main, categories: categories);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<CategoryPageDataModel> getPage({required String mainGroupId}) async {
    String? image = "";
    List page = [];

    // ------------------------------------------------
    try {
      var register =
          await _dio.request("pages/fetch-grouppage.php", queryParameters: {
        "MainGroupId": mainGroupId,
        "AdminPassword": adminPassword,
      });
      var registerData = jsonDecode(register.data);
      image = registerData["image"];
      page = jsonDecode(registerData["page"]) ?? [];

      return CategoryPageDataModel(
        image: image,
        page: page,
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<PageinationDataModel> getDocumentsBy(
      {required int ofsset,
      required String group,
      required String subGroup,
      required String by}) async {
    try {
      var register = await _dio
          .request("document/fetch-document-by.php", queryParameters: {
        "Offset": ofsset,
        "Group": group,
        "SubGroup": subGroup,
        "By": by,
      });
      var registerData = jsonDecode(register.data);
      return PageinationDataModel(
          documents: registerData["data"], next: registerData["next"]);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<PageinationDataModel> getAllDocumentsBy(
      {required int ofsset, required String by}) async {
    try {
      var register = await _dio.request("document/fetch-documents.php",
          queryParameters: {"Offset": ofsset, "By": by});
      var registerData = jsonDecode(register.data);
      return PageinationDataModel(
          documents: registerData["data"], next: registerData["next"]);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<OrdinaryDocumentDataModel> getDocument({required int id}) async {
    Map document = {};
    List recommended = [];
    try {
      var register = await _dio
          .request("document/fetch-single-document.php", queryParameters: {
        "Id": id,
        "AdminPassword": adminPassword,
      });
      var registerData = jsonDecode(register.data);
      // print(registerData["test"]);
      document = {
        "name": registerData["name"],
        "mainimage": registerData["mainimage"],
        "body": List.of(jsonDecode(registerData["body"])),
        "audioList": List.of(jsonDecode(registerData["audioList"])),
        "isSubscription": registerData["isSubscription"],
        "labels": List.of(jsonDecode(registerData["labels"])),
        "group": registerData["group"],
        "subgroup": registerData["subgroup"],
        "groupId": registerData["groupId"],
        "subgroupId": registerData["subgroupId"],
        "likes": registerData["likes"],
        "creationDate": registerData["creationDate"],
        "id": int.parse(registerData["id"]),
        "isLiked": registerData["isLiked"],
        "isBookmarked": registerData["isBookmarked"],
        "permission": registerData["permission"],
      };

      // -----------------------------------------------------------
      register = await _dio
          .request("document/fetch-recommended.php", queryParameters: {
        "MainGroup": document["groupId"],
        "SubGroup": document["subgroupId"],
      });
      registerData = List.of(jsonDecode(register.data));
      recommended = registerData;
      recommended.removeWhere((element) => element["id"] == id);
      // -----------------------------------------------------------
      return OrdinaryDocumentDataModel(
        name: document["name"],
        mainimage: document["mainimage"],
        body: document["body"],
        isSubscription: document["isSubscription"],
        labels: document["labels"],
        group: document["group"],
        subGroup: document["subgroup"],
        groupId: document["groupId"],
        subGroupId: document["subgroupId"],
        likes: document["likes"],
        creationDate: document["creationDate"],
        id: document["id"],
        audioList: document["audioList"],
        recommended: recommended,
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      print(ex);
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<EditDocumentDataModel> getDocumentToEdit({required int id}) async {
    Map document = {};
    try {
      var register = await _dio
          .request("document/fetch-document-to-edit.php", queryParameters: {
        "Id": id,
        "AdminPassword": adminPassword,
      });
      var registerData = jsonDecode(register.data);
      document = {
        "name": registerData["name"],
        "id": int.parse(registerData["id"]),
        "mainimage": registerData["mainimage"],
        "body": List.of(jsonDecode(registerData["body"])),
        "audioList": List.of(jsonDecode(registerData["audioList"])),
        "isSubscription": registerData["isSubscription"],
        "labels": List.of(jsonDecode(registerData["labels"])),
        "groupId": registerData["groupId"],
        "subgroupId": registerData["subgroupId"] ?? "",
        "group": registerData["group"] ?? "",
        "subgroup": registerData["subgroup"],
      };
      // -----------------------------------------------------------
      return EditDocumentDataModel(
        newName: document["name"],
        name: document["name"],
        id: document["id"],
        mainimage: document["mainimage"],
        body: document["body"],
        isSubscription: document["isSubscription"],
        labels: document["labels"],
        groupId: document["groupId"],
        subGroupId: document["subgroupId"],
        group: document["group"],
        subGroup: document["subgroup"],
        audioList: document["audioList"],
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<SearchPageinationDataModel> search(
      {required int ofsset, required String topic, required String by}) async {
    try {
      var register = await _dio.request("search.php", queryParameters: {
        "Offset": ofsset,
        "Topic": topic,
        "By": by,
      });
      var registerData = jsonDecode(register.data);
      return SearchPageinationDataModel(
        documents: registerData["data"],
        next: registerData["next"],
        offset: registerData["offset"],
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<SearchPageinationDataModel> searchByLabel({
    required int ofsset,
    required String topic,
    required String by,
  }) async {
    try {
      var register = await _dio.request(
        "search-by-labels.php",
        queryParameters: {
          "Offset": ofsset,
          "Topic": topic,
          "By": by,
        },
      );
      var registerData = jsonDecode(register.data);
      return SearchPageinationDataModel(
        documents: registerData["data"],
        next: registerData["next"],
        offset: registerData["offset"],
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<NotificationDataModel> getNotification() async {
    try {
      var register = await _dio.request("notification/fetch-notification.php");
      var registerData = jsonDecode(register.data);
      String message = registerData["notificationMessage"] ?? "";
      bool enable = registerData["enable"] ?? false;
      return NotificationDataModel(message: message, enable: enable);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<CategoriesDataModel> getCategories() async {
    List categories = [];
    try {
      var register = await _dio.request(
        "categories/fetch-categories.php",
      );
      categories = jsonDecode(register.data) ?? [];
      return CategoriesDataModel(categoriesList: categories);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<SingleCategoryDataModel> getSingleCategoriy(String id) async {
    String name = "";
    String? image = "";
    Map subGroup = {};
    bool showInHomePage = true;
    bool specialGroup = false;
    try {
      var register = await _dio.request(
        "categories/fetch-single-category.php",
        queryParameters: {
          "Id": id,
        },
      );
      var registerData = jsonDecode(register.data);
      name = registerData["name"];
      image = registerData["image"];
      subGroup =
          registerData["subgroups"].isNotEmpty ? registerData["subgroups"] : {};
      showInHomePage = registerData["showinhomepage"];
      specialGroup = registerData["specialGroup"];
      return SingleCategoryDataModel(
        name: name,
        newName: name,
        image: image ?? "",
        subGroups: subGroup,
        showinhomepage: showInHomePage,
        specialGroup: specialGroup,
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<GroupSubGroup> getGroupSubGroupById(
      String groupId, String subGroupId) async {
    try {
      String group = "";
      String subGroup = "";
      var register = await _dio
          .request("categories/fetch-category-by-id.php", queryParameters: {
        "MainGroupId": groupId,
        "SubGroupId": subGroupId,
      });

      var registerData = jsonDecode(register.data);
      group = registerData["maingroup"] ?? "";
      subGroup = registerData["subgroup"] ?? "";

      return GroupSubGroup(group: group, subGroup: subGroup);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<List> getUnGroupingDocuments() async {
    try {
      var register = await _dio.request(
        "categories/documents-with-deleted-categories.php",
      );
      print(register.data);
      var data = jsonDecode(register.data);
      return data;
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<SubGroupsDataModel> getSubGroups(String mainGroupId) async {
    try {
      var register = await _dio.request("categories/fetch-sub-groups.php",
          queryParameters: {"MainGroupId": mainGroupId});
      var registerData = jsonDecode(register.data);
      List data = registerData ?? [];
      return SubGroupsDataModel(subGroups: data);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<List> getAboutUs() async {
    try {
      var register = await _dio.request("info/fetch-about-us.php");
      var registerData = jsonDecode(register.data);
      return jsonDecode(registerData["aboutUs"]);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<List> getTermsAndConditions() async {
    try {
      var register = await _dio.request("info/fetch-terms-and-conditions.php");
      var registerData = jsonDecode(register.data);
      return List.of(jsonDecode(registerData["termsAndConditions"]));
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<List> getContactUs() async {
    try {
      var register = await _dio.request("info/fetch-contact-us.php");
      var registerData = jsonDecode(register.data);
      return List.of(jsonDecode(registerData["contactUs"]));
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<UserDataModel> userInfo({required String userName}) async {
    try {
      var register = await _dio
          .request("user/user-info-admin-access.php", queryParameters: {
        "UserName": userName,
        "AdminPassword": adminPassword,
      });
      var registerData = jsonDecode(register.data);
      return UserDataModel(
        nameAndFamily: registerData["NameAndFamily"],
        userName: registerData["UserName"],
        email: registerData["Email"],
        subscription: registerData["Subscription"],
        registryDate: registerData["RegistryDate"],
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<SingleSubscriptionDataModel> getSingleSubscription(
      {required String subscriptionId}) async {
    String id = "";
    String title = "";
    String price = "";
    String discount = "";
    String period = "";
    bool specialSubscription = false;
    bool discountCodeApply = false;
    try {
      var register = await _dio.request(
        "subscription/get-single-subscription.php",
        queryParameters: {
          "Id": subscriptionId,
        },
      );
      var registerData = jsonDecode(register.data);
      id = registerData["id"];
      title = registerData["title"];
      price = registerData["price"];
      discount = registerData["discount"];
      period = registerData["period"];
      specialSubscription = registerData["specialSubscription"];
      discountCodeApply = registerData["discountCodeApply"];
      return SingleSubscriptionDataModel(
        id: id,
        title: title,
        price: price,
        discount: discount,
        period: period,
        specialSubscription: specialSubscription,
        discountCodeApply: discountCodeApply,
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<AllSubscriptionDataModel> getSubscriptions() async {
    List subscriptions = [];
    try {
      var register = await _dio.request(
        "subscription/get-all-subscriptions.php",
      );
      var registerData = jsonDecode(register.data);
      subscriptions = registerData["subscriptions"] ?? [];
      return AllSubscriptionDataModel(subscriptions: subscriptions);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<SingleDiscountCodeDataModel> getSingleDiscountCode(
      {required String discountCodeId}) async {
    String id = "";
    String code = "";
    String normalPercent = "";
    String specialPercent = "";

    try {
      var register = await _dio.request(
        "subscription/get-single-discountcode.php",
        queryParameters: {
          "Id": discountCodeId,
        },
      );
      var registerData = jsonDecode(register.data);
      id = registerData["id"];
      code = registerData["code"];
      normalPercent = registerData["normalPercent"];
      specialPercent = registerData["specialPercent"];

      return SingleDiscountCodeDataModel(
        id: id,
        code: code,
        normalPercent: normalPercent,
        specialPercent: specialPercent,
      );
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<AllDiscountCodeDataModel> getDiscountCodes() async {
    List discountCodes = [];
    try {
      var register = await _dio.request(
        "subscription/get-all-discountcodes.php",
      );

      print(register.data);
      discountCodes = jsonDecode(register.data) ?? [];
      return AllDiscountCodeDataModel(discountCodes: discountCodes);
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }
}
