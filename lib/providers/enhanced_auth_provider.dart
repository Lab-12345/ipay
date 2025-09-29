import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class EnhancedAuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Controllers and focus nodes for OTP fields
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  String? _phoneNumber;
  String? _token;
  bool _canResend = false;
  int _resendTimer = 30;
  Timer? _timer;

  // Getters
  List<TextEditingController> get otpControllers => _otpControllers;
  List<FocusNode> get otpFocusNodes => _otpFocusNodes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get phoneNumber => _phoneNumber;
  String? get token => _token;
  bool get canResend => _canResend;
  int get resendTimer => _resendTimer;

  EnhancedAuthProvider() {
    _initializeOtpFields();
    _startResendTimer();
  }

  void _initializeOtpFields() {
    _otpControllers = List.generate(6, (index) => TextEditingController());
    _otpFocusNodes = List.generate(6, (index) => FocusNode());
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        _resendTimer--;
        notifyListeners();
      } else {
        _canResend = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool canVerifyOtp() {
    return _otpControllers.every((controller) => controller.text.isNotEmpty) && !_isLoading;
  }

  Future<bool> verifyOtp([String? otp]) async {
    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Use provided OTP or collect from controllers
      final otpToVerify = otp ?? _otpControllers.map((c) => c.text).join();

      if (otpToVerify.length != 6) {
        throw Exception('Please enter a valid 6-digit OTP');
      }

      // Ensure E.164 format
      String? phone = _phoneNumber;
      if (phone == null || phone.isEmpty) {
        throw Exception('Phone number is required');
      }
      if (!phone.startsWith('+')) {
        if (phone.length == 10) {
          phone = '+91$phone';
        } else {
          throw Exception('Provide phone in E.164 format, e.g., +911234567890');
        }
      }

      // Call API to verify OTP
      final response = await _apiService.verifyOtp(phone, otpToVerify);

      if (response['success'] == true) {
        // Store auth token if provided
        final data = response['data'] ?? {};
        if (data['token'] != null) {
          _token = data['token'];
          await _storeAuthToken(_token!);
          notifyListeners();
        }
        return true;
      } else {
        throw Exception(response['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resendOtp() async {
    if (!_canResend || _isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ensure E.164 format
      String? phone = _phoneNumber;
      if (phone == null || phone.isEmpty) {
        throw Exception('Phone number is required');
      }
      if (!phone.startsWith('+')) {
        if (phone.length == 10) {
          phone = '+91$phone';
        } else {
          throw Exception('Provide phone in E.164 format, e.g., +911234567890');
        }
      }

      final response = await _apiService.post('/api/auth/resend-otp', {
        'phone': phone,
      });

      if (response['success'] == true) {
        _startResendTimer(); // Reset timer
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendOtp() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ensure E.164 format: assuming India +91 when 10-digit local input
      String? phone = _phoneNumber;
      if (phone == null || phone.isEmpty) {
        throw Exception('Phone number is required');
      }
      if (!phone.startsWith('+')) {
        // prepend +91 for 10-digit numbers
        if (phone.length == 10) {
          phone = '+91$phone';
        } else {
          throw Exception('Provide phone in E.164 format, e.g., +911234567890');
        }
      }

      final resp = await _apiService.sendOtp(phone);
      if (resp['success'] != true) {
        throw Exception(resp['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  Future<void> _storeAuthToken(String token) async {
    // Store token securely (you might want to use flutter_secure_storage)
    // For now, we'll use a simple approach
    // await const FlutterSecureStorage().write(key: 'auth_token', value: token);
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void initialize() {}
}
