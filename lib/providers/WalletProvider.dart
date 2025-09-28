// lib/ui/Wallet/provider/ipay_wallet_provider.dart
import 'package:flutter/material.dart';
import 'package:ipay/services/api_service.dart';
import 'package:ipay/providers/enhanced_auth_provider.dart';
import 'package:provider/provider.dart';

class IpayWalletProvider extends ChangeNotifier {
  double _balance = 0.0;
  bool _loading = false;
  bool _txLoading = false;

  double get balance => _balance;
  bool get loading => _loading;
  bool get txLoading => _txLoading;

  Future<void> refreshBalance(BuildContext context) async {
    try {
      _loading = true;
      notifyListeners();
      final auth = Provider.of<EnhancedAuthProvider>(context, listen: false);
      if (auth.token == null) return;
      final res = await ApiService().getWalletBalance(token: auth.token!);
      final amount = res['data']?['amount'];
      if (amount is num) {
        _balance = amount.toDouble();
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  final List<Map<String, dynamic>> _recentTransactions = [];

  // Expose the transactions list via a getter.
  List<Map<String, dynamic>> get recentTransactions => _recentTransactions;

  // Fetch transactions from backend
  Future<void> fetchTransactions(BuildContext context) async {
    try {
      _txLoading = true;
      notifyListeners();
      final auth = Provider.of<EnhancedAuthProvider>(context, listen: false);
      if (auth.token == null) return;
      final res = await ApiService().getWalletTransactions(token: auth.token!);
      final txs = res['data']?['transactions'];
      _recentTransactions.clear();
      if (txs is List) {
        for (final t in txs) {
          // Map backend fields to UI structure expected by TransactionsHistory widget
          _recentTransactions.add({
            'id': t['_id'] ?? t['transactionId'] ?? '',
            'type': t['description'] ?? (t['type'] == 'credit' ? 'Wallet Top-up' : 'Debit'),
            'name': '',
            'amount': '₹${(t['amount'] ?? 0).toString()}',
            'status': (t['status'] ?? '').toString().toLowerCase() == 'success' ? 'success' : 'pending',
            'date': (t['createdAt'] ?? '').toString(),
            'operator': t['metadata']?['paymentMethod'] ?? (t['type'] ?? ''),
            'TransactionID': t['transactionId'] ?? '',
            'image': (t['type'] ?? 'credit') == 'credit' ? '⬆️' : '⬇️',
          });
        }
      }
    } catch (_) {
      // swallow for now; UI can show empty state
    } finally {
      _txLoading = false;
      notifyListeners();
    }
  }

  // You can add methods here to modify the state.
  // For example, to add a new transaction.
  void addTransaction(Map<String, dynamic> transaction) {
    _recentTransactions.add(transaction);
    notifyListeners(); // Important: Notify listeners to rebuild the UI.
  }
}
