import 'package:json_annotation/json_annotation.dart';
import 'package:language_app/data/models/challenge_option.dart';

part "challenge_data.g.dart";

abstract class ChallengeData<T> {
  bool checkAnswer(T userAnswer);
}

@JsonSerializable(createToJson: false)
class TranslateChallengeData extends ChallengeData<String> {
  TranslateChallengeData(
      {required this.acceptedAnswer, required this.translateWord});

  List<String> acceptedAnswer;
  String translateWord;
  @override
  bool checkAnswer(userAnswer) {
    return acceptedAnswer.contains(userAnswer.toLowerCase());
  }

  factory TranslateChallengeData.fromJson(Map<String, dynamic> json) =>
      _$TranslateChallengeDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class MultipleChoiceChallengeData extends ChallengeData<MultipleChoiceOption> {
  MultipleChoiceChallengeData({required this.options});

  List<MultipleChoiceOption> options;

  @override
  bool checkAnswer(userAnswer) {
    return userAnswer.correct;
  }

  factory MultipleChoiceChallengeData.fromJson(Map<String, dynamic> json) =>
      _$MultipleChoiceChallengeDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class SentenceOrderChallengeData
    extends ChallengeData<List<SentenceOrderOption>> {
  List<SentenceOrderOption> options;
  int optionLength;

  SentenceOrderChallengeData({
    required this.options,
    required this.optionLength,
  });

  @override
  bool checkAnswer(List<SentenceOrderOption> userAnswer) {
    if (userAnswer.length != optionLength) return false;

    for (int i = 0; i < optionLength; i++) {
      if (userAnswer[i].order != i + 1) return false;
    }
    return true;
  }

  factory SentenceOrderChallengeData.fromJson(Map<String, dynamic> json) =>
      _$SentenceOrderChallengeDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class PairMatchingChallengeData extends ChallengeData<bool> {
  List<PairMatchingOption> options;

  PairMatchingChallengeData({
    required this.options,
  });

  @override
  bool checkAnswer(bool userAnswer) {
    return userAnswer;
  }

  bool checkPair(PairMatchingOption left, PairMatchingOption right) {
    return left.pairId == right.pairId;
  }

  factory PairMatchingChallengeData.fromJson(Map<String, dynamic> json) =>
      _$PairMatchingChallengeDataFromJson(json);
}
