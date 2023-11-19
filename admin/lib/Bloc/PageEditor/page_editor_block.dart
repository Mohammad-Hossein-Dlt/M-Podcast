import 'package:admin/Bloc/PageEditor/page_editor_event.dart';
import 'package:admin/Bloc/PageEditor/page_editor_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:admin/Repository/upload_data_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageEditorBloc extends Bloc<PageEditorEvent, PageEditorState> {
  IUploadDataRepository uploadRep = locator.get();
  IGetDataRepository getRep = locator.get();
  ValueNotifier uploadProgress = ValueNotifier([false, false, false]);
  ValueNotifier error = ValueNotifier(false);
  PageEditorBloc() : super(PageEditorInitState()) {
    on<PageEditorDefaultEvent>((event, emit) async {
      emit(PageEditorDefaultState());
    });
    // ------------------------------------------------------------
    on<GetHomePageDataEvent>((event, emit) async {
      emit(PageEditorLoadingState());
      var data = await getRep.mainData();
      emit(HomePageEditorDataState(data: data));
    });

    on<UploadHomePageEvent>((event, emit) async {
      uploadProgress = ValueNotifier([false, false, false]);
      error = ValueNotifier(false);
      emit(UploadPageState(uploadProgress: uploadProgress, error: error));
      await uploadRep.uploadHomeData(
          event.page, event.removeImages, uploadProgress, error);
    });
    // ------------------------------------------------------------
    on<GetCategoryPageDataEvent>((event, emit) async {
      emit(PageEditorLoadingState());

      var getCategories = await getRep.getCategories();
      bool error = false;
      List categories = [];
      getCategories.fold((l) {
        error = true;
      }, (r) {
        categories = r.categoriesList;
      });

      if (error) {
        emit(PageEditorErrorState());
      } else {
        var data = await getRep.getPage(mainGroupId: event.mainGroupId);
        emit(CategoryPageEditorDataState(data: data, categories: categories));
      }
    });

    on<UploadCategoryPageEvent>((event, emit) async {
      uploadProgress = ValueNotifier([false, false, false]);
      error = ValueNotifier(false);
      emit(UploadPageState(uploadProgress: uploadProgress, error: error));

      await uploadRep.uploadCategoryPageData(
          event.id, event.page, event.removeImages, uploadProgress, error);
    });
    // ------------------------------------------------------------
    on<InitUploadPageEvent>((event, emit) async {
      emit(InitUploadPageState());
    });
  }
}
