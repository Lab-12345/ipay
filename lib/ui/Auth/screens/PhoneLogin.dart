import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/Auth/screens/OTPverifacation.dart';

class IPayWelcomeScreen extends StatefulWidget {
  const IPayWelcomeScreen({Key? key}) : super(key: key);

  @override
  State<IPayWelcomeScreen> createState() => _IPayWelcomeScreenState();
}

class _IPayWelcomeScreenState extends State<IPayWelcomeScreen> {
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
              const SizedBox(height:IpaySize.spaceBtwItems),

              // iPay Logo
              Image.asset('assets/images/Ipay!logo.png',height: 120,width: 120,),

              const SizedBox(height: IpaySize.spaceBtwItems),

              Image.asset('assets/images/Illustration.png',height: 250,width: 250,),

              const SizedBox(height: IpaySize.defaultSpace),

              // Welcome text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome To Ipay',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  const SizedBox(height: IpaySize.spaceBtwItemsSm+2),

                  const Text(
                    'Seamless Recharge & Bill payment...',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Ubuntu',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: IpaySize.spaceBtwSections),

              // Phone number input
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300,),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      child: const Text(
                        '+91',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter Phone Number',
                          hintStyle: TextStyle( fontFamily: 'Ubuntu',color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: IpaySize.defaultSpace),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPVerificationScreen(phoneNumber: '',)));
                    // Handle continue action
                    if (_phoneController.text.isNotEmpty) {
                      // Add your navigation or API call logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Continuing with phone number...')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter phone number')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Contact support
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Need help? ',
                    style: TextStyle(color: Colors.grey[700]
                    , fontFamily: 'Ubuntu'),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle contact support
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening support...')),
                      );
                    },
                    child: const Text(
                      'Contact Support',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Divider
              const Text(
                'Or sign In with',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'Ubuntu'
                ),
              ),

              const SizedBox(height: 20),

              // Social login buttons
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
                      child: Image.asset('assets/images/google-logo.png',height: 25,)
                    ),
                  ),
                  const SizedBox(width: IpaySize.defaultSpace),
                  GestureDetector(
                    onTap: () {
                      // Handle Facebook sign in
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Facebook sign in clicked')),
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

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage in your main app
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPay App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const IPayWelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}