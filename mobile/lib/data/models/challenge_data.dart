// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:language_app/data/models/challenge_option.dart';

abstract class ChallengeData<T> {
  bool checkAnswer(T userAnswer);
}

class TranslateChallengeData extends ChallengeData<String> {
  TranslateChallengeData({required this.answers});

  List<String> answers;
  @override
  bool checkAnswer(userAnswer) {
    return answers.contains(userAnswer.toLowerCase());
  }
}

class MultipleChoiceChallengeData extends ChallengeData<MultipleChoiceOption> {
  MultipleChoiceChallengeData({required this.options});

  List<MultipleChoiceOption> options;

  @override
  bool checkAnswer(userAnswer) {
    return userAnswer.correct;
  }
}

class SentenceOrderChallengeData extends ChallengeData<List<ChallengeOption>> {
  List<ChallengeOption> options;
  int optionLength;

  SentenceOrderChallengeData(
      {required this.options, required this.optionLength});

  @override
  bool checkAnswer(List<ChallengeOption> userAnswer) {
    if (userAnswer.length != optionLength) return false;

    for (int i = 0; i < optionLength; i++) {
      if (userAnswer[i].id != i) return false;
    }
    return true;
  }
}

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
}
