import 'package:flutter/material.dart';

import 'app_color.dart';

class IpayTextstyle{
  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
        fontSize: 24.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }
  static TextStyle AllboldTextFieldStyle() {
    return const TextStyle(
        fontSize: 18.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle AppBarTextStyle() {
    return const TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }
  static TextStyle AppBarColorTextStyle() {
    return TextStyle(
        fontSize: 22.0,
        color: IpayColor.primaryColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle UseNameTextStyle() {
    return const TextStyle(
        fontSize: 20.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle headlineTextFieldStyle() {
    return const TextStyle(
        fontSize: 32.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle subTextFieldStyle() {
    return const TextStyle(
        fontSize: 12.0,
        color: Colors.black54,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins');
  }

  static TextStyle smallTextFieldStyle() {
    return const TextStyle(
        fontSize: 10.0,
        color: Colors.black45,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }

  static TextStyle subBoldFieldStyle() {
    return const TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }

  static TextStyle LinkBoldFieldStyle() {
    return TextStyle(
        fontSize: 16.0,
        color:IpayColor.primaryColor,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }

  static TextStyle AddToCartText() {
    return const TextStyle(
        fontSize: 18.0,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }
  static TextStyle AddToCartText2() {
    return const TextStyle(
        fontSize: 18.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }

  static TextStyle subBoldTextFieldStyle() {
    return const TextStyle(
        fontSize: 14.0,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }
}