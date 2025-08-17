// lib/providers/AddMoneyProvider.dart
import 'package:flutter/material.dart';

class AddMoneyProvider extends ChangeNotifier {
  final TextEditingController _amountController = TextEditingController();
  String _selectedAmount = '';
  int _selectedPaymentMethod = 0;
  final List<String> quickAmounts = ['50', '100', '250', '500', '1000', '2000'];

  // Getters to expose the private state
  TextEditingController get amountController => _amountController;
  String get selectedAmount => _selectedAmount;
  int get selectedPaymentMethod => _selectedPaymentMethod;

  // Methods to update the state and notify listeners
  void updateSelectedAmount(String value) {
    _selectedAmount = value;
    notifyListeners();
  }

  void updateAmountText(String value) {
    _amountController.text = value;
    _selectedAmount = value; // Keep selectedAmount in sync
    notifyListeners();
  }

  void updateSelectedPaymentMethod(int index) {
    _selectedPaymentMethod = index;
    notifyListeners();
  }

  void clearAmount() {
    _amountController.clear();
    _selectedAmount = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}