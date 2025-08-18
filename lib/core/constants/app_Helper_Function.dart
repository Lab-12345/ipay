import 'package:flutter/material.dart';

import 'app_color.dart';

class IpayHelper {
  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
      fontSize: 24.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static CustomText({
    required String text,
    required double fontSize,
    fontFamily = 'Ubuntu',
    required Color color,
    required FontWeight fontWeight,
    textAlign = TextAlign,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: fontFamily ?? 'Ubuntu',
        color: color,
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.start ?? TextAlign.center,
    );
  }

  static CustomImage({
    required String image,
    required double? height,
    required double? width,
  }) {
    return Image.asset("assets/images/$image", height: height, width: width);
  }
}
