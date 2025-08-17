// history_provider.dart
import 'package:flutter/material.dart';

// Transaction class
class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final String transactionId;
  final String amount;
  final String date;
  final String time;
  final String status;
  final IconData icon;
  final Color iconColor;

  Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.time,
    required this.status,
    required this.icon,
    required this.iconColor,
  });
}

class HistoryProvider with ChangeNotifier {
  final List<Transaction> _allTransactions = [
    Transaction(
      id: '1',
      title: 'Cash-in',
      subtitle: 'From ABC Bank ATM',
      transactionId: '564925374920',
      amount: '\$ 100.00',
      date: '17 Sep 2023',
      time: '10:34 AM',
      status: 'confirmed',
      icon: Icons.local_gas_station,
      iconColor: Colors.blue,
    ),
    Transaction(
      id: '2',
      title: 'Cashback from purchase',
      subtitle: 'Purchase from Amazon.com',
      transactionId: '685746354298',
      amount: '\$ 1.75',
      date: '16 Sep 2023',
      time: '16:08 PM',
      status: 'confirmed',
      icon: Icons.shopping_cart,
      iconColor: Colors.orange,
    ),
    Transaction(
      id: '3',
      title: 'Transfer to card',
      subtitle: '',
      transactionId: '698094554317',
      amount: '\$ 9000.00',
      date: '16 Sep 2023',
      time: '11:21 AM',
      status: 'confirmed',
      icon: Icons.credit_card,
      iconColor: Colors.purple,
    ),
    Transaction(
      id: '4',
      title: 'Transfer to card',
      subtitle: 'Not enough funds',
      transactionId: '097967542786',
      amount: '\$ 9267.00',
      date: '15 Sep 2023',
      time: '12:11 AM',
      status: 'failed',
      icon: Icons.credit_card,
      iconColor: Colors.red,
    ),
    Transaction(
      id: '5',
      title: 'Cashback from purchase',
      subtitle: 'Purchase from Books.com',
      transactionId: '765230978421',
      amount: '\$ 3.21',
      date: '14 Sep 2023',
      time: '18:59 PM',
      status: 'confirmed',
      icon: Icons.shopping_bag,
      iconColor: Colors.green,
    ),
    Transaction(
      id: '6',
      title: 'Currency exchange',
      subtitle: '',
      transactionId: '698094554317',
      amount: '\$ 350.00',
      date: '17 Sep 2023',
      time: '11:21 AM',
      status: 'pending',
      icon: Icons.currency_exchange,
      iconColor: Colors.indigo,
    ),
  ];

  List<Transaction> _filteredTransactions = [];
  String _selectedPeriod = 'This week';
  String _selectedStatus = 'All';

  List<Transaction> get filteredTransactions => _filteredTransactions;
  String get selectedPeriod => _selectedPeriod;
  String get selectedStatus => _selectedStatus;

  HistoryProvider() {
    _applyFilters(); // Initial filter application
  }

  void _applyFilters() {
    _filteredTransactions = _allTransactions.where((transaction) {
      // Logic for period filtering (not implemented in the original code, but can be added here)
      bool periodMatch = true;
      bool statusMatch = _selectedStatus == 'All' || transaction.status.toLowerCase() == _selectedStatus.toLowerCase();
      return periodMatch && statusMatch;
    }).toList();
    notifyListeners();
  }

  void updateFilters(String period, String status) {
    _selectedPeriod = period;
    _selectedStatus = status;
    _applyFilters();
  }

  void clearFilters() {
    _selectedPeriod = 'This week';
    _selectedStatus = 'All';
    _applyFilters();
  }
}