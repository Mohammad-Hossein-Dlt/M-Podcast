import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Bloc/HomeBloc/home_event.dart';
import 'package:admin/Bloc/HomeBloc/home_state.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IGetDataRepository rep = locator.get();
  HomeBloc() : super(HomeInitState()) {
    on<GetHomeData>((event, emit) async {
      emit(HomeLoadingState());
      var data = await rep.mainData();
      emit(HomeDataState(data: data));
    });

    on<HomeDefaultEvent>((event, emit) async {
      emit(HomeDefaultState());
    });
  }
}
