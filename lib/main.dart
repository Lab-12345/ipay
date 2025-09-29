import 'package:flutter/material.dart';
import 'package:ipay/Hello.dart';
import 'package:ipay/providers/BottomProvider.dart';
import 'package:ipay/providers/D2HRechargeInputsProvides.dart';
import 'package:ipay/providers/D2HRechargeProvider.dart';
import 'package:ipay/providers/HistoryProvider.dart';
import 'package:ipay/providers/IpayHomeProvider.dart';
import 'package:ipay/providers/OTP_Provider.dart';
import 'package:ipay/providers/WalletProvider.dart';
import 'package:ipay/providers/auth_provider.dart';
import 'package:ipay/providers/enhanced_auth_provider.dart';
import 'package:ipay/ui/Auth/screens/PhoneLogin.dart';
import 'package:ipay/ui/Dialogs/Sucess.dart';
import 'package:ipay/ui/Recharge/LPG/LPGInputs.dart';
import 'package:provider/provider.dart';
import 'OTP.dart';
import 'Splash.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => PhoneAuthProvider()),
        ChangeNotifierProvider(create: (_) => EnhancedAuthProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => IpayWalletProvider()),
        ChangeNotifierProvider(create: (_) => DthRechargeProvider()),
        ChangeNotifierProvider(create: (_) => DthRechargeInputsProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const IpayApp(),
    ),
  );
}

class IpayApp extends StatelessWidget {
  const IpayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPay App',
      //theme: IpayTheme.lightTheme,
      //darkTheme: IpayTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: //LPGBillingScreen()
      //HomeScreen()
      IPaySplashScreen(nextScreen: IPayPhoneAuthScreen()),
      //AnimatedLogoDemo()
      //OTPVerificationScreen()
      // ExampleUsage()
      //const SplashScreen(),
    );
  }
}