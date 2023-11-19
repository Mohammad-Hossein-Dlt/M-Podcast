import 'dart:convert';
import 'package:user/ApiException/api_exception.dart';
import 'package:user/DataModel/data_model.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:dio/dio.dart';
import 'package:user/User/user.dart';
import 'package:user/main.dart';

abstract class IGetDataRemote {
  Future<NotificationDataModel> metaData();
  Future<HomeDataModel> mainData();

  Future<CategoryPageDataModel> getPage({required String mainGroupId});

  Future<PageinationDataModel> getDocumentsBy(
      {required int ofsset,
      required String group,
      required String subGroup,
      required String by});

  Future<PageinationDataModel> getAllDocumentsBy(
      {required int ofsset, required String by});

  Future<DocumentDataModel> getDocument({required int id});

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
  Future<SubGroupsDataModel> getSubGroups(String mainGroupId);

  Future<FetchSubscriptionDataModel> getSubscriptions({
    String? discountCode,
  });
  Future<SingleSubscriptionDataModel> getSingleSubscription(
      {required String subscriptionId});

  Future<List> getTermsAndConditions();
  Future<List> getAboutUs();
  Future<List> getContactUs();
}

class GetDataRemote implements IGetDataRemote {
  final Dio _dio = locator.get();

  @override
  Future<NotificationDataModel> metaData() async {
    try {
      var register = await _dio.request("meta-data.php", queryParameters: {
        "Token": isUserLogin() ? userData()!.token : "",
      });
      var registerData = jsonDecode(register.data);
      marketLink = registerData["marketLink"];
      contactUs = registerData["contactUsLink"];
      if (isUserLogin()) {
        userData()!.haveSubscription =
            registerData["userMetaData"]["haveSubscription"];

        userData()!.subscription =
            double.parse(registerData["userMetaData"]["subscription"]);

        userData()!.remainingSubscription =
            double.parse(registerData["userMetaData"]["remainingSubscription"]);

        userData()!.haveSpecialSubscription =
            registerData["userMetaData"]["haveSpecialSubscription"];
        userData()!.save();
      }
      String message = registerData["notificationMessage"] ?? "";
      bool enable = registerData["enableNotification"] ?? false;
      return NotificationDataModel(message: message, enable: enable);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<HomeDataModel> mainData() async {
    List main = [];
    try {
      var register = await _dio.request(
        "pages/fetch-mainpage.php",
      );
      var registerData = jsonDecode(register.data);
      main = jsonDecode(registerData["data"]);

      // ------------------------------------------------
      return HomeDataModel(main: main);
    } on DioException catch (e) {
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

    bool permission = false;
    // ------------------------------------------------
    try {
      var register =
          await _dio.request("pages/fetch-grouppage.php", queryParameters: {
        "MainGroupId": mainGroupId,
        "Token": isUserLogin() ? userData()!.token : "",
      });
      var registerData = jsonDecode(register.data);
      image = registerData["image"];
      page = jsonDecode(registerData["page"]) ?? [];
      permission = registerData["permission"];
      // ------------------------------------------------
      return CategoryPageDataModel(
        image: image,
        page: page,
        permission: permission,
      );
    } on DioException catch (e) {
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
    } on DioException catch (e) {
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
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<DocumentDataModel> getDocument({required int id}) async {
    Map document = {};
    List recommended = [];
    try {
      var register = await _dio.request(
        "document/fetch-single-document.php",
        queryParameters: {
          "Token": isUserLogin() ? userData()!.token : "",
          "Id": id,
        },
      );
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
      return DocumentDataModel(
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
        permission: document["permission"],
        isLiked: document["isLiked"],
        isBookmarked: document["isBookmarked"],
        audioList: document["audioList"],
        recommended: recommended,
      );
    } on DioException catch (e) {
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
    } on DioException catch (e) {
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
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<CategoriesDataModel> getCategories() async {
    try {
      var register = await _dio.request(
        "categories/fetch-categories.php",
      );
      var registerData = jsonDecode(register.data);
      List data = registerData ?? [];
      return CategoriesDataModel(categoriesList: data);
    } on DioException catch (e) {
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
    } on DioException catch (e) {
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
    } on DioException catch (e) {
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
    } on DioException catch (e) {
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
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<FetchSubscriptionDataModel> getSubscriptions({
    String? discountCode,
  }) async {
    List subscriptions = [];
    bool isSetDiscountCode = false;
    String discountCodeResult = "";
    try {
      var register = discountCode == null
          ? await _dio.request(
              "subscription/get-all-subscriptions.php",
            )
          : await _dio.request("subscription/get-all-subscriptions.php",
              queryParameters: {
                  "DiscountCode": discountCode,
                });
      var registerData = jsonDecode(register.data);
      subscriptions = registerData["subscriptions"] ?? [];
      isSetDiscountCode = registerData["isSetDiscountCode"] ?? false;
      discountCodeResult = registerData["discountCodeResult"] ?? "";
      return FetchSubscriptionDataModel(
          subscriptions: subscriptions,
          isSetDiscountCode: isSetDiscountCode,
          discountCodeResult: discountCodeResult);
    } on DioException catch (e) {
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
      return SingleSubscriptionDataModel(
          id: id,
          title: title,
          price: price,
          discount: discount,
          period: period,
          specialSubscription: specialSubscription);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }
}
