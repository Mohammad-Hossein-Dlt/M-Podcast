import 'dart:convert';

import 'package:admin/Dio/base_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ApiException/api_exception.dart';
import '../Constants/colors.dart';

abstract class IDeleteDataRemote {
  Future deleteCategory(
    String mainGroupId,
    ValueNotifier progress,
    ValueNotifier error,
  );
  Future deleteDocument(
    String documentName,
    int documentId,
    ValueNotifier progress,
    ValueNotifier error,
  );

  Future userDeleteAcount({required String userName});

  Future deleteSubscription(
    String id,
    ValueNotifier progress,
    ValueNotifier error,
  );
  Future deleteDiscountCode(
    String id,
    ValueNotifier progress,
    ValueNotifier error,
  );
}

class DeleteDataRemote implements IDeleteDataRemote {
  final Dio _dio = locator.get();

  @override
  Future deleteDocument(
    String documentName,
    int documentId,
    ValueNotifier progress,
    ValueNotifier error,
  ) async {
    try {
      await _dio.delete(
        "document/delete-document.php",
        queryParameters: {
          "Name": documentName,
          "Id": documentId,
        },
      ).then((value) {
        progress.value = true;
      });
      // ------------------------------------------------
      Fluttertoast.showToast(
        msg: "سند $documentName با موفقیت حذف شد",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: const Color(0xff4BCB81),
        textColor: Colors.white,
      );
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
  Future deleteCategory(
    String mainGroupId,
    ValueNotifier progress,
    ValueNotifier error,
  ) async {
    try {
      await _dio.delete(
        "categories/delete-category.php",
        queryParameters: {
          "MainGroupId": mainGroupId,
        },
      ).then((value) {
        progress.value = true;
      });
      // ------------------------------------------------
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
  Future userDeleteAcount({required String userName}) async {
    try {
      var register = await _dio.request(
        "user/delete-user-account.php",
        queryParameters: {
          "UserName": userName,
          "AdminPassword": "GX6P3TdrHCb^q#Ln",
        },
      );
      var registerData = jsonDecode(register.data);
      Fluttertoast.showToast(
        msg: registerData["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: registerData["error"] ? red : const Color(0xff4BCB81),
        textColor: Colors.white,
      );
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: "خطا در برقراری ارتباط",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: const Color(0xff4BCB81),
        textColor: Colors.white,
      );
      throw ApiException(
          code: e.response?.statusCode, message: "خطا در برقراری ارتباط");
    } catch (ex) {
      Fluttertoast.showToast(
        msg: "Unknown Error!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: const Color(0xff4BCB81),
        textColor: Colors.white,
      );
      throw ApiException(code: 0, message: "Unknown Error!");
    }
  }

  @override
  Future deleteSubscription(
      String id, ValueNotifier progress, ValueNotifier error) async {
    try {
      await _dio.delete(
        "subscription/delete-subscription.php",
        queryParameters: {
          "Id": id,
        },
      ).then((value) {
        progress.value = true;
      });
      // ------------------------------------------------
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
  Future deleteDiscountCode(
      String id, ValueNotifier progress, ValueNotifier error) async {
    try {
      await _dio.delete(
        "subscription/delete-discountcode.php",
        queryParameters: {
          "Id": id,
        },
      ).then((value) {
        progress.value = true;
      });
      // ------------------------------------------------
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
