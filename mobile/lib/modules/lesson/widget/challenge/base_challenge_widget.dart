import 'package:flutter/material.dart';
import 'package:language_app/data/models/challenge.dart';
import 'package:language_app/data/models/challenge_option.dart';
import 'package:language_app/modules/lesson/bloc/lesson_bloc.dart';
import 'package:language_app/modules/lesson/widget/challenge/multiple_choices_challenge_widget.dart';
import 'package:language_app/modules/lesson/widget/challenge/pair_matching_challenge_widget.dart';
import 'package:language_app/modules/lesson/widget/challenge/sentence_order_challenge_widget.dart';
import 'package:language_app/modules/lesson/widget/challenge/translate_challenge_widget.dart';

class ChallengeWidgetFactory {
  static BaseChallengeWidget produce<T>(
      {required Challenge challenge,
      required void Function(T? userAnswer) onAnswerTapped,
      required AnswerStatus answerStatus}) {
    switch (challenge.type) {
      case ChallengeType.multipleChoice:
        return MultipleChoicesChallengeWidget(
          challenge: challenge,
          onAnswerTapped: onAnswerTapped as void Function(ChallengeOption?),
          answerStatus: answerStatus,
        );

      case ChallengeType.translateWritten:
        return TranslateChallengeWidget(
          challenge: challenge,
          onAnswerTapped: onAnswerTapped as void Function(String?),
          answerStatus: answerStatus,
        );

      case ChallengeType.sentenceOrder:
        return SentenceOrderChallengeWidget(
            challenge: challenge,
            onAnswerTapped:
                onAnswerTapped as void Function(List<ChallengeOption>?),
            answerStatus: answerStatus);

      case ChallengeType.pairMatching:
        return PairMatchingChallengeWidget(
            challenge: challenge,
            onAnswerTapped: onAnswerTapped as void Function(void),
            answerStatus: answerStatus);
    }
  }
}

// ignore: must_be_immutable
abstract class BaseChallengeWidget<T> extends StatelessWidget {
  BaseChallengeWidget(
      {super.key,
      required this.challenge,
      required this.onAnswerTapped,
      required this.answerStatus});

  final Challenge challenge;
  final void Function(T? userAnswer) onAnswerTapped;

  final AnswerStatus answerStatus;
  T? currentAnswer;

  String _getButtonLabel() {
    switch (answerStatus) {
      case AnswerStatus.correct:
        return "Continue";

      case AnswerStatus.wrong:
        return "Got it";

      case AnswerStatus.none:
        return "Check";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        questionStack(),
        SizedBox(height: 16),
        Expanded(
          child: AbsorbPointer(
            absorbing: answerStatus != AnswerStatus.none,
            child: bodyWidgetBuilder(),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                  onPressed: () => onAnswerTapped(currentAnswer),
                  child: Text(_getButtonLabel())),
            ),
          ],
        )
      ],
    );
  }

  Widget bodyWidgetBuilder();
  Widget questionStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Lipsum",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 2),
        Text(
          challenge.question,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
