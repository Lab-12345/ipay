import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:lottie/lottie.dart';

class Otpverified extends StatefulWidget {
  const Otpverified({super.key});

  @override
  State<Otpverified> createState() => _OtpverifiedState();
}

class _OtpverifiedState extends State<Otpverified> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(IpaySize.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animation/Congratulations.json'),
            SizedBox(height: IpaySize.defaultSpace),
            Text('Verified'),
            SizedBox(height: IpaySize.defaultSpace),
            Text('OTP Verified Successfully'),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, IpaySize.spaceBtwSections+10),
              ),
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
