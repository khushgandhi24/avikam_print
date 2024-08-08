import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color.fromRGBO(3, 86, 149, 1);
  static Color secondaryColor = const Color.fromRGBO(229, 122, 18, 1);
  static Color tertiaryColor = const Color.fromRGBO(172, 225, 175, 1);
  static Color surfaceColor = const Color.fromRGBO(254, 253, 255, 1);
  static Color darkSurfaceColor = const Color.fromRGBO(1, 0, 1, 1);
  static Color errorColor = const Color.fromRGBO(195, 60, 84, 1);
}

ThemeData primaryTheme = ThemeData(
    useMaterial3: true,
    //Seed Color
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    scaffoldBackgroundColor: AppColors.surfaceColor,
    appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryColor,
        titleTextStyle: TextStyle(color: AppColors.surfaceColor, fontSize: 22)),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColors.secondaryColor, width: 4)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondaryColor, width: 4)),
    ));
