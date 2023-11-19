import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/ApiException/api_exception.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/Data/user_datasource.dart';
import 'package:user/DataModel/data_model.dart';
import 'package:user/Dio/base_dio.dart';

abstract class IUserDataRepository {
  Future<Map?> signIn(
    String userName,
    String password,
    Function() saveData,
  );
  Future<Map?> signInValidCode(
    String userName,
    Function() setTimer,
  );
  Future<Map?> signUp(
    String nameAndFamily,
    String userName,
    String password,
    Function() saveData,
  );
  Future<Map?> signUpValidCode(
    String userName,
    Function() setTimer,
  );
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
  Future<Either<String, Map?>> likeDocument(
      {required String token, required int documentId});

  Future<Either<String, PageinationDataModel>> getLiked(
    String token,
    int offset,
    String order,
  );
  Future<Either<String, PageinationDataModel>> getFavorites(
    String token,
    int offset,
    String order,
  );
  Future<Either<String, bool>> addDocumentToFavorites(
      {required String token, required int documentId});

  Future<Either<String, bool>> noting(
      {required String token, required String itemId, required int documentId});

  Future<Either<String, NotesDataModel>> getNotes(
    String token,
    int offset,
    String order,
  );
}

class UserDataRepository implements IUserDataRepository {
  final IUserDataRemote _userDataSource = locator.get();

  @override
  Future<Map?> signIn(
    String userName,
    String password,
    Function() saveData,
  ) async {
    try {
      return await _userDataSource.signIn(
          userName: userName, password: password, saveData: saveData);
    } on ApiException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
    }
    return null;
  }

  @override
  Future<Map?> signInValidCode(
    String userName,
    Function() setTimer,
  ) async {
    try {
      return await _userDataSource.signInValidCode(
          userName: userName, setTimer: setTimer);
    } on ApiException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
      return null;
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
      return await _userDataSource.signUp(
          nameAndFamily, userName, password, saveData);
    } on ApiException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
    }
    return null;
  }

  @override
  Future<Map?> signUpValidCode(String userName, Function() setTimer) async {
    try {
      return await _userDataSource.signUpValidCode(
          userName: userName, setTimer: setTimer);
    } on ApiException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  @override
  Future<Either<String, Map?>> likeDocument(
      {required String token, required int documentId}) async {
    try {
      Map? like = await _userDataSource.likeDocument(
          token: token, documentId: documentId);
      return right(like);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, PageinationDataModel>> getLiked(
      String userName, int offset, String order) async {
    try {
      return right(await _userDataSource.getLiked(userName, offset, order));
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, PageinationDataModel>> getFavorites(
    String userName,
    int offset,
    String order,
  ) async {
    try {
      return right(await _userDataSource.getFavorites(userName, offset, order));
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> addDocumentToFavorites(
      {required String token, required int documentId}) async {
    try {
      bool like = await _userDataSource.addDocumentToFavorites(
          token: token, documentId: documentId);
      return right(like);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, bool>> noting(
      {required String token,
      required String itemId,
      required int documentId}) async {
    try {
      bool like = await _userDataSource.noting(
          token: token, itemId: itemId, documentId: documentId);
      return right(like);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, NotesDataModel>> getNotes(
    String userName,
    int offset,
    String order,
  ) async {
    try {
      return right(await _userDataSource.getNotes(userName, offset, order));
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<void> changeInfo(String token, String userName, String password,
      String nameAndFamily, String email, Function() saveData) async {
    try {
      await _userDataSource.changeInfo(
          token, userName, password, nameAndFamily, email, saveData);
    } on ApiException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Future<Map?> changeUserNameValidCode(
      String userName, String newUserName, Function() setTimer) async {
    try {
      return await _userDataSource.changeUserNameValidCode(
          userName, newUserName, setTimer);
    } on ApiException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  @override
  Future<void> changeUserName(String userName, String newUserName,
      String validCode, Function() saveData) async {
    try {
      await _userDataSource.changeUserName(
          userName, newUserName, validCode, saveData);
    } on ApiException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Future<void> changePassword(String token, String userName, String password,
      String newassword, Function() saveData) async {
    try {
      await _userDataSource.changePassword(
          token, userName, password, newassword, saveData);
    } on ApiException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
    }
  }
}
