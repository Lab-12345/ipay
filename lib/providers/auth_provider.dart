import 'package:flutter/material.dart';

class PhoneAuthProvider with ChangeNotifier {
  final TextEditingController _phoneController = TextEditingController();
  String? _token;
  bool _isLoading = false;

  TextEditingController get phoneController => _phoneController;

  String? get token => _token;

  bool get isLoading => _isLoading;

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

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
