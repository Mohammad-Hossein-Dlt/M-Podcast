import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:user/Subscription/subscription_screen.dart';
import '../Bloc/SubscriptionBloc/subscription_block.dart';
import '../Constants/colors.dart';

class NoSubscription extends StatelessWidget {
  NoSubscription({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 20,
      //   vertical: 20,
      // ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            20,
          ),
          topRight: Radius.circular(
            20,
          ),
        ),
        // color: midWhite,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "!این محتوا اشتراکی است",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "برای دسترسی به این مطلب لطفا اشتراک تهیه کنید",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: black,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                elevation: 0,
                minimumSize: const Size(320, 50),
                maximumSize: const Size(320, 50),
                shadowColor: Colors.white,
                backgroundColor: accent_blue,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                // side: BorderSide(
                //   color: accent_blue.withOpacity(0.2),
                // ),
              ),
              onPressed: () async {
                Get.to(
                  BlocProvider(
                    create: (context) => SubscriptionBloc(),
                    child: const Subscription(),
                  ),
                );
              },
              child: const Text(
                "خرید اشتراک",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
