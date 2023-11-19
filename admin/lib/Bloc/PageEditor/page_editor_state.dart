import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class PageEditorState {}

class PageEditorInitState implements PageEditorState {}

class PageEditorDefaultState implements PageEditorState {}

class PageEditorLoadingState implements PageEditorState {}

class HomePageEditorDataState implements PageEditorState {
  Either<String, HomeDataModel> data;
  HomePageEditorDataState({required this.data});
}

class CategoryPageEditorDataState implements PageEditorState {
  Either<String, CategoryPageDataModel> data;
  List categories;
  CategoryPageEditorDataState({required this.data, required this.categories});
}

class InitUploadPageState implements PageEditorState {}

class UploadPageState implements PageEditorState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  UploadPageState({required this.uploadProgress, required this.error});
}

class PageEditorErrorState implements PageEditorState {}
