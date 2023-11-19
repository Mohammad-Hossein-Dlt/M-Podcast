import 'package:dartz/dartz.dart';
import 'package:user/DataModel/data_model.dart';

abstract class SubscriptionState {}

class EditSubscriptionInitState implements SubscriptionState {}

class SubscriptionLoadingState implements SubscriptionState {}

class SubscriptionWithDiscountCodeLoadingState implements SubscriptionState {}

class SubscriptionsDataState implements SubscriptionState {
  Either<String, FetchSubscriptionDataModel> data;
  SubscriptionsDataState({required this.data});
}

class SingleSubscriptionDataState implements SubscriptionState {
  Either<String, SingleSubscriptionDataModel> data;
  SingleSubscriptionDataState({required this.data});
}
