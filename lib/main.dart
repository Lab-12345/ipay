<<<<<<< HEAD
=======
import 'package:flutter/material.dart';
import 'package:ipay/core/theme/app_theme.dart';
import 'package:ipay/ui/Auth/screens/splash.dart';

void main() {
  runApp(const IpayApp());
}

class IpayApp extends StatelessWidget {
  const IpayApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: IpayTheme.lightTheme,
      darkTheme: IpayTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


>>>>>>> e730bfa0ce9c0692402723e4abd85d877c03801e
