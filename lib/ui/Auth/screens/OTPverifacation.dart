import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'dart:async';

import 'package:ipay/ui/Auth/screens/OTPVerified.dart';

import '../../../core/constants/app_Helper_Function.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({Key? key, this.phoneNumber = ''})
    : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final int otpLength = 6; /// ✅ 6-digit OTP
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;
  Timer? _timer;
  int _resendTimer = 45;
  String enteredOTP = '';

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(
      otpLength,
      (index) => TextEditingController(),
    );
    focusNodes = List.generate(otpLength, (index) => FocusNode());
    startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void onOTPChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < otpLength - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }

    setState(() {
      enteredOTP = otpControllers.map((controller) => controller.text).join();
    });
  }

  void verifyOTP() {
    String otp = otpControllers.map((controller) => controller.text).join();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Otpverified()),
    );
    if (otp.length == otpLength) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Verifying OTP: $otp')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
    }
  }

  void resendOTP() {
    if (_resendTimer == 0) {
      setState(() {
        _resendTimer = 27;
        for (var controller in otpControllers) {
          controller.clear();
        }
        enteredOTP = '';
      });
      startResendTimer();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP resent successfully')));
    }
  }

  /// UI Design
  @override
  Widget build(BuildContext context) {
    print('Entered OTP: $enteredOTP');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: IpayHelper.CustomText(
          fontSize: 18,
          text: 'OTP Verification',
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: IpaySize.spaceBtwSections + 5),
              IpayHelper.CustomText(
                text: 'We\'ve sent a verification code to',
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: IpaySize.spaceBtwItemsSm),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: IpaySize.spaceBtwSections + 6),

              /// ✅ 6 OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(otpLength, (index) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: otpControllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: IpayColor.primaryColor2,
                          ),
                        ),
                      ),
                      onChanged: (value) => onOTPChanged(value, index),
                    ),
                  );
                }),
              ),

              const SizedBox(height: IpaySize.defaultSpace),

              GestureDetector(
                onTap: resendOTP,
                child: IpayHelper.CustomText(
                  text: _resendTimer > 0
                      ? 'Resend OTP in ${_resendTimer}s'
                      : 'Resend OTP',
                  fontSize: 14,
                  color: _resendTimer > 0
                      ? Colors.grey.shade500
                      : IpayColor.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: IpayHelper.CustomText(text: 'Verify OTP', fontSize: 15, color: Colors.white, fontWeight: FontWeight.w800)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
