import 'package:admin/Bloc/InfoBlock/info_event.dart';
import 'package:admin/Bloc/InfoBlock/info_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:admin/Repository/upload_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  IUploadDataRepository uploadRep = locator.get();
  IGetDataRepository getRep = locator.get();
  ValueNotifier uploadProgress = ValueNotifier(false);
  ValueNotifier error = ValueNotifier(false);
  InfoBloc() : super(InfoInitState()) {
    on<GetTermsAndConditionsData>((event, emit) async {
      emit(InfoLoadingState());
      var data = await getRep.getTermsAndConditions();
      emit(InfoDataState(infoData: data));
    });

    on<UploadTermsAndConditionsEvent>((event, emit) async {
      uploadProgress = ValueNotifier(false);
      error = ValueNotifier(false);
      emit(OnUploadInfoDataState(uploadProgress: uploadProgress, error: error));
      await uploadRep.uploadTermsAndConditions(
          event.termsAndConditions, uploadProgress, error);
    });
    // ---------------------------------------------------------------

    on<GetAboutUsData>((event, emit) async {
      emit(InfoLoadingState());
      var data = await getRep.getAboutUs();
      emit(InfoDataState(infoData: data));
    });

    on<UploadAboutUsEvent>((event, emit) async {
      uploadProgress = ValueNotifier(false);
      error = ValueNotifier(false);
      emit(OnUploadInfoDataState(uploadProgress: uploadProgress, error: error));
      await uploadRep.uploadAboutUs(event.aboutUs, uploadProgress, error);
    });
    // ---------------------------------------------------------------

    on<GetContactUsData>((event, emit) async {
      emit(InfoLoadingState());
      var data = await getRep.getContactUs();
      emit(InfoDataState(infoData: data));
    });

    on<UploadContactUsEvent>((event, emit) async {
      uploadProgress = ValueNotifier(false);
      error = ValueNotifier(false);
      emit(OnUploadInfoDataState(uploadProgress: uploadProgress, error: error));
      await uploadRep.uploadContactUs(event.contactUs, uploadProgress, error);
    });

    // ---------------------------------------------------------------
    on<InitInfoUploadEvent>((event, emit) async {
      emit(InitInfoUploadState());
    });

    on<InfoEditEvent>((event, emit) async {
      emit(InfoEditState());
    });
  }
}
