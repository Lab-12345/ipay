import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/Auth/screens/OTPverifacation.dart';

import '../../../core/constants/app_Helper_Function.dart';

class IPayPhoneAuthScreen extends StatefulWidget {
  const IPayPhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<IPayPhoneAuthScreen> createState() => _IPayPhoneAuthScreenState();
}

class _IPayPhoneAuthScreenState extends State<IPayPhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: IpaySize.spaceBtwItems),

              /// iPay Logo
               IpayHelper.CustomImage(image: 'Ipay!logo.png', height: 100, width: 120),

              const SizedBox(height: IpaySize.spaceBtwItems),

              IpayHelper.CustomImage(image: 'Illustration.png', height: 270, width: null),

              const SizedBox(height: IpaySize.defaultSpace),

              /// Welcome text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IpayHelper.CustomText(
                    text: "Welcome To Ipay",
                    fontSize: 20,
                    color: IpayColor.primaryColor2,
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

              // Phone number input
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
                      decoration: BoxDecoration(
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
                        style: TextStyle(color: Colors.black),
                        controller: _phoneController,
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

              /// Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OTPVerificationScreen(phoneNumber: ''),
                      ),
                    );
                    // Handle continue action
                    if (_phoneController.text.isNotEmpty) {
                      // Add your navigation or API call logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Continuing with phone number...'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter phone number'),
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

              /// Contact support
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IpayHelper.CustomText(
                    text: 'Need help?',
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle contact support
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening support...')),
                      );
                    },
                    child: IpayHelper.CustomText(
                      text: 'Contact Support',
                      fontSize: 15,
                      color: Color(0xFF1976D2),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: IpaySize.defaultSpace + 5),

              /// Divider
              IpayHelper.CustomText(
                text: 'Or Sign With',
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),

              const SizedBox(height: IpaySize.defaultSpace-5),

              /// Social login buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle Google sign in
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
                      // Handle Facebook sign in
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
                        color: IpayColor.primaryColor,
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
