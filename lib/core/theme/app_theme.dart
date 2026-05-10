import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF92C7FC);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      scaffoldBackgroundColor: Colors.white,
    );
  }
}