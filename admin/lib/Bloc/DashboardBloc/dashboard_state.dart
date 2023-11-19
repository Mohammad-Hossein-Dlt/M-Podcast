import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardState {}

class DashboardInitState implements DashboardState {}

class DashboardLoadingState implements DashboardState {}

class MonitoringState implements DashboardState {
  Either<String, Monitoring> data;
  MonitoringState({required this.data});
}
