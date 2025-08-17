import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/theme/customTheme/AppbarTheme.dart';
import 'package:ipay/core/theme/customTheme/BottomsheetTheme.dart';
import 'package:ipay/core/theme/customTheme/ChipTheme.dart';
import 'package:ipay/core/theme/customTheme/checkboxTheme.dart';
import 'customTheme/ElevationtedButtonTheme.dart';
import 'customTheme/TextFiledTheme.dart';
import 'customTheme/TextTheme.dart';

class IpayTheme {
  IpayTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Ubuntu',
    brightness: Brightness.light,
    primaryColor: IpayColor.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    textTheme: ITextTheme.lightTextTheme,
    elevatedButtonTheme:IElevationtedButtonTheme.lightElevationtedButtonTheme,
    bottomSheetTheme: IBottomsheetTheme.lightBottomSheet,
    chipTheme: IChipTheme.lightChipTheme,
    appBarTheme: IAppbarTheme.lightAppbarTheme,
    checkboxTheme: ICheckBoxTheme.lightCheckboxTheme,
    inputDecorationTheme: ITextFiledTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Ubuntu',
    brightness: Brightness.dark,
    primaryColor: IpayColor.primaryColor,
    scaffoldBackgroundColor: Colors.black,
    textTheme: ITextTheme.darkTextTheme,
    elevatedButtonTheme:IElevationtedButtonTheme.darkElevationtedButtonTheme,
    bottomSheetTheme: IBottomsheetTheme.darkBottomSheet,
    chipTheme: IChipTheme.darkChipTheme,
    appBarTheme: IAppbarTheme.darkAppbarTheme,
    checkboxTheme: ICheckBoxTheme.darkCheckboxTheme,
    inputDecorationTheme: ITextFiledTheme.darkInputDecorationTheme,
  );
}
