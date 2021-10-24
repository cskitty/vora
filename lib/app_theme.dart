import 'package:flutter/material.dart';
import 'colors.dart';

@immutable

class AppTheme {
  static const colors = AppColors();

  const AppTheme._();
  static ThemeData define() {
    return ThemeData(
      primaryColor: Color(0xFF7694BD),
    );
  }
}