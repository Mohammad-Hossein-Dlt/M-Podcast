import 'dart:async';

import 'package:user/Bloc/CategoriesPageBloc/categories_page_event.dart';
import 'package:user/Bloc/CategoriesPageBloc/categories_page_state.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/Repository/get_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPageBloc
    extends Bloc<CategoriesPageEvent, CategoriesPageState> {
  final IGetDataRepository rep = locator.get();
  CategoriesPageBloc() : super(CategoriesPageInitState()) {
    on<GetCategoriesPageData>((event, emit) async {
      emit(CategoriesPageLoadingState());
      var data = await rep.getPage(mainGroupId: event.mainGroupId);
      await Future.delayed(
        Duration(seconds: 1),
        () {
          emit(CategoriesPageDataState(data: data));
        },
      );
    });
  }
}
