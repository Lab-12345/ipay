import 'package:flutter/material.dart';
import 'package:ipay/ui/Auth/screens/OTPSuccessScreen.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/providers/otp_provider.dart'; // Import the new provider

import '../../../core/constants/app_Helper_Function.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String phoneNumber;

  const OTPVerificationScreen({Key? key, this.phoneNumber = ''})
      : super(key: key);

  /// UI Design
  @override
  Widget build(BuildContext context) {
    // Get the provider instance
    final otpProvider = Provider.of<OtpProvider>(context);

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
          padding: const EdgeInsets.all(IpaySize.lg),
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
                phoneNumber,
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
                children: List.generate(OtpProvider.otpLength, (index) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: otpProvider.otpControllers[index],
                      focusNode: otpProvider.focusNodes[index],
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
                          borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(IpaySize.borderRadiusMd)),
                          borderSide: BorderSide(
                            color: IpayColor.primaryColor,
                          ),
                        ),
                      ),
                      onChanged: (value) => otpProvider.onOTPChanged(context, value, index),
                    ),
                  );
                }),
              ),

              const SizedBox(height: IpaySize.defaultSpace),

              GestureDetector(
                onTap: otpProvider.resendOTP,
                child: Consumer<OtpProvider>(
                  builder: (context, provider, child) {
                    return IpayHelper.CustomText(
                      text: provider.resendTimer > 0
                          ? 'Resend OTP in ${provider.resendTimer}s'
                          : 'Resend OTP',
                      fontSize: 14,
                      color: provider.resendTimer > 0
                          ? Colors.grey.shade500
                          : IpayColor.primaryColor,
                      fontWeight: FontWeight.w500,
                    );
                  },
                ),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  otpProvider.verifyOTP(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OTPSuccessScreen(phoneNumber: phoneNumber, token: '',)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: IpayColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: IpayHelper.CustomText(text: 'Verify OTP', fontSize: 15, color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}