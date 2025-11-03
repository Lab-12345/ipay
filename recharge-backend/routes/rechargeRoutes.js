// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();

  // --------------------------------------------------------------------- //
  // Generic GET / POST
  // --------------------------------------------------------------------- //
  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    try {
      final headers = _getHeaders(token);
      final response = await _client
          .get(Uri.parse('${AppConfig.baseUrl}$endpoint'), headers: headers)
          .timeout(AppConfig.connectionTimeout);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data, {
        String? token,
      }) async {
    try {
      final headers = _getHeaders(token);
      final response = await _client
          .post(
        Uri.parse('${AppConfig.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      )
          .timeout(AppConfig.connectionTimeout);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --------------------------------------------------------------------- //
  // MOBILE RECHARGE: AUTO DETECT OPERATOR & CIRCLE
  // --------------------------------------------------------------------- //
  /// Uses Cyrus MNP API: /API/CyrusOperatorFatchAPI.aspx
  Future<Map<String, dynamic>> fetchOperatorAndCircle({
    required String mobileNumber,
    String? token,
  }) async {
    return await get('/api/recharge/detect?mobile=$mobileNumber', token: token);
  }

  // --------------------------------------------------------------------- //
  // FETCH RECHARGE PLANS
  // --------------------------------------------------------------------- //
  /// Uses Cyrus Plans API: /API/CyrusPlanFatchAPI.aspx
  Future<Map<String, dynamic>> fetchRechargePlans({
    required String operatorCode,
    required String circleCode,
    required String mobile,
    String? token,
  }) async {
    final query = [
      'operator=$operatorCode',
      'circle=$circleCode',
      'mobile=$mobile',
    ].join('&');
    return await get('/api/recharge/plans?$query', token: token);
  }

  // --------------------------------------------------------------------- //
  // PERFORM RECHARGE
  // --------------------------------------------------------------------- //
  Future<Map<String, dynamic>> performRecharge({
    required String mobileNumber,
    required String operatorId,
    required String circleId,
    required double amount,
    String? planId,
    required String userId,
    String? token,
  }) async {
    return await post(
      '/api/recharge/perform',
      {
        'mobileNumber': mobileNumber,
        'operatorId': operatorId,
        'circleId': circleId,
        'amount': amount,
        'userId': userId,
        if (planId != null) 'planId': planId,
      },
      token: token,
    );
  }

  // --------------------------------------------------------------------- //
  // GET RECHARGE STATUS
  // --------------------------------------------------------------------- //
  Future<Map<String, dynamic>> getRechargeStatus({
    required String clientId,
    String? token,
  }) async {
    return await get('/api/recharge/status/$clientId', token: token);
  }

  // --------------------------------------------------------------------- //
  // WALLET & PAYMENT (Unchanged)
  // --------------------------------------------------------------------- //
  Future<Map<String, dynamic>> getWalletBalance({required String token}) async {
    return await get('/api/wallet/balance', token: token);
  }

  Future<Map<String, dynamic>> getTransactions({required String token}) async {
    return await get('/api/wallet/transactions', token: token);
  }

  Future<Map<String, dynamic>> getRazorpayPublicKey({String? token}) async {
    return await get('/api/payment/razorpay/key', token: token);
  }

  Future<Map<String, dynamic>> createRazorpayOrder({
    required String token,
    required double amount,
  }) async {
    return await post('/api/payment/razorpay/order', {'amount': amount}, token: token);
  }

  Future<Map<String, dynamic>> verifyRazorpayPayment({
    required String token,
    required String orderId,
    required String paymentId,
    required String signature,
    required double amount,
  }) async {
    return await post(
      '/api/payment/razorpay/verify',
      {
        'razorpay_order_id': orderId,
        'razorpy_payment_id': paymentId,
        'razorpay_signature': signature,
        'amount': amount,
      },
      token: token,
    );
  }

  // --------------------------------------------------------------------- //
  // Helpers
  // --------------------------------------------------------------------- //
  Map<String, String> _getHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      return body.isEmpty ? {'success': true} : jsonDecode(body);
    } else {
      try {
        final errorData = jsonDecode(body);
        throw ApiException(
          statusCode: statusCode,
          message: errorData['message'] ?? errorData['error'] ?? 'Unknown error',
        );
      } catch (_) {
        throw ApiException(
          statusCode: statusCode,
          message: 'HTTP $statusCode: ${response.reasonPhrase}',
        );
      }
    }
  }

  Exception _handleError(dynamic error) {
    if (error is ApiException) return error;
    if (error is SocketException) {
      return ApiException(statusCode: 0, message: 'No internet connection');
    }
    if (error is TimeoutException) {
      return ApiException(statusCode: 408, message: 'Request timed out');
    }
    return ApiException(statusCode: -1, message: 'Unexpected error: $error');
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException({required this.statusCode, required this.message});
  @override
  String toString() => 'ApiException($statusCode): $message';
}
