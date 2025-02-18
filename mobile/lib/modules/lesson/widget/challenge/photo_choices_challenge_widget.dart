import 'package:flutter/material.dart';
import 'package:language_app/data/models/challenge_data.dart';
import 'package:language_app/modules/lesson/widget/challenge/base_challenge_widget.dart';

class PhotoChoicesChallengeWidget extends BaseChallengeWidget {
  const PhotoChoicesChallengeWidget(
      {super.key, required super.challenge, required super.onAnswerTapped, required super.onContinueTapped});

  @override
  Widget build(BuildContext context) {
    final data = challenge.data as MultipleChoiceChallengeData;
    return Column(
      children: [
        questionStack(),
        Expanded(
          child: Center(
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: data.options
                  .map(
                    (option) => InkWell(
                      onTap: () {
                        onAnswerTapped(option);
                      },
                      child: Container(
                          color: Colors.amber,
                          child: Center(
                            child: Text(option.text),
                          )),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        continueButton()
      ],
    );
  }
}
