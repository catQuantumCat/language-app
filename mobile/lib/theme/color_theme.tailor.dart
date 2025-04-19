// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_theme.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$ColorThemeTailorMixin on ThemeExtension<ColorTheme> {
  Color get textPrimary;
  Color get primary;
  Color get onPrimary;
  Color get selection;
  Color get onSelection;
  Color get correct;
  Color get onCorrect;
  Color get error;
  Color get onError;
  Color get wrong;
  Color get onWrong;
  Color get warning;
  Color get onWarning;
  Color get button;
  Color get onButton;
  Color get background;
  Color get border;
  Color get progressBarBackground;
  Color get selectedAnswerBackground;
  Color get heartColor;
  Color get lessonCardBackground;
  Color get streakFireColor;

  @override
  ColorTheme copyWith({
    Color? textPrimary,
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
    Color? lessonCardBackground,
    Color? streakFireColor,
  }) {
    return ColorTheme(
      textPrimary: textPrimary ?? this.textPrimary,
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
      onWarning: onWarning ?? this.onWarning,
      button: button ?? this.button,
      onButton: onButton ?? this.onButton,
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
  ColorTheme lerp(covariant ThemeExtension<ColorTheme>? other, double t) {
    if (other is! ColorTheme) return this as ColorTheme;
    return ColorTheme(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ColorTheme &&
            const DeepCollectionEquality()
                .equals(textPrimary, other.textPrimary) &&
            const DeepCollectionEquality().equals(primary, other.primary) &&
            const DeepCollectionEquality().equals(onPrimary, other.onPrimary) &&
            const DeepCollectionEquality().equals(selection, other.selection) &&
            const DeepCollectionEquality()
                .equals(onSelection, other.onSelection) &&
            const DeepCollectionEquality().equals(correct, other.correct) &&
            const DeepCollectionEquality().equals(onCorrect, other.onCorrect) &&
            const DeepCollectionEquality().equals(error, other.error) &&
            const DeepCollectionEquality().equals(onError, other.onError) &&
            const DeepCollectionEquality().equals(wrong, other.wrong) &&
            const DeepCollectionEquality().equals(onWrong, other.onWrong) &&
            const DeepCollectionEquality().equals(warning, other.warning) &&
            const DeepCollectionEquality().equals(onWarning, other.onWarning) &&
            const DeepCollectionEquality().equals(button, other.button) &&
            const DeepCollectionEquality().equals(onButton, other.onButton) &&
            const DeepCollectionEquality()
                .equals(background, other.background) &&
            const DeepCollectionEquality().equals(border, other.border) &&
            const DeepCollectionEquality()
                .equals(progressBarBackground, other.progressBarBackground) &&
            const DeepCollectionEquality().equals(
                selectedAnswerBackground, other.selectedAnswerBackground) &&
            const DeepCollectionEquality()
                .equals(heartColor, other.heartColor) &&
            const DeepCollectionEquality()
                .equals(lessonCardBackground, other.lessonCardBackground) &&
            const DeepCollectionEquality()
                .equals(streakFireColor, other.streakFireColor));
  }

  @override
  int get hashCode {
    return Object.hashAll([
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(textPrimary),
      const DeepCollectionEquality().hash(primary),
      const DeepCollectionEquality().hash(onPrimary),
      const DeepCollectionEquality().hash(selection),
      const DeepCollectionEquality().hash(onSelection),
      const DeepCollectionEquality().hash(correct),
      const DeepCollectionEquality().hash(onCorrect),
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(onError),
      const DeepCollectionEquality().hash(wrong),
      const DeepCollectionEquality().hash(onWrong),
      const DeepCollectionEquality().hash(warning),
      const DeepCollectionEquality().hash(onWarning),
      const DeepCollectionEquality().hash(button),
      const DeepCollectionEquality().hash(onButton),
      const DeepCollectionEquality().hash(background),
      const DeepCollectionEquality().hash(border),
      const DeepCollectionEquality().hash(progressBarBackground),
      const DeepCollectionEquality().hash(selectedAnswerBackground),
      const DeepCollectionEquality().hash(heartColor),
      const DeepCollectionEquality().hash(lessonCardBackground),
      const DeepCollectionEquality().hash(streakFireColor),
    ]);
  }
}

extension ColorThemeBuildContextProps on BuildContext {
  ColorTheme get colorTheme => Theme.of(this).extension<ColorTheme>()!;
  Color get textPrimary => colorTheme.textPrimary;
  Color get primary => colorTheme.primary;
  Color get onPrimary => colorTheme.onPrimary;
  Color get selection => colorTheme.selection;
  Color get onSelection => colorTheme.onSelection;
  Color get correct => colorTheme.correct;
  Color get onCorrect => colorTheme.onCorrect;
  Color get error => colorTheme.error;
  Color get onError => colorTheme.onError;
  Color get wrong => colorTheme.wrong;
  Color get onWrong => colorTheme.onWrong;
  Color get warning => colorTheme.warning;
  Color get onWarning => colorTheme.onWarning;
  Color get button => colorTheme.button;
  Color get onButton => colorTheme.onButton;
  Color get background => colorTheme.background;
  Color get border => colorTheme.border;
  Color get progressBarBackground => colorTheme.progressBarBackground;
  Color get selectedAnswerBackground => colorTheme.selectedAnswerBackground;
  Color get heartColor => colorTheme.heartColor;
  Color get lessonCardBackground => colorTheme.lessonCardBackground;
  Color get streakFireColor => colorTheme.streakFireColor;
}
