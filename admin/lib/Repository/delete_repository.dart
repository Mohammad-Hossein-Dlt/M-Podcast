import 'package:admin/ApiException/api_exception.dart';
import 'package:admin/Data/delete_datasource.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class IDeleteDataRepository {
  Future<Either<String, bool>> deleteCategory(
    String mainGroupId,
    ValueNotifier progress,
    ValueNotifier error,
  );

  Future<Either<String, bool>> deleteDocument(
    String documentName,
    int documentId,
    ValueNotifier progress,
    ValueNotifier error,
  );

  Future<Either<String, bool>> userDeleteAcount({required String userName});

  Future<Either<String, bool>> deleteSubscription(
    String id,
    ValueNotifier progress,
    ValueNotifier error,
  );
  Future<Either<String, bool>> deleteDiscountCode(
    String id,
    ValueNotifier progress,
    ValueNotifier error,
  );
}

class DeleteDataRepository implements IDeleteDataRepository {
  final IDeleteDataRemote _datasource = locator.get();

  @override
  Future<Either<String, bool>> deleteCategory(
      String mainGroupId, ValueNotifier progress, ValueNotifier error) async {
    try {
      await _datasource.deleteCategory(mainGroupId, progress, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> deleteDocument(
    String documentName,
    int documentId,
    ValueNotifier progress,
    ValueNotifier error,
  ) async {
    try {
      await _datasource.deleteDocument(
          documentName, documentId, progress, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> userDeleteAcount(
      {required String userName}) async {
    try {
      await _datasource.userDeleteAcount(userName: userName);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> deleteSubscription(
      String id, ValueNotifier progress, ValueNotifier error) async {
    try {
      await _datasource.deleteSubscription(id, progress, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> deleteDiscountCode(
      String id, ValueNotifier progress, ValueNotifier error) async {
    try {
      await _datasource.deleteDiscountCode(id, progress, error);
      return right(true);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }
}
