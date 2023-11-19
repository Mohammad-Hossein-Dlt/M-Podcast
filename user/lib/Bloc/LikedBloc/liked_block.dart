import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Bloc/LikedBloc/liked_event.dart';
import 'package:user/Bloc/LikedBloc/liked_state.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/Repository/user_data_repository.dart';
import 'package:user/User/user.dart';

class LikedBloc extends Bloc<LikedEvent, LikedState> {
  final IUserDataRepository rep = locator.get();
  LikedBloc() : super(LikedInitState()) {
    on<GetLikedEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(LikedLoadingState());
        emit(LikedDataState(
            bookmarksList: await rep.getLiked(
                userData()!.token, event.offset, event.order)));
      } else {
        emit(NoLoginState());
      }
    });
    on<LoadMoreLikedEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(LikedDataState(
            bookmarksList: await rep.getLiked(
                userData()!.token, event.offset, event.order)));
      } else {
        emit(NoLoginState());
      }
    });
    // on<RemoveFromLikedEvent>((event, emit) async {
    //   if (isUserLogin()) {
    //     var isAddedToFavorites = await rep.addDocumentToFavorites(
    //         userName: userData()!.phone, documentId: event.id);
    //     isAddedToFavorites.fold((l) {
    //       Fluttertoast.showToast(
    //         msg: "خطایی رخ داد!",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.CENTER_RIGHT,
    //         backgroundColor: red,
    //         textColor: white,
    //       );
    //       emit(LikedErrorState());
    //     }, (r) async {
    //       if (r) {
    //         Fluttertoast.showToast(
    //           msg: "این ملب به علاقه مندیهای تان اظافه شد.",
    //           toastLength: Toast.LENGTH_SHORT,
    //           gravity: ToastGravity.CENTER_RIGHT,
    //           backgroundColor: blue,
    //           textColor: Colors.white,
    //         );
    //       } else {
    //         Fluttertoast.showToast(
    //           msg: "این مطلب از علاقه مندیهای تان حذف شد.",
    //           toastLength: Toast.LENGTH_SHORT,
    //           gravity: ToastGravity.CENTER_RIGHT,
    //           backgroundColor: blue,
    //           textColor: Colors.white,
    //         );
    //       }
    //       BlocProvider.of<MainScreenBloc>(mainScreenContext.get())
    //           .add(MainScreenDefaultEvent());
    //     });
    //   } else {
    //     showModalBottomSheet(
    //         // isScrollControlled: true,
    //         context: event.ctx,
    //         shape: const RoundedRectangleBorder(
    //             borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(20),
    //                 topRight: Radius.circular(20))),
    //         builder: (context) {
    //           return Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(vertical: 20),
    //                 child: NoLogin(),
    //               ),
    //             ],
    //           );
    //         });
    //   }
    // });
  }
}
