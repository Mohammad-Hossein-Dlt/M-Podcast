import 'package:admin/Bloc/EditCategoriesBloc/edit_categories_event.dart';
import 'package:admin/Bloc/EditCategoriesBloc/edit_categories_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/delete_repository.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:admin/Repository/upload_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCategoriesBloc
    extends Bloc<EditCategoriesEvent, EditCategoriesState> {
  final IGetDataRepository getRep = locator.get();
  IUploadDataRepository uploadRep = locator.get();
  IDeleteDataRepository deleteRep = locator.get();
  ValueNotifier progress = ValueNotifier([false, false, false]);
  ValueNotifier error = ValueNotifier(false);
  EditCategoriesBloc() : super(EditCategoriesInitState()) {
    on<GetCategoriesEvent>((event, emit) async {
      emit(CategoriesDataLoadingState());
      var data = await getRep.getCategories();
      emit(CategoriesDataState(data: data));
    });

    on<GetSingleCategoryDataEvent>((event, emit) async {
      emit(CategoriesDataLoadingState());
      var data = await getRep.getSingleCategories(event.mainGroupId);
      emit(SingleCategoryDataState(data: data));
    });

    on<SingleCategoriesDefaultEvent>((event, emit) async {
      emit(SingleCategoriesDefaultState());
    });
    on<CategoryInitUploadEvent>((event, emit) async {
      error = ValueNotifier(false);
      progress = ValueNotifier([false, false, false]);
      emit(InitUploadState());
      var data = await uploadRep.checkCategoryName(event.name);
      emit(CategoryReadyUploadState(data: data));
    });
    on<CategoryUploadEvent>((event, emit) async {
      emit(CategoryUploadState(uploadProgress: progress, error: error));
      await uploadRep.uploadCategories(
          event.singleCategoryDataModel, progress, error);
    });

    on<CategoriyDeleteEvent>((event, emit) async {
      progress = ValueNotifier(false);
      emit(CategoryDeleteState(uploadProgress: progress, error: error));
      await deleteRep.deleteCategory(event.mainGroupId, progress, error);
    });

    on<ReorderCategoriesEvent>((event, emit) async {
      emit(CategoriesDataLoadingState());
      await uploadRep.reorderCategories(event.groupsId);
      var data = await getRep.getCategories();
      emit(CategoriesDataState(data: data));
    });
  }
}
