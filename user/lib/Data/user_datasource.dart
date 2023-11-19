import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/ApiException/api_exception.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DataModel/data_model.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/User/User.dart';
import 'package:user/User/UserData.dart';

abstract class IUserDataRemote {
  Future<Map?> signIn({
    required String userName,
    required String password,
    required Function() saveData,
    bool showMessage,
  });
  Future<Map?> signInValidCode({
    required String userName,
    required Function() setTimer,
  });
  Future<Map?> signUp(
    String nameAndFamily,
    String userName,
    String password,
    Function() saveData,
  );
  Future<Map?> signUpValidCode({
    required String userName,
    required Function() setTimer,
  });
  Future<void> changeInfo(
    String token,
    String userName,
    String password,
    String nameAndFamily,
    String email,
    Function() saveData,
  );
  Future<Map?> changeUserNameValidCode(
    String userName,
    String newUserName,
    Function() setTimer,
  );
  Future<void> changeUserName(
    String userName,
    String newUserName,
    String validCode,
    Function() saveData,
  );
  Future<void> changePassword(
    String token,
    String userName,
    String password,
    String newassword,
    Function() saveData,
  );

  Future<Map?> likeDocument({required String token, required int documentId});

  Future<PageinationDataModel> getLiked(
    String token,
    int offset,
    String order,
  );
  Future<PageinationDataModel> getFavorites(
    String token,
    int offset,
    String order,
  );

  Future<bool> addDocumentToFavorites(
      {required String token, required int documentId});

  Future<bool> noting(
      {required String token, required String itemId, required int documentId});

  Future<NotesDataModel> getNotes(
    String token,
    int offset,
    String order,
  );
}

class UserDataRemote implements IUserDataRemote {
  static final Dio dio_ = locator.get();

