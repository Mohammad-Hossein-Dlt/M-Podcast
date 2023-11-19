import 'dart:convert';
import 'dart:io';
import 'package:admin/ApiException/api_exception.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Document/DocumentModel.dart';
import 'package:admin/paths.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

abstract class IUploadDataRemote {
  Future<bool> checkDocumentName(String name);

  Future<void> uploadDocument(
    DocumentModel document,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<void> uppdateDocument(
    EditDocumentDataModel document,
    String newName,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<bool> checkCategoryName(String name);

  Future<void> uploadCategories(
    SingleCategoryDataModel singleCategoryDataModel,
    ValueNotifier progreess,
    ValueNotifier error,
  );
  Future<void> reorderCategories(
    List groupsId,
  );

  Future<void> uploadHomeData(
    List main,
    List removeImages,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<void> uploadCategoryPageData(
    String id,
    List page,
    List removeImages,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<void> uploadNotification(
    NotificationDataModel notificationData,
    ValueNotifier progreess,
    ValueNotifier error,
  );
  Future<void> sendMessage(
    String messageText,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<void> uploadTermsAndConditions(
    List termsAndConditions,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<void> uploadAboutUs(
    List aboutUs,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<void> uploadContactUs(
    List aboutUs,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<void> uploadSubscription(
    SingleSubscriptionDataModel singleSubscriptionDataModel,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<void> uploadDiscountCode(
    SingleDiscountCodeDataModel singleSubscriptionDataModel,
    ValueNotifier progreess,
    ValueNotifier error,
  );
}

class UploadDataRemote implements IUploadDataRemote {
  static final Dio dio_ = locator.get();

  @override
  Future<bool> checkDocumentName(String name) async {
    try {
      var register = await dio_.request(
        "document/check-document-name.php",
        queryParameters: {
          "Name": name,
        },
      );
      var registerData = jsonDecode(register.data);
      if (registerData["error"] == false) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadDocument(
    DocumentModel document,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      FormData documentJson = FormData.fromMap(
        {
          "Name": document.name,
          "MainImage": document.mainImage,
          "Body": MultipartFile.fromString(jsonEncode(document.body)),
          "AudioList": MultipartFile.fromString(jsonEncode(document.audios)),
          "isSubscription": document.isSubscription,
          "Labels": MultipartFile.fromString(jsonEncode(document.labels)),
          "MainGroup": document.category["Group"],
          "SubGroup": document.category["SubGroup"],
        },
      );
      var register = await dio_.post(
        "document/insert-document.php",
        data: documentJson,
      );
      var registerData = jsonDecode(register.data);
      if (registerData["error"] == false) {
        progreess.value = [true, false, false];
        List filse = AppDataDirectory.documentPath(document.name).listSync();
        for (var e in filse) {
          FormData file = FormData.fromMap({
            "file": await MultipartFile.fromFile(e.path,
                filename: basename(e.path)),
          });
          await dio_.post(
            "document/upload-files.php",
            data: file,
            queryParameters: {"folder": document.name},
          );
        }
        progreess.value = [true, true, false];
        register = await dio_.request(
          "document/delete-old-files.php",
          queryParameters: {
            "name": document.name,
            "list": json.encode(document.deletedFiles)
          },
        );
        registerData = jsonDecode(register.data);
        progreess.value = [true, true, true];
      }
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uppdateDocument(
    EditDocumentDataModel document,
    String newName,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      FormData documentJson = FormData.fromMap(
        {
          "NewName": newName,
          "Name": document.name,
          "MainImage": document.mainimage,
          "Body": MultipartFile.fromString(jsonEncode(document.body)),
          "AudioList": MultipartFile.fromString(jsonEncode(document.audioList)),
          "isSubscription": document.isSubscription,
          "Labels": MultipartFile.fromString(jsonEncode(document.labels)),
          "MainGroup": document.groupId,
          "SubGroup": document.subGroupId,
        },
      );
      var register = await dio_.post(
        "document/update-document.php",
        data: documentJson,
      );
      var registerData = jsonDecode(register.data);
      if (registerData["error"] == false) {
        progreess.value = [true, false, false];
        List filse = AppDataDirectory.documentOnlineEdit().listSync();
        for (var e in filse) {
          FormData file = FormData.fromMap({
            "file": await MultipartFile.fromFile(e.path,
                filename: basename(e.path)),
          });
          await dio_.post(
            "document/upload-files.php",
            data: file,
            queryParameters: {"folder": document.name},
          );
        }
        progreess.value = [true, true, false];
        print(document.deletedFiles);
        register = await dio_.request(
          "document/delete-old-files.php",
          queryParameters: {
            "name": document.name,
            "list": json.encode(document.deletedFiles)
          },
        );
        registerData = jsonDecode(register.data);
        progreess.value = [true, true, true];
      }
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<bool> checkCategoryName(String name) async {
    try {
      var register = await dio_.request(
        "categories/check-category-name.php",
        queryParameters: {
          "Name": name,
        },
      );
      var registerData = jsonDecode(register.data);
      if (registerData["error"] == false) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadCategories(
    SingleCategoryDataModel singleCategoryDataModel,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      await dio_.request(
        "categories/insert-category.php",
        queryParameters: {
          "GroupName": singleCategoryDataModel.name,
          "NewGroupName": singleCategoryDataModel.newName,
          "SubGroups": jsonEncode(singleCategoryDataModel.subGroups),
          "Image": singleCategoryDataModel.image,
          "showInHomePage": singleCategoryDataModel.showinhomepage,
          "SpecialGroup": singleCategoryDataModel.specialGroup,
        },
      ).then((value) {
        progreess.value = [true, false, false];
      });
      // --------------------------------------------------
      if (await File(
              "${AppDataDirectory.categories().path}/${singleCategoryDataModel.image}")
          .exists()) {
        FormData file = FormData.fromMap({
          "file": await MultipartFile.fromFile(
              "${AppDataDirectory.categories().path}/${singleCategoryDataModel.image}",
              filename: singleCategoryDataModel.image),
        });
        await dio_.post(
          "categories/upload-category-image.php",
          data: file,
        );
      }
      progreess.value = [true, true, false];

      // --------------------------------------------------
      await dio_.request(
        "categories/remove-category-image.php",
        queryParameters: {
          "Name": singleCategoryDataModel.prevImage,
        },
      ).then((value) {
        progreess.value = [true, true, true];
      });
      // --------------------------------------------------
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;

      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> reorderCategories(
    List groupsId,
  ) async {
    try {
      await dio_.request(
        "categories/reorder-groups.php",
        queryParameters: {
          "GroupsId": jsonEncode(groupsId),
        },
      ).then((value) {
        Fluttertoast.showToast(
          msg: "ترتیب جدید گروه ها با موفقیت اعمال شد",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER_RIGHT,
          backgroundColor: const Color(0xff4BCB81),
          textColor: Colors.white,
        );
      });
      // --------------------------------------------------
    } on DioError catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadHomeData(
    List main,
    List removeImages,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      FormData mainpage = FormData.fromMap({
        "MainPage": MultipartFile.fromString(jsonEncode(main)),
      });
      var register = await dio_.post(
        "pages/insert-mainpage.php",
        data: mainpage,
      );

      var registerData = jsonDecode(register.data);
      if (registerData["error"] == false) {
        progreess.value = [true, false, false];
        List filse = AppDataDirectory.mainpage().listSync();
        for (var e in filse) {
          FormData formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(e.path,
                filename: basename(e.path)),
          });
          register = await dio_.post(
            "pages/upload-banners.php",
            data: formData,
          );
        }
        progreess.value = [true, true, false];

        register = await dio_.request(
          "pages/remove-old-banners.php",
          queryParameters: {"list": json.encode(removeImages)},
        );

        progreess.value = [true, true, true];
      }
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadCategoryPageData(
    String id,
    List page,
    List removeImages,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      FormData pageJson = FormData.fromMap({
        "MainGroupId": id,
        "Page": MultipartFile.fromString(jsonEncode(page)),
      });
      var register = await dio_.post(
        "pages/insert-grouppage.php",
        data: pageJson,
      );
      var registerData = jsonDecode(register.data);
      if (registerData["error"] == false) {
        progreess.value = [true, false, false];
        List filse = AppDataDirectory.mainpage().listSync();
        for (var e in filse) {
          FormData formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(e.path,
                filename: basename(e.path)),
          });
          await dio_.post(
            "pages/upload-banners.php",
            data: formData,
          );
        }
        progreess.value = [true, true, false];
        register = await dio_.request(
          "pages/remove-old-banners.php",
          queryParameters: {"list": json.encode(removeImages)},
        );

        progreess.value = [true, true, true];
      }
    } on DioError catch (e) {
      error.value = true;

      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;

      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadNotification(
    NotificationDataModel notificationData,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      await dio_.request(
        "notification/set-notification.php",
        queryParameters: {
          "NotificationData": json.encode({
            "message": notificationData.message,
            "enable": notificationData.enable,
          }),
        },
      );
      progreess.value = true;
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;

      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadAboutUs(
      List aboutUs, ValueNotifier progreess, ValueNotifier error) async {
    try {
      FormData aboutUsData = FormData.fromMap(
        {
          "AboutUs": MultipartFile.fromString(json.encode(aboutUs)),
        },
      );
      await dio_.post(
        "info/set-about-us.php",
        data: aboutUsData,
      );
      progreess.value = true;
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;

      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadTermsAndConditions(
    List termsAndConditions,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      FormData termsAndConditionsData = FormData.fromMap(
        {
          "TermsAndConditions":
              MultipartFile.fromString(json.encode(termsAndConditions)),
        },
      );
      await dio_.post(
        "info/set-terms-and-conditions.php",
        data: termsAndConditionsData,
      );
      progreess.value = true;
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;

      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadContactUs(
    List termsAndConditions,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      FormData termsAndConditionsData = FormData.fromMap(
        {
          "ContactUs":
              MultipartFile.fromString(json.encode(termsAndConditions)),
        },
      );
      await dio_.post(
        "info/set-contact-us.php",
        data: termsAndConditionsData,
      );
      progreess.value = true;
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;

      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> sendMessage(
      String messageText, ValueNotifier progreess, ValueNotifier error) async {
    try {
      await dio_.request(
        "sms/send-sms.php",
        queryParameters: {
          "Message": messageText,
        },
      );
      progreess.value = true;
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;

      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadSubscription(
      SingleSubscriptionDataModel singleSubscriptionDataModel,
      ValueNotifier progreess,
      ValueNotifier error) async {
    try {
      singleSubscriptionDataModel.id != null
          ? await dio_.request(
              "subscription/create-subscription.php",
              queryParameters: {
                "Title": singleSubscriptionDataModel.title,
                "Price": singleSubscriptionDataModel.price,
                "Discount": int.parse(singleSubscriptionDataModel.discount),
                "Period": int.parse(singleSubscriptionDataModel.period),
                "SpecialSubscription":
                    singleSubscriptionDataModel.specialSubscription,
                "DiscountCodeApply":
                    singleSubscriptionDataModel.discountCodeApply,
                "Id": singleSubscriptionDataModel.id,
              },
            ).then((value) {
              progreess.value = true;
            })
          : await dio_.request(
              "subscription/create-subscription.php",
              queryParameters: {
                "Title": singleSubscriptionDataModel.title,
                "Price": singleSubscriptionDataModel.price,
                "Discount": int.parse(singleSubscriptionDataModel.discount),
                "Period": int.parse(singleSubscriptionDataModel.period),
                "SpecialSubscription":
                    singleSubscriptionDataModel.specialSubscription,
                "DiscountCodeApply":
                    singleSubscriptionDataModel.discountCodeApply,
              },
            ).then((value) {
              progreess.value = true;
            });
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;

      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> uploadDiscountCode(
      SingleDiscountCodeDataModel singleSubscriptionDataModel,
      ValueNotifier progreess,
      ValueNotifier error) async {
    try {
      singleSubscriptionDataModel.id != null
          ? await dio_.request(
              "subscription/create-discountcode.php",
              queryParameters: {
                "Code": singleSubscriptionDataModel.code,
                "NormalPercent": singleSubscriptionDataModel.normalPercent,
                "SpecialPercent": singleSubscriptionDataModel.specialPercent,
                "Id": singleSubscriptionDataModel.id,
              },
            ).then((value) {
              progreess.value = true;
            })
          : await dio_.request(
              "subscription/create-discountcode.php",
              queryParameters: {
                "Code": singleSubscriptionDataModel.code,
                "NormalPercent": singleSubscriptionDataModel.normalPercent,
                "SpecialPercent": singleSubscriptionDataModel.specialPercent,
              },
            ).then((value) {
              progreess.value = true;
            });
    } on DioError catch (e) {
      error.value = true;
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      error.value = true;

      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }
}
