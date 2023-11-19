import 'dart:async';

import 'package:admin/Bloc/SubGroupsBloc/subgroups_event.dart';
import 'package:admin/Bloc/SubGroupsBloc/subgroups_state.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Dio/base_dio.dart';

class SubGroupsBloc extends Bloc<SubGroupsEvent, SubGroupsState> {
  final IGetDataRepository rep = locator.get();
  SubGroupsBloc() : super(SubGroupsInitState()) {
    on<GetSubGroupsData>((event, emit) async {
      emit(SubGroupsLoadingState());
      var data = await rep.getSubGroups(event.mainGroupId);
      await Future.delayed(
        Duration(seconds: 1),
        () {
          emit(SubGroupsDataState(data: data));
        },
      );
    });
  }
}
