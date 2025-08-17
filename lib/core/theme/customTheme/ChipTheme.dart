import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';

class IChipTheme{
  IChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: Colors.grey.withOpacity(0.5),
    labelStyle: TextStyle(color: Colors.black),
    selectedColor: IpayColor.primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
    checkmarkColor: Colors.white,
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.white),
    selectedColor: IpayColor.primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
    checkmarkColor: Colors.white,
  );
}