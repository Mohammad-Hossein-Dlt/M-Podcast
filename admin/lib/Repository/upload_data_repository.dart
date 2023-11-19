import 'package:admin/ApiException/api_exception.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/Data/upload_datasource.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Document/DocumentModel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class IUploadDataRepository {
  Future<Either<String, bool>> checkDocumentName(
    String document,
  );

  Future<Either<String, bool>> uploadDocument(
    DocumentModel document,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<Either<String, bool>> uppdateDocument(
    EditDocumentDataModel document,
    String newName,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<Either<String, bool>> checkCategoryName(String name);
  Future<Either<String, bool>> uploadCategories(
      SingleCategoryDataModel singleCategoryDataModel,
      ValueNotifier progreess,
      ValueNotifier error);

  Future<void> reorderCategories(List groupsId);

  Future<Either<String, bool>> uploadHomeData(
    List main,
    List removeImages,
    ValueNotifier progreess,
    ValueNotifier error,
  );

  Future<Either<String, bool>> uploadCategoryPageData(
    String id,
    List page,
    List removeImages,
    ValueNotifier progreess,
    ValueNotifier error,
  );
  Future<Either<String, bool>> uploadNotification(
    NotificationDataModel notificationData,
    ValueNotifier progreess,
    ValueNotifier error,
  );
  Future<Either<String, bool>> sendMessage(
    String messageText,
    ValueNotifier progreess,
    ValueNotifier error,
  );
  Future<Either<String, bool>> uploadAboutUs(
    List aboutUs,
    ValueNotifier progreess,
    ValueNotifier error,
  );
  Future<Either<String, bool>> uploadTermsAndConditions(
    List termsAndConditions,
    ValueNotifier progreess,
    ValueNotifier error,
  );
  Future<Either<String, bool>> uploadContactUs(
    List contactUs,
    ValueNotifier progreess,
    ValueNotifier error,
  );
  Future<Either<String, bool>> uploadSubscription(
      SingleSubscriptionDataModel singleCategoryDataModel,
      ValueNotifier progreess,
      ValueNotifier error);
  Future<Either<String, bool>> uploadDiscountCode(
      SingleDiscountCodeDataModel singleCategoryDataModel,
      ValueNotifier progreess,
      ValueNotifier error);
}

class UploadDataRepository implements IUploadDataRepository {
  final IUploadDataRemote _datasource = locator.get();

  @override
  Future<Either<String, bool>> checkDocumentName(String document) async {
    try {
      bool data = await _datasource.checkDocumentName(document);
      return right(data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> checkCategoryName(
    String name,
  ) async {
    try {
      return right(await _datasource.checkCategoryName(name));
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uploadCategories(
      SingleCategoryDataModel singleCategoryDataModel,
      ValueNotifier progreess,
      ValueNotifier error) async {
    try {
      await _datasource.uploadCategories(
          singleCategoryDataModel, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<void> reorderCategories(List groupsId) async {
    try {
      await _datasource.reorderCategories(groupsId);
    } on ApiException {
      Fluttertoast.showToast(
        msg: "خطایی رخ داد",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Future<Either<String, bool>> uploadCategoryPageData(
    String id,
    List page,
    List removeImages,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      await _datasource.uploadCategoryPageData(
          id, page, removeImages, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uploadDocument(
    DocumentModel document,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      await _datasource.uploadDocument(document, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uploadHomeData(
    List main,
    List removeImages,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      await _datasource.uploadHomeData(main, removeImages, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uppdateDocument(
    EditDocumentDataModel document,
    String newName,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      await _datasource.uppdateDocument(document, newName, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uploadNotification(
    NotificationDataModel notificationData,
    ValueNotifier progreess,
    ValueNotifier error,
  ) async {
    try {
      await _datasource.uploadNotification(notificationData, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uploadAboutUs(
      List aboutUs, ValueNotifier progreess, ValueNotifier error) async {
    try {
      await _datasource.uploadAboutUs(aboutUs, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uploadTermsAndConditions(List termsAndConditions,
      ValueNotifier progreess, ValueNotifier error) async {
    try {
      await _datasource.uploadTermsAndConditions(
          termsAndConditions, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uploadContactUs(
      List contactUs, ValueNotifier progreess, ValueNotifier error) async {
    try {
      await _datasource.uploadContactUs(contactUs, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> sendMessage(
      String messageText, ValueNotifier progreess, ValueNotifier error) async {
    try {
      await _datasource.sendMessage(messageText, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uploadSubscription(
      SingleSubscriptionDataModel singleCategoryDataModel,
      ValueNotifier progreess,
      ValueNotifier error) async {
    try {
      await _datasource.uploadSubscription(
          singleCategoryDataModel, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> uploadDiscountCode(
      SingleDiscountCodeDataModel singleCategoryDataModel,
      ValueNotifier progreess,
      ValueNotifier error) async {
    try {
      await _datasource.uploadDiscountCode(
          singleCategoryDataModel, progreess, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }
}
