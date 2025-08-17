import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';

class IElevationtedButtonTheme{
  IElevationtedButtonTheme._();

  static final lightElevationtedButtonTheme= ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      foregroundColor: Colors.white,
      backgroundColor: IpayColor.primaryColor,
      disabledForegroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey,
      side: BorderSide(color: IpayColor.primaryColor),
      padding: EdgeInsets.symmetric(vertical: 18),
      textStyle: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    )
  );


  static final darkElevationtedButtonTheme= ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        foregroundColor: Colors.white,
        backgroundColor: IpayColor.primaryColor,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey,
        side: BorderSide(color: IpayColor.primaryColor),
        padding: EdgeInsets.symmetric(vertical: 18),
        textStyle: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      )
  );

}