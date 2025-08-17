import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Getters to access the state
  PageController get pageController => _pageController;
  int get currentPage => _currentPage;

  // Method to update the current page
  void updateCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  // Dispose the controller when the provider is no longer needed
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}