import 'package:admin/Data/delete_datasource.dart';
import 'package:admin/Data/getdata_datasource.dart';
import 'package:admin/Data/upload_datasource.dart';
import 'package:admin/Repository/delete_repository.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:admin/Repository/upload_data_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

var locator = GetIt.instance;

Future<void> getItInit() async {
  locator.registerSingleton<Dio>(
      Dio(BaseOptions(baseUrl: "http://mhdlt.ir/app/")));

  locator.registerFactory<IGetDataRemote>(() => GetDataRemote());
  locator.registerFactory<IGetDataRepository>(() => GetDataRepository());

  locator.registerFactory<IUploadDataRemote>(() => UploadDataRemote());
  locator.registerFactory<IUploadDataRepository>(() => UploadDataRepository());

  locator.registerFactory<IDeleteDataRemote>(() => DeleteDataRemote());
  locator.registerFactory<IDeleteDataRepository>(() => DeleteDataRepository());
}
