import 'package:admin/ApiException/api_exception.dart';
import 'package:admin/Data/getdata_datasource.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:dartz/dartz.dart';

abstract class IGetDataRepository {
  Future<Either<String, Monitoring>> monitoring();

  Future<Either<String, NotificationDataModel>> getNotification();
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

  Future<Either<String, OrdinaryDocumentDataModel>> getDocument(
      {required int id});
  Future<Either<String, EditDocumentDataModel>> getDocumentToEdit(
      {required int id});

  Future<Either<String, CategoriesDataModel>> getCategories();
  Future<Either<String, SingleCategoryDataModel>> getSingleCategories(
      String id);

  Future<Either<String, GroupSubGroup>> getGroupSubGroupById(
      String groupId, String subGroupId);

  Future<Either<String, List>> getUnGroupingDocuments();

  Future<Either<String, SubGroupsDataModel>> getSubGroups(String mainGroupId);

  Future<Either<String, List>> getTermsAndConditions();
  Future<Either<String, List>> getAboutUs();
  Future<Either<String, List>> getContactUs();

  Future<Either<String, UserDataModel>> userInfo({required String userName});

  Future<Either<String, AllSubscriptionDataModel>> getSubscriptions();
  Future<Either<String, SingleSubscriptionDataModel>> getSingleSubscription(
      String id);

  Future<Either<String, AllDiscountCodeDataModel>> getDiscountCodes();
  Future<Either<String, SingleDiscountCodeDataModel>> getSingleDiscountCode(
      String id);
}

class GetDataRepository implements IGetDataRepository {
  final IGetDataRemote _datasource = locator.get();
  @override
  Future<Either<String, Monitoring>> monitoring() async {
    try {
      return right(await _datasource.monitoring());
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
  Future<Either<String, OrdinaryDocumentDataModel>> getDocument(
      {required int id}) async {
    try {
      OrdinaryDocumentDataModel data = await _datasource.getDocument(id: id);
      return right(data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, EditDocumentDataModel>> getDocumentToEdit(
      {required int id}) async {
    try {
      EditDocumentDataModel data = await _datasource.getDocumentToEdit(id: id);
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
  Future<Either<String, NotificationDataModel>> getNotification() async {
    try {
      return right(await _datasource.getNotification());
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
  Future<Either<String, List>> getUnGroupingDocuments() async {
    try {
      return right(await _datasource.getUnGroupingDocuments());
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, SingleCategoryDataModel>> getSingleCategories(
      String id) async {
    try {
      return right(await _datasource.getSingleCategoriy(id));
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, GroupSubGroup>> getGroupSubGroupById(
      String groupId, String subGroupId) async {
    try {
      return right(await _datasource.getGroupSubGroupById(groupId, subGroupId));
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
  Future<Either<String, UserDataModel>> userInfo(
      {required String userName}) async {
    try {
      return right(await _datasource.userInfo(userName: userName));
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

  @override
  Future<Either<String, AllSubscriptionDataModel>> getSubscriptions() async {
    try {
      return right(await _datasource.getSubscriptions());
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, SingleDiscountCodeDataModel>> getSingleDiscountCode(
      String id) async {
    try {
      return right(await _datasource.getSingleDiscountCode(discountCodeId: id));
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<String, AllDiscountCodeDataModel>> getDiscountCodes() async {
    try {
      return right(await _datasource.getDiscountCodes());
    } on ApiException catch (e) {
      return left(e.message);
    }
  }
}
