// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:language_app/modules/lesson/bloc/lesson_bloc.dart';

import 'package:language_app/theme/color_theme.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

@TailorMixin()
class CustomButtonTheme extends ThemeExtension<CustomButtonTheme> {
  //Base button
  final ButtonStyle filledButton;
  //System button
  final ButtonStyle primaryButton;
  final ButtonStyle errorFilledButton;

  //Answer button
  final ButtonStyle correctButton;
  final ButtonStyle wrongButton;
  final ButtonStyle selectedButton;
  CustomButtonTheme({
    required this.filledButton,
    required this.primaryButton,
    required this.errorFilledButton,
    required this.correctButton,
    required this.wrongButton,
    required this.selectedButton,
  });

  //Specific button

  //Get
  factory CustomButtonTheme.palette(ColorTheme colorTheme) {
    final baseButtonStyle = FilledButton.styleFrom(
      backgroundColor: colorTheme.button,
      foregroundColor: colorTheme.onButton,
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: colorTheme.border, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(
          Radius.circular(12),
        ),
      ),
    ).copyWith(
      elevation: WidgetStateProperty.resolveWith<double>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return 0;
          }
          return 4;
        },
      ),
      // ignore: deprecated_member_use
      shadowColor: WidgetStateProperty.all(colorTheme.border.withOpacity(0.5)),
    );

    final primaryButton = baseButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(colorTheme.primary),
      foregroundColor: WidgetStateProperty.all(colorTheme.onPrimary),
      side: WidgetStateProperty.all(
        BorderSide(color: colorTheme.primary),
      ),
    );

    final errorFilled = baseButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(colorTheme.wrong),
      foregroundColor: WidgetStateProperty.all(colorTheme.onWrong),
      side: WidgetStateProperty.all(
        BorderSide(color: colorTheme.wrong),
      ),
    );

    final correctOutlined = baseButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(colorTheme.onCorrect),
      foregroundColor: WidgetStateProperty.all(colorTheme.correct),
      side: WidgetStateProperty.all(
        BorderSide(color: colorTheme.correct),
      ),
    );

    final wrongOutlined = baseButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(colorTheme.onWrong),
      foregroundColor: WidgetStateProperty.all(colorTheme.wrong),
      side: WidgetStateProperty.all(
        BorderSide(color: colorTheme.wrong),
      ),
    );

    final selectedOutlined = baseButtonStyle.copyWith(
      backgroundColor: WidgetStatePropertyAll(colorTheme.onSelection),
      foregroundColor: WidgetStatePropertyAll(colorTheme.selection),
      side: WidgetStatePropertyAll(        BorderSide(color: colorTheme.selection))    );

    return CustomButtonTheme(
      filledButton: baseButtonStyle,
      primaryButton: primaryButton,
      errorFilledButton: errorFilled,
      correctButton: correctOutlined,
      wrongButton: wrongOutlined,
      selectedButton: selectedOutlined,
    );
  }

  ButtonStyle getButtonStyleFromStatus(AnswerStatus status,
      {bool isSelected = false}) {
    if (isSelected) {
      switch (status) {
        case AnswerStatus.correct:
          return correctButton;
        case AnswerStatus.wrong:
          return wrongButton;
        case AnswerStatus.none:
          return selectedButton;
      }
    }
    return filledButton;
  }

  @override
  ThemeExtension<CustomButtonTheme> copyWith(
      {ButtonStyle? filledButton,
      ButtonStyle? primaryButton,
      ButtonStyle? errorFilledButton,
      ButtonStyle? correctButton,
      ButtonStyle? wrongButton,
      ButtonStyle? selectedButton}) {
    return CustomButtonTheme(
        filledButton: filledButton ?? this.filledButton,
        primaryButton: primaryButton ?? this.primaryButton,
        errorFilledButton: errorFilledButton ?? this.errorFilledButton,
        correctButton: correctButton ?? this.correctButton,
        wrongButton: wrongButton ?? this.wrongButton,
        selectedButton: selectedButton ?? this.selectedButton);
  }

  @override
  ThemeExtension<CustomButtonTheme> lerp(
      ThemeExtension<CustomButtonTheme>? other, double t) {
    if (other is! CustomButtonTheme) return this;

    return CustomButtonTheme(
      filledButton: ButtonStyle.lerp(filledButton, other.filledButton, t)!,
      primaryButton: ButtonStyle.lerp(primaryButton, other.primaryButton, t)!,
      errorFilledButton:
          ButtonStyle.lerp(errorFilledButton, other.errorFilledButton, t)!,
      correctButton: ButtonStyle.lerp(correctButton, other.correctButton, t)!,
      wrongButton: ButtonStyle.lerp(wrongButton, other.wrongButton, t)!,
      selectedButton:
          ButtonStyle.lerp(selectedButton, other.selectedButton, t)!,
    );
  }
}
