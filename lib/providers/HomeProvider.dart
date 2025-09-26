import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  // Data for the different sections of the home screen
  final List<Map<String, dynamic>> _quickRechargeServices = [
    {
      'id': 'mobile',
      'name': 'Mobile',
      'description': 'Prepaid & Postpaid',
      'image': '📱',
      'colors': [Color(0xFF3B82F6), Color(0xFF2563EB)],
    },
    {
      'id': 'dth',
      'name': 'DTH',
      'description': 'TV Recharge',
      'image': '📺',
      'colors': [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    },
    {
      'id': 'datacard',
      'name': 'Data Card',
      'description': 'Internet Plans',
      'image': '💳',
      'colors': [Color(0xFF10B981), Color(0xFF059669)],
    },
    {
      'id': 'electricity',
      'name': 'Electricity',
      'description': 'Power Bills',
      'image': '⚡',
      'colors': [Color(0xFFF59E0B), Color(0xFFD97706)],
    },
    {
      'id': 'fastag',
      'name': 'FASTag',
      'description': 'Toll Payments',
      'image': '🚗',
      'colors': [Color(0xFF6366F1), Color(0xFF4F46E5)],
    },
    {
      'id': 'googleplay',
      'name': 'Google Play',
      'description': 'Gift Cards',
      'image': '🎮',
      'colors': [Color(0xFFEF4444), Color(0xFFDC2626)],
    },
    {
      'id': 'insurance',
      'name': 'Insurance',
      'description': 'Premium Payments',
      'image': '🛡️',
      'colors': [Color(0xFF14B8A6), Color(0xFF0D9488)],
    },
    {
      'id': 'loan',
      'name': 'Loan EMI',
      'description': 'EMI Payments',
      'image': '💰',
      'colors': [Color(0xFFF97316), Color(0xFFEA580C)],
    },
    {
      'id': 'broadband',
      'name': 'Broadband',
      'description': 'Internet Bills',
      'image': '📶',
      'colors': [Color(0xFF06B6D4), Color(0xFF0891B2)],
    },
    {
      'id': 'subscription',
      'name': 'Subscriptions',
      'description': 'OTT & Apps',
      'image': '📅',
      'colors': [Color(0xFFEC4899), Color(0xFFDB2777)],
    },
  ];

  final List<Map<String, dynamic>> _popularServices = [
    {
      'id': 'netflix',
      'name': 'Netflix',
      'category': 'OTT Platform',
      'image': '🎬',
      'colors': [Color(0xFFDC2626), Color(0xFFB91C1C)],
    },
    {
      'id': 'spotify',
      'name': 'Spotify',
      'category': 'Music Streaming',
      'image': '🎵',
      'colors': [Color(0xFF16A34A), Color(0xFF1ddd61)],
    },
    {
      'id': 'amazon',
      'name': 'Amazon Prime',
      'category': 'Streaming Video',
      'image': '📦',
      'colors': [Color(0xFFEA580C), Color(0xFFDC2626)],
    },
    {
      'id': 'zomato',
      'name': 'Zomato',
      'category': 'Food Delivery',
      'image': '🍕',
      'colors': [Color(0xFFEF4444), Color(0xFFDC2626)],
    },
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'id': 1,
      'type': 'Mobile Recharge',
      'name': 'John Doe',
      'amount': '₹200.00',
      'status': 'success',
      'date': 'Today, 9:30 AM',
      'operator': 'Airtel',
      'image': '📱',
    },
    {
      'id': 2,
      'type': 'DTH Recharge',
      'name': 'Jane Smith',
      'amount': '₹350.00',
      'status': 'success',
      'date': 'Yesterday, 8:15 PM',
      'operator': 'Tata Sky',
      'image': '📺',
    },
    {
      'id': 3,
      'type': 'FASTag Recharge',
      'name': 'Mike Johnson',
      'amount': '₹500.00',
      'status': 'Pending',
      'date': 'Yesterday, 2:45 PM',
      'operator': 'ICICI Bank',
      'image': '🚗',
    },
    {
      'id': 4,
      'type': 'Gas Recharge',
      'name': 'Mike Johnson',
      'amount': '₹901.50',
      'status': 'success',
      'date': 'Yesterday, 5:32 AM',
      'operator': 'SBI Bank',
      'image': '⛽',
    },
  ];

  double _walletBalance = 1523.46;

  // Public getters to access the private data
  List<Map<String, dynamic>> get quickRechargeServices => _quickRechargeServices;
  List<Map<String, dynamic>> get popularServices => _popularServices;
  List<Map<String, dynamic>> get recentTransactions => _recentTransactions;
  double get walletBalance => _walletBalance;

  /// Function to update the wallet balance
  /// When this is called, it will notify all listening widgets to rebuild.
  void updateWalletBalance(double newBalance) {
    _walletBalance = newBalance;
    notifyListeners();
  }
}