import 'package:admin/Bloc/NotificationBloc/notification_block.dart';
import 'package:admin/Bloc/NotificationBloc/notification_event.dart';
import 'package:admin/Bloc/NotificationBloc/notification_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class NotificationEdit extends StatefulWidget {
  NotificationEdit({
    super.key,
  });

  @override
  State<NotificationEdit> createState() => _NotificationEditState();
}

class _NotificationEditState extends State<NotificationEdit> {
  TextEditingController message = TextEditingController();
  FocusNode fNode = FocusNode();
  bool enable = true;
  @override
  void initState() {
    BlocProvider.of<NotificationBloc>(context).add(GetNotificationData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("اعلان‌ صفحه‌ اصلی"),
          centerTitle: true,
          elevation: 2.5,
          shadowColor: Colors.white.withOpacity(0.5),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          leading: ValueListenableBuilder(
            valueListenable: ValueNotifier(state),
            builder: (context, value, child) => Visibility(
              visible: value is NotificationDataState ||
                  value is NotificationEditState,
              child: TextButton(
                onPressed: () async {
                  if (message.text.isNotEmpty) {
                    BlocProvider.of<NotificationBloc>(context)
                        .add(InitUploadNotificationEvent());
                  }
                },
                child: SvgPicture.asset("assets/images/upload.svg"),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: SvgPicture.asset("assets/images/arrow-right2.svg"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (state is InitUploadNotificationDataState) ...[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "آپلود شود؟",
                            style: TextStyle(color: black),
                          ),
                          // const SizedBox(width: 4),
                          // const Icon(Icons.check_sharp),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                disabledBackgroundColor:
                                    const Color(0xffF5F5F5),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onPressed: () async {
                                BlocProvider.of<NotificationBloc>(context).add(
                                    UploadNotificationEvent(
                                        notificationData: NotificationDataModel(
                                            message: message.text,
                                            enable: enable)));
                              },
                              child: const Text("آپلود")),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                disabledBackgroundColor:
                                    const Color(0xffF5F5F5),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onPressed: () {
                                BlocProvider.of<NotificationBloc>(context)
                                    .add(NotificationEditEvent());
                              },
                              child: const Text("بازگشت")),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (state is UploadNotificationDataState) ...[
                ValueListenableBuilder(
                  valueListenable: state.error,
                  builder: (context, error, child) => !error
                      ? ValueListenableBuilder(
                          valueListenable: state.uploadProgress,
                          builder: (context, progress, child) => Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Column(
                                            children: [
                                              Visibility(
                                                visible: progress,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "با موفقیت آپلود شد",
                                                      style: TextStyle(
                                                          color: black),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline_rounded,
                                                      color: green,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: !progress,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: SpinKitThreeBounce(
                                                        color: green,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    800),
                                                        size: 16,
                                                        // strokeWidth: 2,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "درحال آپلود",
                                                      style: TextStyle(
                                                          color: black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: green,
                                          disabledBackgroundColor:
                                              const Color(0xffF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: progress
                                            ? () {
                                                BlocProvider.of<
                                                            NotificationBloc>(
                                                        context)
                                                    .add(
                                                        NotificationEditEvent());
                                              }
                                            : null,
                                        child: const Text("بازگشت")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("خطایی رخ داد"),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: green,
                                          disabledBackgroundColor:
                                              const Color(0xffF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: () async {
                                          BlocProvider.of<NotificationBloc>(
                                                  context)
                                              .add(UploadNotificationEvent(
                                                  notificationData:
                                                      NotificationDataModel(
                                                          message: message.text,
                                                          enable: enable)));
                                        },
                                        child: const Text("تلاش دوباره")),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: green,
                                          disabledBackgroundColor:
                                              const Color(0xffF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<NotificationBloc>(
                                                  context)
                                              .add(NotificationEditEvent());
                                        },
                                        child: const Text("بازگشت")),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
              if (state is NotificationLoadingState) ...[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingRing(
                            lineWidth: 1.5,
                            size: 40,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (state is NotificationDataState) ...[
                state.data.fold(
                  (l) => Text(l),
                  (r) {
                    message.text = r.message;
                    enable = r.enable;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: notificationEdit(),
                    );
                  },
                ),
              ],
              if (state is NotificationEditState) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: notificationEdit(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationEdit() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Checkbox(
                      activeColor: green,
                      value: enable,
                      onChanged: (value) {
                        enable = value!;
                        BlocProvider.of<NotificationBloc>(context)
                            .add(NotificationEditEvent());
                      },
                    ),
                    const Text("فعال؟"),
                  ],
                )
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              enabled: enable,
              controller: message,
              textDirection: TextDirection.rtl,
              maxLines: null,
              minLines: 1,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: green, width: 1)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: green, width: 1)),
                hintTextDirection: TextDirection.rtl,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                labelText: "متن اعلان",
                floatingLabelAlignment: FloatingLabelAlignment.center,
                labelStyle: TextStyle(color: green, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
