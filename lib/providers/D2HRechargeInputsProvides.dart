// D2HRechargeInputsProvides.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DthRechargeInputsProvider with ChangeNotifier {
  final TextEditingController _amountController = TextEditingController();
  final List<int> quickAmounts = [99, 199, 299, 499, 799, 999];
  int? _selectedQuickAmount;
  bool _isProcessing = false;

  TextEditingController get amountController => _amountController;
  int? get selectedQuickAmount => _selectedQuickAmount;
  bool get isProcessing => _isProcessing;

  void selectQuickAmount(int amount) {
    _selectedQuickAmount = amount;
    _amountController.text = amount.toString();
    notifyListeners();
    HapticFeedback.lightImpact();
  }

  void onAmountChanged(String value) {
    _selectedQuickAmount = null;
    notifyListeners();
  }

  // FIX: Add the missing clearAmount method
  void clearAmount() {
    _amountController.clear();
    notifyListeners();
  }

  Future<void> processRecharge(
      BuildContext context,
      String subscriberId,
      ) async {
    if (_amountController.text.isEmpty) {
      _showSnackBar(context, 'Please enter an amount', Colors.orange);
      return;
    }

    _isProcessing = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isProcessing = false;
    notifyListeners();

    _showSnackBar(context, 'Recharge for $subscriberId initiated successfully!', Colors.green);
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}