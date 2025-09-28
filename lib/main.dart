import 'package:flutter/material.dart';
import 'package:ipay/providers/BottomProvider.dart';
import 'package:ipay/providers/IpayHomeProvider.dart';
import 'package:ipay/providers/WalletProvider.dart';
import 'package:ipay/providers/auth_provider.dart';
import 'package:ipay/providers/enhanced_auth_provider.dart';
import 'package:ipay/ui/Auth/auth_wrapper.dart';
import 'package:ipay/ui/Auth/screens/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhoneAuthProvider()),
        ChangeNotifierProvider(create: (_) => EnhancedAuthProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => IpayWalletProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'iPay',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(), // Keep SplashScreen as the initial route
        routes: {
          '/auth': (context) => const AuthWrapper(), // Define a route for the AuthWrapper
        },
      ),
    );
  }
}
