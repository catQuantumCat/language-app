import 'package:flutter/material.dart';
import 'package:language_app/data/models/challenge_data.dart';
import 'package:language_app/data/models/challenge_option.dart';
import 'package:language_app/modules/lesson/widget/challenge/base_challenge_widget.dart';

class MultipleChoicesChallengeWidget extends BaseChallengeWidget<ChallengeOption> {
  const MultipleChoicesChallengeWidget(
      {super.key,
      required super.challenge,
      required super.onAnswerTapped,
      required super.onContinueTapped});


  

  @override
  Widget build(BuildContext context) {
    final MultipleChoiceChallengeData data =
        challenge.data as MultipleChoiceChallengeData;
    return Column(
      children: [
        questionStack(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              data.options.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ElevatedButton(
                  onPressed: () => onAnswerTapped(data.options[index]),
                  child: Text(data.options[index].text),
                ),
              ),
            ),
          ),
        ),
        continueButton()
      ],
    );
  }
}
