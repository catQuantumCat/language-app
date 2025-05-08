// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'color_theme.tailor.dart';

final class RawColors {
  static const darkGreen = Color(0xFF58A700);

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

@TailorMixin()
class ColorTheme extends ThemeExtension<ColorTheme>
    with _$ColorThemeTailorMixin {
  //Text
  @override
  final Color textPrimary;

  @override
  final Color primary;
  @override
  final Color onPrimary;
  @override
  final Color selection;
  @override
  final Color onSelection;
  @override
  final Color correct;
  @override
  final Color onCorrect;
  @override
  final Color error;
  @override
  final Color onError;
  @override
  final Color wrong;
  @override
  final Color onWrong;
  @override
  final Color warning;
  @override
  final Color onWarning;

  @override
  final Color button;
  @override
  final Color onButton;

  @override
  final Color background;
  @override
  final Color border;

  @override
  final Color progressBarBackground;
  @override
  final Color selectedAnswerBackground;
  @override
  final Color heartColor;

  @override
  final Color lessonCardBackground;
  @override
  final Color streakFireColor;
  ColorTheme({
    required this.textPrimary,
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

  // Light theme version
  static final light = ColorTheme(
    textPrimary: RawColors.darkGreen,
    primary: RawColors.green,
    onPrimary: RawColors.white,
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
