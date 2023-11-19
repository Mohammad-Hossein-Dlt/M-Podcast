import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class EditCategoriesState {}

class EditCategoriesInitState implements EditCategoriesState {}

class CategoriesDataLoadingState implements EditCategoriesState {}

class SingleCategoriesDefaultState implements EditCategoriesState {}

class CategoriesDataState implements EditCategoriesState {
  Either<String, CategoriesDataModel> data;
  CategoriesDataState({required this.data});
}

class SingleCategoryDataState implements EditCategoriesState {
  Either<String, SingleCategoryDataModel> data;
  SingleCategoryDataState({required this.data});
}

class InitUploadState implements EditCategoriesState {}

class CategoryReadyUploadState implements EditCategoriesState {
  Either<String, bool> data;
  CategoryReadyUploadState({required this.data});
}

class CategoryUploadState implements EditCategoriesState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  CategoryUploadState({required this.uploadProgress, required this.error});
}

class CategoryDeleteState implements EditCategoriesState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  CategoryDeleteState({required this.uploadProgress, required this.error});
}
