import 'dart:async';

import 'package:user/Bloc/CategoriesBloc/categories_event.dart';
import 'package:user/Bloc/CategoriesBloc/categories_state.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/Repository/get_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final IGetDataRepository rep = locator.get();
  CategoriesBloc() : super(CategoriesInitState()) {
    on<GetCategoriesData>((event, emit) async {
      emit(CategoriesLoadingState());
      var data = await rep.getCategories();
      await Future.delayed(
        Duration(seconds: 1),
        () {
          emit(CategoriesDataState(data: data));
        },
      );
    });
  }
}
