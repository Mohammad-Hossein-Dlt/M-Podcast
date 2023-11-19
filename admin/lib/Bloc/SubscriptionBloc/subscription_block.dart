import 'package:admin/Bloc/SubscriptionBloc/subscription_event.dart';
import 'package:admin/Bloc/SubscriptionBloc/subscription_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/delete_repository.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:admin/Repository/upload_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final IGetDataRepository getRep = locator.get();
  IUploadDataRepository uploadRep = locator.get();
  IDeleteDataRepository deleteRep = locator.get();
  ValueNotifier<bool> progress = ValueNotifier<bool>(false);
  ValueNotifier<bool> error = ValueNotifier<bool>(false);
  SubscriptionBloc() : super(EditSubscriptionInitState()) {
    on<GetAllSubscriptionsEvent>((event, emit) async {
      emit(SubscriptionLoadingState());
      var data = await getRep.getSubscriptions();
      emit(SubscriptionsDataState(data: data));
    });

    on<GetSingleSubscriptionEvent>((event, emit) async {
      emit(SubscriptionLoadingState());
      var data = await getRep.getSingleSubscription(event.id);
      emit(SingleSubscriptionDataState(data: data));
    });

    on<SingleSubscriptionDefaultEvent>((event, emit) async {
      emit(SingleSubscriptionDefaultState());
    });

    on<SubscriptionUploadEvent>((event, emit) async {
      progress = ValueNotifier<bool>(false);
      error = ValueNotifier<bool>(false);
      emit(SubscriptionUploadState(uploadProgress: progress, error: error));
      await uploadRep.uploadSubscription(
          event.singleSubscriptionDataModel, progress, error);
    });

    on<SubscriptionDeleteEvent>((event, emit) async {
      progress = ValueNotifier(false);
      error = ValueNotifier<bool>(false);
      emit(SubscriptionDeleteState(uploadProgress: progress, error: error));
      await deleteRep.deleteSubscription(event.id, progress, error);
    });
    // -------------------------------------------------------------------
    on<GetAllDiscountCodeEvent>((event, emit) async {
      emit(SubscriptionLoadingState());
      var data = await getRep.getDiscountCodes();
      emit(DiscountCodeDataState(data: data));
    });

    on<GetSingleDiscountCodeEvent>((event, emit) async {
      emit(SubscriptionLoadingState());
      var data = await getRep.getSingleDiscountCode(event.id);
      emit(SingleDiscountCodeDataState(data: data));
    });

    on<SingleDiscountCodeDefaultEvent>((event, emit) async {
      emit(SingleDiscountCodeDefaultState());
    });

    on<DiscountCodeUploadEvent>((event, emit) async {
      progress = ValueNotifier<bool>(false);
      error = ValueNotifier<bool>(false);
      emit(SubscriptionUploadState(uploadProgress: progress, error: error));
      await uploadRep.uploadDiscountCode(
          event.singleSubscriptionDataModel, progress, error);
    });

    on<DiscountCodeDeleteEvent>((event, emit) async {
      progress = ValueNotifier(false);
      error = ValueNotifier<bool>(false);
      emit(SubscriptionDeleteState(uploadProgress: progress, error: error));
      await deleteRep.deleteDiscountCode(event.id, progress, error);
    });
  }
}
