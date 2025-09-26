import 'package:flutter/material.dart';

class IpaySize{
  static const EdgeInsetsGeometry PaddingWithAppBarHeight = EdgeInsets.only(
    top: appBarHeight,
    left: defaultSpace,
    right: defaultSpace,
    bottom: defaultSpace,
  );

  //appbar height
  static const double appBarHeight = 56.0;

  // Default Spacing
  static const double defaultSpace = 24.0;
  static const double spaceBtwItems = 16.0;
  static const double spaceBtwItemsSm = 8.0;
  static const double spaceBtwItemsMd = 12.0;
  static const double spaceBtwSections = 32.0;

  // Border Radius
  static const double borderRadiusSm = 5.0;
  static const double borderRadiusMd = 10.0;
  static const double borderRadiusLg = 15.0;
  static const double borderRadiusXL = 24.0;

  // Button Sizes
  static const double buttonHeight = 20.0;
  static const double buttonElevation = 4.0;
  static const double defaultElevation = 1.0;
  static const double buttonRadius = 20.0;
  static const double buttonWidth = 120.0;

  // Input Field
  static const double inputFieldRadius = 12.0;
  static const double spaceBtwInputFields = 16.0;

  // Padding and Margin
  static const double xs = 5.0;
  static const double sm = 10.0;
  static const double md = 18.0;
  static const double lg = 25.0;
  static const double xl = 32.0;

  // Icon Sizes
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  // Product Item Dimensions
  static const double productImageSize = 120.0;
  static const double productImageRadius = 16.0;

  // Card Sizes
  static const double cardRadiusLg = 16.0;
  static const double cardRadiusMd = 12.0;
  static const double cardRadiusSm = 10.0;
  static const double cardRadiusXs = 6.0;
  static const double cardElevation = 2.0;

  //grid view spacing
  static const double gridviewSpacing = 12.0;

  //Box shadow
  static final productShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );

}