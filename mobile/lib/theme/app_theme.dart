import 'package:flutter/material.dart';
import 'package:language_app/theme/button_theme.dart';
import 'package:language_app/theme/color_theme.dart';

class AppTheme {
  final ColorTheme colorTheme;
  final CustomButtonTheme buttonTheme;

  final ThemeData themeData;

  AppTheme({required this.colorTheme, required this.buttonTheme})
      : themeData = ThemeData(
          colorSchemeSeed: colorTheme.primary,
          scaffoldBackgroundColor: colorTheme.background,
          dividerColor: colorTheme.border,
          extensions: [colorTheme, buttonTheme],
        );
}
