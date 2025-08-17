import 'dart:async';
import 'package:flutter/material.dart';
import 'auth_provider.dart';

class OtpProvider with ChangeNotifier {
  static const int otpLength = 6;
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;
  Timer? _timer;
  int _resendTimer = 30;
  String _enteredOTP = '';

  int get resendTimer => _resendTimer;
  String get enteredOTP => _enteredOTP;

  OtpProvider() {
    otpControllers = List.generate(otpLength, (index) => TextEditingController());
    focusNodes = List.generate(otpLength, (index) => FocusNode());
    startResendTimer();
  }

  void startResendTimer() {
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        _resendTimer--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void onOTPChanged(BuildContext context, String value, int index) {
    if (value.isNotEmpty) {
      if (index < otpLength - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }

    _enteredOTP = otpControllers.map((controller) => controller.text).join();
    notifyListeners();
  }

  Future<bool> verifyOTP(BuildContext context, PhoneAuthProvider authProvider) async {
    if (_enteredOTP.length == otpLength) {
      final success = await authProvider.verifyOtp(_enteredOTP);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified successfully!')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'OTP verification failed')),
        );
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
      return false;
    }
  }

  void resendOTP() {
    if (_resendTimer == 0) {
      _resendTimer = 30;
      for (var controller in otpControllers) {
        controller.clear();
      }
      _enteredOTP = '';
      startResendTimer();
      notifyListeners();
    }
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
}