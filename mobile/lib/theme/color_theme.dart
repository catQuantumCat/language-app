// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

final class RawColors {
  static const green = Color(0xFF58CC05);
  static const blue = Color(0xFF1DB0F6);
  static const yellow = Color(0xFFFFC800);
  static const red = Color(0xFFFF4C4B);
  static const onGreen = Color(0xFFD7FFB8);
  static const onBlue = Color(0xFFDDF5FF);
  static const onYellow = Color(0xFFFFF5D3);
  static const onRed = Color(0xFFFFDFE0);

  static const white = Color(0xFFF7F7F7);
  static const grey100 = Color(0xFFE5E5E5);

  static const black = Color(0xFF000000);
}

class ColorTheme extends ThemeExtension<ColorTheme> {
  final Color primary;
  final Color onPrimary;
  final Color selection;
  final Color onSelection;
  final Color correct;
  final Color onCorrect;
  final Color error;
  final Color onError;
  final Color wrong;
  final Color onWrong;
  final Color warning;
  final Color onWarning;

  final Color button;
  final Color onButton;

  final Color background;
  final Color border;

  final Color progressBarBackground;
  final Color selectedAnswerBackground;
  final Color heartColor;

  final Color lessonCardBackground;
  final Color streakFireColor;
  ColorTheme({
    required this.primary,
    required this.onPrimary,
    required this.selection,
    required this.onSelection,
    required this.correct,
    required this.onCorrect,
    required this.error,
    required this.onError,
    required this.wrong,
    required this.onWrong,
    required this.warning,
    required this.onWarning,
    required this.button,
    required this.onButton,
    required this.background,
    required this.border,
    required this.progressBarBackground,
    required this.selectedAnswerBackground,
    required this.heartColor,
    required this.lessonCardBackground,
    required this.streakFireColor,
  });

  @override
  ColorTheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? selection,
    Color? onSelection,
    Color? correct,
    Color? onCorrect,
    Color? error,
    Color? onError,
    Color? wrong,
    Color? onWrong,
    Color? warning,
    Color? onWarning,
    Color? button,
    Color? onButton,
    Color? background,
    Color? border,
    Color? progressBarBackground,
    Color? selectedAnswerBackground,
    Color? heartColor,
    Color? characterColor,
    Color? lessonCardBackground,
    Color? streakFireColor,
  }) {
    return ColorTheme(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      selection: selection ?? this.selection,
      onSelection: onSelection ?? this.onSelection,
      correct: correct ?? this.correct,
      onCorrect: onCorrect ?? this.onCorrect,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      wrong: wrong ?? this.wrong,
      onWrong: onWrong ?? this.onWrong,
      warning: warning ?? this.warning,
      button: button ?? this.button,
      onButton: onButton ?? this.onButton,
      onWarning: onWarning ?? this.onWarning,
      background: background ?? this.background,
      border: border ?? this.border,
      progressBarBackground:
          progressBarBackground ?? this.progressBarBackground,
      selectedAnswerBackground:
          selectedAnswerBackground ?? this.selectedAnswerBackground,
      heartColor: heartColor ?? this.heartColor,
      lessonCardBackground: lessonCardBackground ?? this.lessonCardBackground,
      streakFireColor: streakFireColor ?? this.streakFireColor,
    );
  }

  @override
  ColorTheme lerp(ThemeExtension<ColorTheme>? other, double t) {
    if (other is! ColorTheme) {
      return this;
    }
    return ColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      selection: Color.lerp(selection, other.selection, t)!,
      onSelection: Color.lerp(onSelection, other.onSelection, t)!,
      correct: Color.lerp(correct, other.correct, t)!,
      onCorrect: Color.lerp(onCorrect, other.onCorrect, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      wrong: Color.lerp(wrong, other.wrong, t)!,
      onWrong: Color.lerp(onWrong, other.onWrong, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      button: Color.lerp(button, other.button, t)!,
      onButton: Color.lerp(onButton, other.onButton, t)!,
      background: Color.lerp(background, other.background, t)!,
      border: Color.lerp(border, other.border, t)!,
      progressBarBackground:
          Color.lerp(progressBarBackground, other.progressBarBackground, t)!,
      selectedAnswerBackground: Color.lerp(
          selectedAnswerBackground, other.selectedAnswerBackground, t)!,
      heartColor: Color.lerp(heartColor, other.heartColor, t)!,
      lessonCardBackground:
          Color.lerp(lessonCardBackground, other.lessonCardBackground, t)!,
      streakFireColor: Color.lerp(streakFireColor, other.streakFireColor, t)!,
    );
  }

  // Light theme version
  static final light = ColorTheme(
    primary: RawColors.green,
    onPrimary: RawColors.onGreen,
    selection: RawColors.blue,
    onSelection: RawColors.onBlue,
    correct: RawColors.green,
    onCorrect: RawColors.onGreen,
    error: RawColors.red,
    onError: RawColors.onRed,
    wrong: RawColors.red,
    onWrong: RawColors.onRed,
    warning: RawColors.yellow,
    onWarning: RawColors.onYellow,
    button: RawColors.white,
    onButton: RawColors.black,
    background: RawColors.white,
    border: RawColors.grey100,
    progressBarBackground: Color(0xFFE5E5E5),
    selectedAnswerBackground: Color(0xFFE5F1F8),
    heartColor: Color(0xFFFF4B4B),
    lessonCardBackground: Color(0xFFF7F7F7),
    streakFireColor: Color(0xFFFF9600),
  );

  // Dark theme version
  // static final dark = ColorTheme(
  //   primary: RawColors.green,
  //   onPrimary: RawColors.onGreen,
  //   selection: RawColors.blue,
  //   onSelection: RawColors.onBlue,
  //   correct: RawColors.green,
  //   onCorrect: RawColors.onGreen,
  //   error: RawColors.red,
  //   onError: RawColors.onRed,
  //   wrong: RawColors.red,
  //   onWrong: RawColors.onRed,
  //   warning: RawColors.yellow,
  //   onWarning: RawColors.onYellow,
  //   background: RawColors.white,
  //   border: RawColors.grey100,
  //   progressBarBackground: Color(0xFF2C2C2C),
  //   selectedAnswerBackground: Color(0xFF1A3A4A),
  //   heartColor: Color(0xFFFF4B4B),
  //   lessonCardBackground: Color(0xFF2A2A2A),
  //   streakFireColor: Color(0xFFFF9600), onButton: ,
  // );
}
