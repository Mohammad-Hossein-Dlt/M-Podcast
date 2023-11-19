import 'package:user/Data/getdata_datasource.dart';
import 'package:user/Data/user_datasource.dart';
import 'package:user/Repository/get_data_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:user/Repository/user_data_repository.dart';

var locator = GetIt.instance;

Future<void> getItInit() async {
  locator.registerSingleton<Dio>(
      Dio(BaseOptions(baseUrl: "http://mhdlt.ir/app/")));

  locator.registerFactory<IGetDataRemote>(() => GetDataRemote());
  locator.registerFactory<IGetDataRepository>(() => GetDataRepository());

  locator.registerFactory<IUserDataRemote>(() => UserDataRemote());
  locator.registerFactory<IUserDataRepository>(() => UserDataRepository());
}
