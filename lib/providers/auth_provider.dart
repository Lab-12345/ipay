import 'package:flutter/material.dart';

class PhoneAuthProvider with ChangeNotifier {
  final TextEditingController _phoneController = TextEditingController();

  TextEditingController get phoneController => _phoneController;

  bool get isPhoneNumberValid {
    // Basic validation: checks if the text field is not empty and has a length of 10
    return _phoneController.text.isNotEmpty && _phoneController.text.length == 10;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}