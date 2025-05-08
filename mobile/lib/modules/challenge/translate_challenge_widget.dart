import 'package:flutter/material.dart';
import 'package:language_app/domain/models/challenge_data.dart';
import 'package:language_app/modules/lesson/bloc/lesson_bloc.dart';
import 'package:language_app/modules/challenge/base_challenge_widget.dart';

// ignore: must_be_immutable
class TranslateChallengeWidget extends BaseChallengeWidget<String> {
  TranslateChallengeWidget(
      {super.key,
      required super.challenge,
      required super.onAnswerTapped,
      required super.answerStatus});

  @override
  Widget bodyWidgetBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text((challenge.data as TranslateChallengeData).translateWord),
        SizedBox(
          height: 90,
          child: TextField(
            onChanged: (val) {
              super.currentAnswer.value = val;
            },
            enabled: answerStatus == AnswerStatus.none,
          ),
        ),
      ],
    );
  }
}
