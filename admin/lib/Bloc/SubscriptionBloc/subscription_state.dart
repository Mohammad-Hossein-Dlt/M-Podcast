import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class SubscriptionState {}

class EditSubscriptionInitState implements SubscriptionState {}

class SubscriptionLoadingState implements SubscriptionState {}

class SingleSubscriptionDefaultState implements SubscriptionState {}

class SubscriptionsDataState implements SubscriptionState {
  Either<String, AllSubscriptionDataModel> data;
  SubscriptionsDataState({required this.data});
}

class SingleSubscriptionDataState implements SubscriptionState {
  Either<String, SingleSubscriptionDataModel> data;
  SingleSubscriptionDataState({required this.data});
}

class SubscriptionUploadState implements SubscriptionState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  SubscriptionUploadState({required this.uploadProgress, required this.error});
}

class SubscriptionDeleteState implements SubscriptionState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  SubscriptionDeleteState({required this.uploadProgress, required this.error});
}

// ----------------------------------------------------------------------

class SingleDiscountCodeDefaultState implements SubscriptionState {}

class DiscountCodeDataState implements SubscriptionState {
  Either<String, AllDiscountCodeDataModel> data;
  DiscountCodeDataState({required this.data});
}

class SingleDiscountCodeDataState implements SubscriptionState {
  Either<String, SingleDiscountCodeDataModel> data;
  SingleDiscountCodeDataState({required this.data});
}

class DiscountCodeUploadState implements SubscriptionState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  DiscountCodeUploadState({required this.uploadProgress, required this.error});
}

class DiscountCodeDeleteState implements SubscriptionState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  DiscountCodeDeleteState({required this.uploadProgress, required this.error});
}
