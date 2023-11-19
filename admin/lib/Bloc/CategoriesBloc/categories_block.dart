import 'package:admin/Bloc/CategoriesBloc/categories_event.dart';
import 'package:admin/Bloc/CategoriesBloc/categories_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final IGetDataRepository rep = locator.get();
  CategoriesBloc() : super(CategoriesInitState()) {
    on<GetCategoriesData>((event, emit) async {
      emit(CategoriesLoadingState());
      var data = await rep.getCategories();
      emit(CategoriesDataState(data: data));
    });
  }
}
