import 'package:admin/DataModel/data_model.dart';

abstract class SubscriptionEvent {}

class SingleSubscriptionDefaultEvent implements SubscriptionEvent {}

class GetAllSubscriptionsEvent implements SubscriptionEvent {}

class GetSingleSubscriptionEvent implements SubscriptionEvent {
  String id;
  GetSingleSubscriptionEvent({required this.id});
}

class SubscriptionUploadEvent implements SubscriptionEvent {
  SingleSubscriptionDataModel singleSubscriptionDataModel;
  SubscriptionUploadEvent({
    required this.singleSubscriptionDataModel,
  });
}

class SubscriptionDeleteEvent implements SubscriptionEvent {
  String id;
  SubscriptionDeleteEvent({required this.id});
}

// -----------------------------------------------------------------------

class SingleDiscountCodeDefaultEvent implements SubscriptionEvent {}

class SingleDiscountCodeEvent implements SubscriptionEvent {}

class GetAllDiscountCodeEvent implements SubscriptionEvent {}

class GetSingleDiscountCodeEvent implements SubscriptionEvent {
  String id;
  GetSingleDiscountCodeEvent({required this.id});
}

class DiscountCodeUploadEvent implements SubscriptionEvent {
  SingleDiscountCodeDataModel singleSubscriptionDataModel;
  DiscountCodeUploadEvent({
    required this.singleSubscriptionDataModel,
  });
}

class DiscountCodeDeleteEvent implements SubscriptionEvent {
  String id;
  DiscountCodeDeleteEvent({required this.id});
}
