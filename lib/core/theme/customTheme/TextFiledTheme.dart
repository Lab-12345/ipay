import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';

class ITextFiledTheme {
  ITextFiledTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: TextStyle().copyWith(fontSize: 14, color: Colors.black),
    hintStyle: TextStyle().copyWith(fontSize: 14, color: Colors.black),
    errorStyle: TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: TextStyle().copyWith(
      color: Colors.black.withOpacity(0.8),
    ),
    border: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(width: 1.5, color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(width: 1.5,color: Colors.grey)),
    focusedBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(width: 1.5,color: Colors.black12)),
    errorBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(width: 1.5,color: IpayColor.errorColor)),
    focusedErrorBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(width: 1.5,color: IpayColor.warningColor)),
  );
  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: TextStyle().copyWith(fontSize: 14, color: Colors.white),
    hintStyle: TextStyle().copyWith(fontSize: 14, color: Colors.white),
    errorStyle: TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: TextStyle().copyWith(
      color: Colors.black.withOpacity(0.8),
    ),
    border: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(width: 1.5, color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(width: 1.5,color: Colors.grey)),
    focusedBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(width: 1.5,color: Colors.black12)),
    errorBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(width: 1.5,color: IpayColor.errorColor)),
    focusedErrorBorder: OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(width: 1.5,color: IpayColor.warningColor)),
  );
}
