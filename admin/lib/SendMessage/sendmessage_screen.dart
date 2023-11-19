import 'package:admin/Bloc/SendMessageBloc/sendmessage_block.dart';
import 'package:admin/Bloc/SendMessageBloc/sendmessage_event.dart';
import 'package:admin/Bloc/SendMessageBloc/sendmessage_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class SendMessage extends StatefulWidget {
  SendMessage({
    super.key,
  });

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController message = TextEditingController();
  FocusNode fNode = FocusNode();

  @override
  void initState() {
    BlocProvider.of<SendMessageBloc>(context).add(MessageEditEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendMessageBloc, SendMessageState>(
      builder: (context, state) => Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: const Text("ارسال پیام عمومی"),
          centerTitle: true,
          elevation: 2.5,
          shadowColor: Colors.white.withOpacity(0.5),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          leading: TextButton(
            onPressed: () async {
              if (message.text.isNotEmpty) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    // alignment: Alignment.bottomCenter,
                    backgroundColor: const Color(0xffF0F0F2),
                    elevation: 2,
                    content: const Text(
                      "پیام ارسال شود؟",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xff4BCB81),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("خیر")),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff4BCB81),
                                ),
                                onPressed: () {
                                  BlocProvider.of<SendMessageBloc>(this.context)
                                      .add(SendMessageDataEvent(
                                          messageText: message.text));
                                  Navigator.of(context).pop();
                                },
                                child: const Text("بله")),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            child: SvgPicture.asset("assets/images/upload.svg"),
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
              if (state is MessageEditState) ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: messageEdit(),
                    ),
                  ),
                ),
              ],
              if (state is SentMessageState) ...[
                ValueListenableBuilder(
                  valueListenable: state.error,
                  builder: (context, error, child) => !error
                      ? ValueListenableBuilder(
                          valueListenable: state.sendProgress,
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
                                                      "پیام با موفقیت ارسال شد",
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
                                                      "درحال ارسال",
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
                                            BlocProvider.of<SendMessageBloc>(
                                                    context)
                                                .add(MessageEditEvent());
                                          }
                                        : null,
                                    child: const Text("بازگشت")),
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
                                          BlocProvider.of<SendMessageBloc>(
                                                  context)
                                              .add(SendMessageDataEvent(
                                                  messageText: message.text));
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
                                          BlocProvider.of<SendMessageBloc>(
                                                  context)
                                              .add(MessageEditEvent());
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
            ],
          ),
        ),
      ),
    );
  }

  Widget messageEdit() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: const Color(0xffF1F5FF), width: 4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                controller: message,
                textDirection: TextDirection.rtl,
                maxLines: null,
                minLines: 1,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      borderSide: BorderSide(color: midBlue, width: 1.4)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      borderSide: BorderSide(color: lightblue, width: 1)),
                  hintTextDirection: TextDirection.rtl,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(right: 8),
                  labelText: "متن پیام",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
