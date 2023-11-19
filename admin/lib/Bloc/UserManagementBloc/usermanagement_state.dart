import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class UserManagementState {}

class UserManagementInitState implements UserManagementState {}

class UserManagementLoadingState implements UserManagementState {}

class UserInfoDefaultState implements UserManagementState {
  UserManagementS state;
  Widget onReload;
  UserInfoDefaultState({required this.state, required this.onReload});
}

class UserInfoDataState implements UserManagementState {
  Either<String, UserDataModel> data;
  UserManagementS state;
  UserInfoDataState({required this.data, required this.state});
}

enum UserManagementS { default_, deleteUser }
