import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

// Web-specific imports
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as js_util;

class PaymentService {
  final ApiService _apiService = ApiService();
  String? _cachedRazorpayKey;

  // Get Razorpay public key from backend
  Future<String?> getRazorpayPublicKey() async {
    try {
      if (_cachedRazorpayKey != null) {
        return _cachedRazorpayKey;
      }

      final response = await _apiService.get('/payment/razorpay/key');
      
      if (response['success'] == true && response['data'] != null) {
        _cachedRazorpayKey = response['data']['key'];
        
        // Set the global key for web integration
        if (kIsWeb && _cachedRazorpayKey != null) {
          js_util.setProperty(html.window, '__RZP_PUBLIC_KEY', _cachedRazorpayKey!);
        }
        
        return _cachedRazorpayKey;
      }
    } catch (e) {
      print('Error fetching Razorpay key: $e');
    }
    return null;
  }

  // Create Razorpay order
  Future<Map<String, dynamic>?> createRazorpayOrder(double amount) async {
    try {
      final response = await _apiService.post('/payment/razorpay/order', {
        'amount': amount,
      });

      if (response['success'] == true && response['data'] != null) {
        return response['data'];
      }
    } catch (e) {
      print('Error creating Razorpay order: $e');
    }
    return null;
  }

  // Verify Razorpay payment
  Future<Map<String, dynamic>?> verifyRazorpayPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required double amount,
  }) async {
    try {
      final response = await _apiService.post('/payment/razorpay/verify', {
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
        'amount': amount,
      });

      if (response['success'] == true) {
        return response['data'];
      }
    } catch (e) {
      print('Error verifying Razorpay payment: $e');
    }
    return null;
  }

  // Initialize and open Razorpay payment gateway (Web)
  Future<Map<String, dynamic>?> openRazorpayPayment({
    required double amount,
    required String orderId,
    String? description,
    String? prefill_name,
    String? prefill_email,
    String? prefill_contact,
  }) async {
    if (!kIsWeb) {
      throw UnsupportedError('This method is only supported on web platform');
    }

    try {
      // Ensure public key is loaded
      final publicKey = await getRazorpayPublicKey();
      if (publicKey == null) {
        throw Exception('Failed to get Razorpay public key');
      }

      final options = {
        'key': publicKey,
        'amount': (amount * 100).round(), // Convert to paise
        'currency': 'INR',
        'order_id': orderId,
        'name': 'iPay',
        'description': description ?? 'Add Money to Wallet',
        'prefill': {
          if (prefill_name != null) 'name': prefill_name,
          if (prefill_email != null) 'email': prefill_email,
          if (prefill_contact != null) 'contact': prefill_contact,
        },
        'theme': {
          'color': '#3399cc',
        },
      };

      // Call the JavaScript function defined in razorpay_web.js
      final result = await _callRazorpayJS(options);
      return result;
    } catch (e) {
      print('Error opening Razorpay payment: $e');
      rethrow;
    }
  }

  // Call JavaScript Razorpay function
  Future<Map<String, dynamic>> _callRazorpayJS(Map<String, dynamic> options) async {
    final completer = Completer<Map<String, dynamic>>();

    // Define success callback
    final successCallback = js_util.allowInterop((result) {
      final data = {
        'order_id': result['order_id'],
        'payment_id': result['payment_id'],
        'signature': result['signature'],
      };
      completer.complete(data);
    });

    // Define error callback
    final errorCallback = js_util.allowInterop((error) {
      final errorData = {
        'code': error['code'] ?? 'UNKNOWN_ERROR',
        'description': error['description'] ?? 'Payment failed',
      };
      completer.completeError(Exception('Payment failed: ${errorData['description']}'));
    });

    // Convert options to JS object
    final jsOptions = js.JsObject.jsify(options);

    // Call the JavaScript function
    html.window.js_util.callMethod('openRazorpay', [
      jsOptions,
      successCallback,
      errorCallback,
    ]);

    return await completer.future;
  }

  // Complete payment flow (create order -> open payment -> verify payment)
  Future<Map<String, dynamic>?> processPayment({
    required double amount,
    String? description,
    String? prefill_name,
    String? prefill_email,
    String? prefill_contact,
  }) async {
    try {
      // Step 1: Create order
      final orderData = await createRazorpayOrder(amount);
      if (orderData == null) {
        throw Exception('Failed to create order');
      }

      // Step 2: Open payment gateway
      final paymentResult = await openRazorpayPayment(
        amount: amount,
        orderId: orderData['orderId'],
        description: description,
        prefill_name: prefill_name,
        prefill_email: prefill_email,
        prefill_contact: prefill_contact,
      );

      if (paymentResult == null) {
        throw Exception('Payment was cancelled or failed');
      }

      // Step 3: Verify payment
      final verificationResult = await verifyRazorpayPayment(
        razorpayOrderId: paymentResult['order_id'],
        razorpayPaymentId: paymentResult['payment_id'],
        razorpaySignature: paymentResult['signature'],
        amount: amount,
      );

      return verificationResult;
    } catch (e) {
      print('Error in payment process: $e');
      rethrow;
    }
  }
}

extension on html.Window {
  get js_util => null;
}
