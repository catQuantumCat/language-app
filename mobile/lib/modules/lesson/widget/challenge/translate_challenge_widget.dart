import 'package:flutter/material.dart';
import 'package:language_app/modules/lesson/widget/challenge/base_challenge_widget.dart';

class TranslateChallengeWidget extends BaseChallengeWidget<String> {
  TranslateChallengeWidget(
      {super.key,
      required super.challenge,
      required super.onAnswerTapped,
      required super.onContinueTapped});

  final controller = TextEditingController();

  @override
  Widget continueButton() {
    return TextButton(
        onPressed: () {
          onAnswerTapped(controller.text);
          onContinueTapped();
        },
        child: Text("Continue"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        questionStack(),
        Expanded(
            child: SizedBox(
                height: 90,
                child: TextField(
                  controller: controller,
                ))),
        continueButton()
      ],
    );
  }
}
