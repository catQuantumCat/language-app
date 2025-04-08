import 'package:flutter/material.dart';
import 'package:language_app/theme/button_theme.dart';
import 'package:language_app/theme/color_theme.dart';

extension ContextExtension on BuildContext {
  ColorTheme get colorTheme => Theme.of(this).extension<ColorTheme>()!;

  CustomButtonTheme get customButtomTheme =>
      Theme.of(this).extension<CustomButtonTheme>()!;
}
