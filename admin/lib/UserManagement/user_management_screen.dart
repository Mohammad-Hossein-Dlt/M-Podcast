import 'package:admin/Bloc/UserManagementBloc/usermanagement_block.dart';
import 'package:admin/Bloc/UserManagementBloc/usermanagement_event.dart';
import 'package:admin/Bloc/UserManagementBloc/usermanagement_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/DataModel/data_model.dart';
import 'package:admin/GeneralWidgets/loading.dart';
import 'package:admin/GeneralWidgets/refresh.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagement extends StatefulWidget {
  UserManagement({
    super.key,
  });
  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  TextEditingController name = TextEditingController();

  UserDataModel user = UserDataModel(
      nameAndFamily: "",
      userName: "",
      email: "",
      subscription: "",
      registryDate: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<UserManagementBloc, UserManagementState>(
          builder: (context, state) => CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                forceElevated: true,
                elevation: 2.5,
                shadowColor: Colors.white.withOpacity(0.5),
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                toolbarHeight: 58,
                leading: const SizedBox(),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: srch(),
                ),
              ),
              if (state is UserManagementLoadingState) ...[
                SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingRing(
                        lineWidth: 1.5,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ],
              if (state is UserInfoDefaultState) ...[
                SliverFillRemaining(
                  child: management(
                      userManagementInerState: state.state,
                      onReload: state.onReload),
                ),
              ],
              if (state is UserInfoDataState) ...[
                state.data.fold((l) {
                  return SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Refresh(
                          onRefresh: () {
                            BlocProvider.of<UserManagementBloc>(this.context)
                                .add(GetUserInfoEvent(userName: name.text));
                          },
                        ),
                      ],
                    ),
                  );
                }, (r) {
                  user = r;
                  return SliverFillRemaining(
                    child: management(
                        userManagementInerState: UserManagementS.default_,
                        onReload: SizedBox()),
                  );
                })
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget management(
      {required UserManagementS userManagementInerState,
      required Widget onReload}) {
    return Column(
      children: [
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: onReload,
        ),
        userData(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: red,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onPressed: userManagementInerState == UserManagementS.deleteUser
                    ? null
                    : () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            // alignment: Alignment.bottomCenter,
                            backgroundColor: const Color(0xffF0F0F2),
                            elevation: 2,
                            content: const Text(
                              "از حذف این حساب کاربری اطمینان دارید؟",
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xff4BCB81),
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
                                          backgroundColor:
                                              const Color(0xff4BCB81),
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<UserManagementBloc>(
                                                  this.context)
                                              .add(DeleteUserAcountEvent(
                                                  userName: user.userName));
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("بله")),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                child: const Text(
                  "حذف حساب این کاربر",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ],
    );
  }

  Widget userData() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.nameAndFamily,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )),
              const Text("نام و نام خانوادگی"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.userName),
              const Text("نام کاربری"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.email),
              const Text("ایمیل"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.registryDate),
              const Text("تاریخ عضویت"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.subscription),
              const Text("تاریخ انقضا اشتراک"),
            ],
          ),
        ],
      ),
    );
  }

  Widget srch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
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
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: Container(
              height: 54,
              margin: const EdgeInsets.only(right: 14),
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
                      controller: name,
                      textDirection: TextDirection.rtl,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                            borderSide: BorderSide(color: midBlue, width: 1.4)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                            borderSide: BorderSide(color: lightblue, width: 1)),
                        hintTextDirection: TextDirection.rtl,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(right: 8),
                        hintText: "نام کاربری",
                        prefixIcon: ValueListenableBuilder(
                          valueListenable: name,
                          builder: (context, value, child) => Visibility(
                            visible: name.text.isNotEmpty,
                            child: TextButton(
                              child: Icon(
                                Icons.close_rounded,
                                color: black,
                                size: 20,
                              ),
                              onPressed: () {
                                name.text = "";
                              },
                            ),
                          ),
                        ),
                      ),
                      onSubmitted: (value) {
                        BlocProvider.of<UserManagementBloc>(this.context)
                            .add(GetUserInfoEvent(userName: name.text));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
