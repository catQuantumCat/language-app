import 'package:flutter/material.dart';
import 'package:language_app/modules/lesson/bloc/lesson_bloc.dart';
import 'package:language_app/modules/lesson/widget/challenge/base_challenge_widget.dart';

// ignore: must_be_immutable
class TranslateChallengeWidget extends BaseChallengeWidget<String> {
  TranslateChallengeWidget(
      {super.key,
      required super.challenge,
      required super.onAnswerTapped,
      required super.answerStatus});

  @override
  Widget bodyWidgetBuilder() {
    return SizedBox(
      height: 90,
      child: TextField(
        onChanged: (val) {
          super.currentAnswer = val;
        },
        enabled: answerStatus == AnswerStatus.none,
      ),
    );
  }
}