  @override
  Future<Map?> signIn({
    required String userName,
    required String password,
    required Function() saveData,
    bool showMessage = true,
  }) async {
    try {
      var respons = await dio_.request(
        "user/login.php",
        queryParameters: {
          "UserName": userName,
          "Password": password,
        },
      );
      var data = jsonDecode(respons.data);
      if (showMessage) {
        Fluttertoast.showToast(
          msg: data["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER_RIGHT,
          backgroundColor: data["error"] ? red : const Color(0xff4BCB81),
          textColor: Colors.white,
        );
      }
      if (data["error"] == false) {
        userLogin(
          UserData(
            nameAndFamily: data["NameAndFamily"],
            phone: data["UserName"],
            password: data["Password"],
            token: data["Token"],
            email: data["Email"] ?? "",
            haveSubscription: data["haveSubscription"],
            subscription: double.parse(data["subscription"]),
            remainingSubscription: double.parse(data["remainingSubscription"]),
            haveSpecialSubscription: data["haveSpecialSubscription"],
          ),
        );
        saveData();
      }
      return data;
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<Map> signInValidCode({
    required String userName,
    required Function() setTimer,
  }) async {
    try {
      var respons = await dio_.request(
        "sms/send-sign-in-valid-code.php",
        queryParameters: {
          "UserName": userName,
        },
      );
      var data = jsonDecode(respons.data);
      // return {"validCode": "4555"};
      await setTimer();
      return data;
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<Map?> signUp(
    String nameAndFamily,
    String userName,
    String password,
    Function() saveData,
  ) async {
    try {
      var respons = await dio_.request(
        "user/sign-up.php",
        queryParameters: {
          "NameAndFamily": nameAndFamily,
          "UserName": userName,
          "Password": password,
        },
      );
      var data = jsonDecode(respons.data);
      Fluttertoast.showToast(
        msg: data["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: data["error"] ? red : const Color(0xff4BCB81),
        textColor: Colors.white,
      );
      if (data["error"] == false) {
        return await signIn(
            userName: userName, password: password, saveData: saveData);
      }
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
    return null;
  }

  @override
  Future<Map?> signUpValidCode(
      {required String userName, required Function() setTimer}) async {
    try {
      var respons = await dio_.request(
        "sms/send-sign-un-valid-code.php.php",
        queryParameters: {
          "UserName": userName,
        },
      );
      var data = jsonDecode(respons.data);
      await setTimer();
      return data;
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<PageinationDataModel> getFavorites(
    String token,
    int offset,
    String order,
  ) async {
    try {
      var respons = await dio_.request(
        "user/fetch-favorites.php",
        queryParameters: {
          "Token": token,
          "Offset": offset,
          "Order": order,
        },
      );
      var data = jsonDecode(respons.data);
      return PageinationDataModel(documents: data["data"], next: data["next"]);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<Map?> likeDocument(
      {required String token, required int documentId}) async {
    try {
      var respons = await dio_.request(
        "user/like.php",
        queryParameters: {
          "Token": token,
          "DocumentId": documentId,
        },
      );
      var data = jsonDecode(respons.data);
      return data;
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<PageinationDataModel> getLiked(
      String token, int offset, String order) async {
    try {
      var respons = await dio_.request(
        "user/fetch-likes.php",
        queryParameters: {
          "Token": token,
          "Offset": offset,
          "Order": order,
        },
      );
      var data = jsonDecode(respons.data);
      return PageinationDataModel(documents: data["data"], next: data["next"]);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<bool> addDocumentToFavorites(
      {required String token, required int documentId}) async {
    try {
      var respons = await dio_.request(
        "user/add-to-favorites.php",
        queryParameters: {
          "Token": token,
          "DocumentId": documentId,
        },
      );
      var data = jsonDecode(respons.data);
      return data["liked"] ?? false;
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<bool> noting(
      {required String token,
      required String itemId,
      required int documentId}) async {
    try {
      var respons = await dio_.post(
        "user/note.php",
        queryParameters: {
          "Token": token,
          "Note": itemId,
          "DocumentId": documentId,
        },
      );
      var data = jsonDecode(respons.data);
      return data["liked"] ?? false;
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<NotesDataModel> getNotes(
    String token,
    int offset,
    String order,
  ) async {
    try {
      var respons = await dio_.request(
        "user/fetch-notes.php",
        queryParameters: {
          "Token": token,
          "Offset": offset,
          "Order": order,
        },
      );

      var data = jsonDecode(respons.data);
      var notes = data["data"];
      return NotesDataModel(notes: notes, next: data["next"]);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> changeInfo(String token, String userName, String password,
      String nameAndFamily, String email, Function() saveData) async {
    try {
      var respons = await dio_.request(
        "user/change-info.php",
        queryParameters: {
          "Token": token,
          "NameAndFamily": nameAndFamily,
          "Email": email,
        },
      );
      var data = jsonDecode(respons.data);
      Fluttertoast.showToast(
        msg: data["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: data["error"] ? Colors.red : const Color(0xff4BCB81),
        textColor: Colors.white,
      );
      if (data["error"] == false) {
        await signIn(
          userName: userName,
          password: password,
          saveData: saveData,
          showMessage: false,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<Map?> changeUserNameValidCode(
    String userName,
    String newUserName,
    Function() function,
  ) async {
    try {
      var respons = await dio_.request(
        "sms/send-change-user-name-valid-code-sms.php",
        queryParameters: {
          "UserName": userName,
          "NewUserName": newUserName,
        },
      );
      var data = jsonDecode(respons.data);
      await function();
      return data;
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> changeUserName(String userName, String newUserName,
      String validCode, Function() saveData) async {
    try {
      var respons = await dio_.request(
        "user/change-user-name.php",
        queryParameters: {
          "UserName": userName,
          "NewUserName": newUserName,
          "ValidCode": validCode,
        },
      );
      var data = jsonDecode(respons.data);
      Fluttertoast.showToast(
        msg: data["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: data["error"] ? Colors.red : const Color(0xff4BCB81),
        textColor: Colors.white,
      );
      if (data["error"] == false) {
        await signIn(
            userName: newUserName,
            password: validCode,
            saveData: saveData,
            showMessage: false);
      }
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future<void> changePassword(String token, String userName, String password,
      String newassword, Function() saveData) async {
    try {
      var respons = await dio_.request(
        "user/change-password.php",
        queryParameters: {
          "Token": token,
          "Password": password,
          "NewPassword": newassword,
        },
      );
      var data = jsonDecode(respons.data);
      Fluttertoast.showToast(
        msg: data["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: data["error"] ? Colors.red : const Color(0xff4BCB81),
        textColor: Colors.white,
      );
      if (data["error"] == false) {
        await signIn(
            userName: userName,
            password: newassword,
            saveData: saveData,
            showMessage: false);
      }
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }
}
