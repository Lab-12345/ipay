import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/Home/screens/Home.dart';
import 'package:lottie/lottie.dart';

import 'PhoneLogin.dart';

class Otpverified extends StatefulWidget {
  const Otpverified({super.key});

  @override
  State<Otpverified> createState() => _OtpverifiedState();
}

class _OtpverifiedState extends State<Otpverified> {

  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      },
    );
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
            Lottie.asset('assets/animation/Verified.json',animate: true,repeat: false,height: 300,width: 300),
            SizedBox(height: IpaySize.defaultSpace),
            Text(
              'Verified',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: IpayColor.primaryColor,
              ),
            ),
            SizedBox(height: IpaySize.defaultSpace),
            Text(
              'Your Account has been\n verified successfully!',
              style: TextStyle(color: Colors.grey.shade800, fontSize: 18),
            ),
            SizedBox(height: IpaySize.defaultSpace),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0060ce),
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
