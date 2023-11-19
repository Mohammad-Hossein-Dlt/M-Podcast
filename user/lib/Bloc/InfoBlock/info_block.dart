import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Bloc/InfoBlock/info_event.dart';
import 'package:user/Bloc/InfoBlock/info_state.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/Repository/get_data_repository.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  IGetDataRepository getRep = locator.get();
  InfoBloc() : super(InfoInitState()) {
    on<GetTermsAndConditionsData>((event, emit) async {
      emit(InfoLoadingState());
      var data = await getRep.getTermsAndConditions();
      emit(InfoDataState(infoData: data));
    });

    on<GetAboutUsData>((event, emit) async {
      emit(InfoLoadingState());
      var data = await getRep.getAboutUs();
      emit(InfoDataState(infoData: data));
    });

    on<GetContactUsData>((event, emit) async {
      emit(InfoLoadingState());
      var data = await getRep.getContactUs();
      emit(InfoDataState(infoData: data));
    });
    // ---------------------------------------------------------------
  }
}
