import 'package:admin/Bloc/DashboardBloc/dashboard_event.dart';
import 'package:admin/Bloc/DashboardBloc/dashboard_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final IGetDataRepository rep = locator.get();
  DashboardBloc() : super(DashboardInitState()) {
    on<MonitoringEvent>((event, emit) async {
      emit(DashboardLoadingState());
      var data = await rep.monitoring();
      emit(MonitoringState(data: data));
    });
  }
}
