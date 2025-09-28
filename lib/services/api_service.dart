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

  // -------------------------
  // Generic GET request
  // -------------------------
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

  // -------------------------
  // Generic POST request
  // -------------------------
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

  // -------------------------
  // Auth
  // -------------------------
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    return await post('/api/auth/send-otp', {'phone': phone});
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    return await post('/api/auth/verify-otp', {'phone': phone, 'otp': otp});
  }

  // -------------------------
  // Recharge
  // -------------------------
  Future<Map<String, dynamic>> getBalance({String? token}) async {
    return await get('/api/recharge/balance', token: token);
  }

  Future<Map<String, dynamic>> getOperators({String? token}) async {
    return await get('/api/recharge/operators', token: token);
  }

  Future<Map<String, dynamic>> getCircles({String? token}) async {
    return await get('/api/recharge/circles', token: token);
  }

  Future<Map<String, dynamic>> getPlans(
      String operatorId,
      String circleId, {
        String? token,
      }) async {
    return await get(
      '/api/recharge/plans?operatorId=$operatorId&circleId=$circleId',
      token: token,
    );
  }

  Future<Map<String, dynamic>> performRecharge(
      String mobileNumber,
      String operatorId,
      String circleId,
      double amount, {
        String? token,
      }) async {
    return await post(
      '/api/recharge/recharge',
      {
        'mobileNumber': mobileNumber,
        'operatorId': operatorId,
        'circleId': circleId,
        'amount': amount,
      },
      token: token,
    );
  }

  Future<Map<String, dynamic>> getRechargeStatus(
      String clientId, {
        String? token,
      }) async {
    return await get('/api/recharge/status/$clientId', token: token);
  }

  // -------------------------
  // Wallet
  // -------------------------
  Future<Map<String, dynamic>> getWalletBalance({required String token}) async {
    return await get('/api/wallet/balance', token: token);
  }

  Future<Map<String, dynamic>> addMoneyToWallet({
    required String token,
    required double amount,
    required String paymentMethod,
    String? paymentId,
  }) async {
    return await post(
      '/api/wallet/add-money',
      {
        'amount': amount,
        'paymentMethod': paymentMethod,
        if (paymentId != null) 'paymentId': paymentId,
      },
      token: token,
    );
  }

  Future<Map<String, dynamic>> getRazorpayPublicKey({String? token}) async {
    return await get('/api/wallet/razorpay/key', token: token);
  }

  Future<Map<String, dynamic>> createRazorpayOrder({
    required String token,
    required double amount,
  }) async {
    return await post(
      '/api/wallet/razorpay/order',
      {'amount': amount},
      token: token,
    );
  }

  Future<Map<String, dynamic>> verifyRazorpayPayment({
    required String token,
    required String orderId,
    required String paymentId,
    required String signature,
    required double amount,
  }) async {
    return await post(
      '/api/wallet/razorpay/verify',
      {
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
        'amount': amount,
      },
      token: token,
    );
  }

  Future<Map<String, dynamic>> getWalletSummary({required String token}) async {
    return await get('/api/wallet/summary', token: token);
  }

  Future<Map<String, dynamic>> getWalletTransactions({
    required String token,
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (type != null) 'type': type,
      if (status != null) 'status': status,
    };

    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return await get(
      '/api/wallet/transactions${query.isNotEmpty ? '?$query' : ''}',
      token: token,
    );
  }

  // -------------------------
  // Helpers
  // -------------------------
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
          message: errorData['message'] ??
              errorData['error'] ??
              'Unknown error occurred',
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
      return ApiException(
        statusCode: 0,
        message: 'No internet connection. Please check your network.',
      );
    }

    if (error is TimeoutException) {
      return ApiException(
        statusCode: 408,
        message: 'Request timed out. Please try again.',
      );
    }

    return ApiException(
      statusCode: -1,
      message: 'Unexpected error: ${error.toString()}',
    );
  }

  void dispose() {
    _client.close();
  }
}

// -------------------------
// Custom Exception
// -------------------------
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
