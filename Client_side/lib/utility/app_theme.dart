import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData lightAppTheme = ThemeData(
    fontFamily: 'SF Pro Rounded',
    colorSchemeSeed: AppColor.primary, // Jundullah orange/gold
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: AppColor.primary, // Jundullah orange
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: AppColor.primary.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColor.primary),
    ),
    iconTheme: IconThemeData(color: AppColor.primary),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      headlineSmall: TextStyle(fontSize: 15, color: Colors.grey),
      titleLarge: TextStyle(fontSize: 12),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColor.primary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColor.primary),
    ),
  );
}
