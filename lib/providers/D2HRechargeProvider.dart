import 'package:flutter/material.dart';

class DthRechargeProvider with ChangeNotifier {
  String? _subscriberId;
  String? _providerName;
  Image? _providerImage;

  String? get subscriberId => _subscriberId;
  String? get providerName => _providerName;
  Image? get providerImage => _providerImage;

  void setProviderDetails({
    required String name,
    required Image image,
    required String id,
  }) {
    _providerName = name;
    _providerImage = image;
    _subscriberId = id;
    notifyListeners(); // Notify listeners of state changes
  }

  void clearProviderDetails() {
    _providerName = null;
    _providerImage = null;
    _subscriberId = null;
    notifyListeners();
  }
}