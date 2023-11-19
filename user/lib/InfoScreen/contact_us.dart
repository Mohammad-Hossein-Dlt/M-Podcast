import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/Bloc/InfoBlock/info_block.dart';
import 'package:user/Bloc/InfoBlock/info_event.dart';
import 'package:user/Bloc/InfoBlock/info_state.dart';
import 'package:user/DocumentOnline/textbox.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/refresh.dart';

class ContactUs extends StatefulWidget {
  ContactUs({super.key});
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  List info = [];
  // -----------------------------------------------------------
  List<Widget> buildItems(List info) {
    return [
      ...info.map((item) {
        if (item["type"] == "textbox") {
          return TextBoxOnlineBuilder(
            textBox: item,
            textSizeFactor: 1.0,
          );
        } else if (item["type"] == "link") {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {
                    switch (item["socialsType"]) {
                      case "PhoneNumber":
                        break;
                      case "PhoneNumber":
                        break;
                      case "PhoneNumber":
                        break;
                      case "PhoneNumber":
                        break;
                      default:
                    }

                    if (!await launchUrl(Uri.parse(item["link"]),
                        mode: LaunchMode.externalApplication)) {
                      throw "";
                    }
                  },
                  child: Text(
                    item["value"],
                  ),
                ),
                Text(item["title"]),
              ],
            ),
          );
        } else {
          return Container();
        }
      })
    ];
  }

  Widget content() {
    return Column(
      children: [
        ...buildItems(info),
        const SizedBox(height: 30),
      ],
    );
  }

  @override
  void initState() {
    BlocProvider.of<InfoBloc>(context).add(GetContactUsData());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoBloc, InfoState>(
      builder: (context, state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
            Divider(
              thickness: 0.4,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text("ارتباط با پشتیبانی"),
              ],
            ),
            if (state is InfoLoadingState) ...[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: LoadingRing(
                        lineWidth: 1.5,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (state is InfoDataState) ...[
              state.infoData.fold((l) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Refresh(onRefresh: () {
                        BlocProvider.of<InfoBloc>(context)
                            .add(GetContactUsData());
                      })
                    ],
                  ),
                );
              }, (r) {
                info = r;
                return Expanded(
                  child: SingleChildScrollView(
                    child: content(),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
