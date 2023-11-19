abstract class SubscriptionEvent {}

class GetAllSubscriptionsEvent implements SubscriptionEvent {
  String? discountCode;
  GetAllSubscriptionsEvent({required this.discountCode});
}

class GetSingleSubscriptionEvent implements SubscriptionEvent {
  String id;
  GetSingleSubscriptionEvent({required this.id});
}
