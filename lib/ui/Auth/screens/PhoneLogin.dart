import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/Auth/screens/OTPverifacation.dart';
import 'package:ipay/providers/otp_provider.dart'; // Import the OTP provider

import '../../../core/constants/app_Helper_Function.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/enhanced_auth_provider.dart';

class IPayPhoneAuthScreen extends StatelessWidget {
  const IPayPhoneAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneAuth = Provider.of<PhoneAuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: IpaySize.spaceBtwItems),
              IpayHelper.CustomImage(image: 'Ipay!logo.png', height: 100, width: 120),
              const SizedBox(height: IpaySize.spaceBtwItems),
              IpayHelper.CustomImage(image: 'Illustration.png', height: 270, width: null),
              const SizedBox(height: IpaySize.defaultSpace),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IpayHelper.CustomText(
                    text: "Welcome To Ipay",
                    fontSize: 20,
                    color: IpayColor.primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(height: IpaySize.spaceBtwItemsSm + 2),
                  IpayHelper.CustomText(
                    text: 'Seamless Recharge & Bill payment....',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
              const SizedBox(height: IpaySize.spaceBtwSections),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(
                    IpaySize.borderRadiusLg + 5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: IpaySize.borderRadiusLg,
                        vertical: IpaySize.borderRadiusLg,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      child: IpayHelper.CustomText(
                        text: '+91',
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: phoneAuth.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter Phone Number',
                          hintStyle: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Colors.black54,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: IpaySize.md,
                            vertical: IpaySize.md,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: IpaySize.defaultSpace),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final phoneNumber = phoneAuth.phoneController.text.trim();
                    if (phoneAuth.isPhoneNumberValid) {
                      // Show loading
                      phoneAuth.setLoading(true);
                      
                      try {
                        // Get enhanced auth provider and send OTP
                        final enhancedAuth = Provider.of<EnhancedAuthProvider>(context, listen: false);
                        enhancedAuth.setPhoneNumber(phoneNumber);
                        await enhancedAuth.sendOtp();
                        
                        phoneAuth.setLoading(false);
                        
                        if (enhancedAuth.errorMessage == null) {
                          // OTP sent successfully, navigate to OTP screen
                          final fullPhoneNumber = "+91$phoneNumber";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChangeNotifierProvider(
                                  create: (context) => OtpProvider(),
                                  child: OTPVerificationScreen(
                                    phoneNumber: fullPhoneNumber,
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          // Show error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(enhancedAuth.errorMessage!),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        phoneAuth.setLoading(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to send OTP: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid 10-digit phone number.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IpayColor.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: IpaySize.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        IpaySize.borderRadiusLg + 5,
                      ),
                    ),
                  ),
                  child: IpayHelper.CustomText(
                    text: "Continue",
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: IpaySize.defaultSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IpayHelper.CustomText(
                    text: 'Need help?',
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print('Opening support...');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening support...')),
                      );
                    },
                    child: IpayHelper.CustomText(
                      text: 'Contact Support',
                      fontSize: 15,
                      color: IpayColor.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: IpaySize.defaultSpace + 5),
              IpayHelper.CustomText(
                text: 'Or Sign With',
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: IpaySize.defaultSpace - 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print('Google sign in clicked');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google sign in clicked')),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Image.asset(
                        'assets/images/google-logo.png',
                        height: IpaySize.defaultSpace,
                      ),
                    ),
                  ),
                  const SizedBox(width: IpaySize.defaultSpace),
                  GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print('Facebook sign in clicked');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Facebook sign in clicked'),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(
                        Icons.facebook,
                        size: 45,
                        color: IpayColor.primaryColor2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: IpaySize.spaceBtwSections + 8),
            ],
          ),
        ),
      ),
    );
  }
}