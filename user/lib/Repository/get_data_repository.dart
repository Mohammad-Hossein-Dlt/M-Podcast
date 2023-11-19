import 'package:user/ApiException/api_exception.dart';
import 'package:user/Data/getdata_datasource.dart';
import 'package:user/DataModel/data_model.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:dartz/dartz.dart';

abstract class IGetDataRepository {
  Future<Either<String, NotificationDataModel>> metaData();
  Future<Either<String, HomeDataModel>> mainData();

  Future<Either<String, CategoryPageDataModel>> getPage(
      {required String mainGroupId});

  Future<Either<String, PageinationDataModel>> getDocumentsBy(
      {required int ofsset,
      required String group,
      required String subGroup,
      required String by});

  Future<Either<String, PageinationDataModel>> getAllDocumentsBy(
      {required int ofsset, required String by});

  Future<Either<String, SearchPageinationDataModel>> search({
    required int ofsset,
    required String topic,
    required String by,
  });

  Future<Either<String, SearchPageinationDataModel>> searchByLabel({
    required int ofsset,
    required String topic,
    required String by,
  });

  Future<Either<String, DocumentDataModel>> getDocument({required int id});

  Future<Either<String, CategoriesDataModel>> getCategories();
  Future<Either<String, SubGroupsDataModel>> getSubGroups(String mainGroupId);

  Future<Either<String, FetchSubscriptionDataModel>> getSubscriptions({
    String? discountCode,
  });
  Future<Either<String, SingleSubscriptionDataModel>> getSingleSubscription(
      String id);

  Future<Either<String, List>> getTermsAndConditions();
  Future<Either<String, List>> getAboutUs();
  Future<Either<String, List>> getContactUs();
}

class GetDataRepository implements IGetDataRepository {
  final IGetDataRemote _datasource = locator.get();

  @override
  Future<Either<String, NotificationDataModel>> metaData() async {
    try {
      return right(await _datasource.metaData());
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, PageinationDataModel>> getAllDocumentsBy(
      {required int ofsset, required String by}) async {
    try {
      PageinationDataModel data =
          await _datasource.getAllDocumentsBy(ofsset: ofsset, by: by);
      return right(data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, DocumentDataModel>> getDocument(
      {required int id}) async {
    try {
      DocumentDataModel data = await _datasource.getDocument(id: id);
      return right(data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, PageinationDataModel>> getDocumentsBy(
      {required int ofsset,
      required String group,
      required String subGroup,
      required String by}) async {
    try {
      PageinationDataModel data = await _datasource.getDocumentsBy(
          ofsset: ofsset, by: by, group: group, subGroup: subGroup);
      return right(data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, CategoryPageDataModel>> getPage(
      {required String mainGroupId}) async {
    try {
      CategoryPageDataModel data =
          await _datasource.getPage(mainGroupId: mainGroupId);
      return right(data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, HomeDataModel>> mainData() async {
    try {
      HomeDataModel data = await _datasource.mainData();
      return right(data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, SearchPageinationDataModel>> search({
    required int ofsset,
    required String topic,
    required String by,
  }) async {
    try {
      SearchPageinationDataModel data =
          await _datasource.search(ofsset: ofsset, topic: topic, by: by);
      return right(data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, SearchPageinationDataModel>> searchByLabel({
    required int ofsset,
    required String topic,
    required String by,
  }) async {
    try {
      SearchPageinationDataModel data =
          await _datasource.searchByLabel(ofsset: ofsset, topic: topic, by: by);
      return right(data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, CategoriesDataModel>> getCategories() async {
    try {
      return right(await _datasource.getCategories());
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, SubGroupsDataModel>> getSubGroups(
      String mainGroupId) async {
    try {
      return right(await _datasource.getSubGroups(mainGroupId));
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, List>> getAboutUs() async {
    try {
      return right(await _datasource.getAboutUs());
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, List>> getTermsAndConditions() async {
    try {
      return right(await _datasource.getTermsAndConditions());
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, List>> getContactUs() async {
    try {
      return right(await _datasource.getContactUs());
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, FetchSubscriptionDataModel>> getSubscriptions({
    String? discountCode,
  }) async {
    try {
      return right(
          await _datasource.getSubscriptions(discountCode: discountCode));
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, SingleSubscriptionDataModel>> getSingleSubscription(
      String id) async {
    try {
      return right(await _datasource.getSingleSubscription(subscriptionId: id));
    } on ApiException catch (e) {
      return left(e.message);
    }
  }
}
