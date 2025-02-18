import 'package:flutter/material.dart';
import 'package:language_app/data/models/challenge.dart';
import 'package:language_app/modules/lesson/widget/challenge/multiple_choices_challenge_widget.dart';
import 'package:language_app/modules/lesson/widget/challenge/photo_choices_challenge_widget.dart';
import 'package:language_app/modules/lesson/widget/challenge/translate_challenge_widget.dart';

class ChallengeWidgetFactory {
  static BaseChallengeWidget produce(
      {required Challenge challenge,
      required void Function(dynamic userAnswer) onAnswerTapped,
      required void Function() onContinueTapped}) {
    switch (challenge.type) {
      case ChallengeType.multipleChoice:
        return MultipleChoicesChallengeWidget(
          challenge: challenge,
          onAnswerTapped: onAnswerTapped,
          onContinueTapped: onContinueTapped,
        );

      case ChallengeType.multipleChoiceWithImages:
        return PhotoChoicesChallengeWidget(
          challenge: challenge,
          onAnswerTapped: onAnswerTapped,
          onContinueTapped: onContinueTapped,
        );
      case ChallengeType.translateWritten:
        return TranslateChallengeWidget(
            challenge: challenge, onAnswerTapped: onAnswerTapped, onContinueTapped: onContinueTapped,);
      default:
        throw UnimplementedError();
    }
  }
}

abstract class BaseChallengeWidget extends StatelessWidget {
  const BaseChallengeWidget(
      {super.key,
      required this.challenge,
      required this.onAnswerTapped,
      required this.onContinueTapped});

  final Challenge challenge;
  final void Function(dynamic userAnswer) onAnswerTapped;
  final void Function() onContinueTapped;

  @override
  Widget build(BuildContext context);

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

  Widget continueButton() {
    return TextButton(onPressed: () => onContinueTapped(), child: Text("Continue"));
  }
}
