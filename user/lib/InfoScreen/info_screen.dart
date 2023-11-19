import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:user/Bloc/InfoBlock/info_block.dart';
import 'package:user/Bloc/InfoBlock/info_event.dart';
import 'package:user/Bloc/InfoBlock/info_state.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DocumentOnline/textbox.dart';
import 'package:user/GeneralWidgets/loading.dart';
import 'package:user/GeneralWidgets/refresh.dart';
import 'package:user/iconsax_icons.dart';

enum Info { termsAndConditions, aboutUs }

class InfoScreen extends StatefulWidget {
  InfoScreen({super.key, required this.info});
  final Info info;
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List info = [];
  // -----------------------------------------------------------
  bool loaded = false;
  // -----------------------------------------------------------
  List<Widget> buildItems(List info) {
    return [
      ...info.map((item) {
        if (item["type"] == "textbox") {
          return TextBoxOnlineBuilder(
            textBox: item,
            textSizeFactor: 1.0,
          );
        }
        //  else {
        //   if (item["type"] == "image") {
        //     return const Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //       child: SizedBox(),
        //       // image(name: item["name"], index: document.body.indexOf(item)),
        //     );
        //   }
        // }
        else {
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
    if (widget.info == Info.termsAndConditions) {
      BlocProvider.of<InfoBloc>(context).add(GetTermsAndConditionsData());
    }
    if (widget.info == Info.aboutUs) {
      BlocProvider.of<InfoBloc>(context).add(GetAboutUsData());
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<InfoBloc, InfoState>(
          builder: (context, state) => NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.white.withOpacity(0.5),
                pinned: true,
                elevation: 2.5,
                forceElevated: true,
                stretch: false,
                foregroundColor: black,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Iconsax.arrow_left,
                        color: black,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.info == Info.aboutUs
                            ? "درباره ما"
                            : widget.info == Info.termsAndConditions
                                ? "قوانین و مقررات"
                                : "",
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color(0xff0B1B3F),
                            fontSize: 18),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ],
            body: Column(
              children: [
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
                            if (widget.info == Info.termsAndConditions) {
                              BlocProvider.of<InfoBloc>(context)
                                  .add(GetTermsAndConditionsData());
                            }
                            if (widget.info == Info.aboutUs) {
                              BlocProvider.of<InfoBloc>(context)
                                  .add(GetAboutUsData());
                            }
                          })
                        ],
                      ),
                    );
                  }, (r) {
                    if (!loaded) {
                      info = r;
                      loaded = true;
                    }
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
        ),
      ),
    );
  }
}
