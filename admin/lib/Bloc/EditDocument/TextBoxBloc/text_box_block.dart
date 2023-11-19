import 'package:admin/Bloc/EditDocument/TextBoxBloc/text_box_event.dart';
import 'package:admin/Bloc/EditDocument/TextBoxBloc/text_box_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextBoxBloc extends Bloc<TextBoxEvent, TextBoxState> {
  TextBoxBloc() : super(TextBoxInitState()) {
    on<TextBoxAddItemEvent>((event, emit) async {
      emit(TextBoxAddItemState());
    });

    on<TextBoxDefaultEvent>((event, emit) async {
      emit(TextBoxDefaultState());
    });
  }
}
