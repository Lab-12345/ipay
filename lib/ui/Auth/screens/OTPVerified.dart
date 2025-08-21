import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_Helper_Function.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/CommonWidget/BottomNav.dart';
import 'package:lottie/lottie.dart';

class Otpverified extends StatefulWidget {
  const Otpverified({super.key});

  @override
  State<Otpverified> createState() => _OtpverifiedState();
}

class _OtpverifiedState extends State<Otpverified> {
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnav(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(IpaySize.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/Verified.json',
              animate: true,
              repeat: false,
              height: 300,
              width: 300,
            ),
            SizedBox(height: IpaySize.defaultSpace),
            IpayHelper.CustomText(
              text: 'Verified',
              fontSize: 25,
              color: IpayColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: IpaySize.defaultSpace),
            IpayHelper.CustomText(
              text: 'Your Account has been\n  verified successfully!',
              fontSize: 18,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: IpaySize.defaultSpace),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: IpayColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(
                  double.infinity,
                  IpaySize.spaceBtwSections + 10,
                ),
              ),
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
