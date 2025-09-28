import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/enhanced_auth_provider.dart'; // Keep for auth logic if needed later
import 'screens/PhoneLogin.dart';
import '../CommonWidget/BottomNav.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // In a real app, you would check for a token from storage here
  // and listen to an auth provider to update this state.
  bool _isAuthenticated = false; 

  @override
  Widget build(BuildContext context) {
    // You can use a Consumer here to listen to auth state changes
    // For now, we just use the simple boolean.
    
    // The providers for Bottomnav and IPayPhoneAuthScreen are now
    // correctly supplied by the MultiProvider in main.dart.
    
    if (_isAuthenticated) {
      return const Bottomnav();
    } else {
      return const IPayPhoneAuthScreen();
    }
  }
}
