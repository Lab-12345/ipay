import 'package:flutter/material.dart';
import 'package:ipay/providers/BottomProvider.dart';
import 'package:ipay/providers/HomeProvider.dart';
import 'package:ipay/providers/OTP_Provider.dart';
import 'package:ipay/providers/auth_provider.dart';
import 'package:ipay/ui/Auth/screens/OTPSuccessScreen.dart';
import 'package:provider/provider.dart';
import 'package:ipay/core/theme/app_theme.dart';
// Import the new provider
import 'package:ipay/ui/Auth/screens/splash.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => PhoneAuthProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => OTPVerificationProvider()),
        // Add the new provider
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
      themeMode: ThemeMode.light,
      theme: IpayTheme.lightTheme,
      darkTheme: IpayTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
