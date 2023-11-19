import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Bloc/SubscriptionBloc/subscription_event.dart';
import 'package:user/Bloc/SubscriptionBloc/subscription_state.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/Repository/get_data_repository.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final IGetDataRepository getRep = locator.get();
  ValueNotifier<bool> progress = ValueNotifier<bool>(false);
  ValueNotifier<bool> error = ValueNotifier<bool>(false);
  SubscriptionBloc() : super(EditSubscriptionInitState()) {
    on<GetAllSubscriptionsEvent>((event, emit) async {
      if (event.discountCode == null) {
        emit(SubscriptionLoadingState());
      } else {
        emit(SubscriptionWithDiscountCodeLoadingState());
      }
      var data =
          await getRep.getSubscriptions(discountCode: event.discountCode);

      emit(SubscriptionsDataState(data: data));
    });

    on<GetSingleSubscriptionEvent>((event, emit) async {
      emit(SubscriptionLoadingState());
      var data = await getRep.getSingleSubscription(event.id);
      emit(SingleSubscriptionDataState(data: data));
    });
  }
}
