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

class MultipleChoiceChallengeData extends ChallengeData<ChallengeOption> {
  MultipleChoiceChallengeData({required this.options});

  List<ChallengeOption> options;

  @override
  bool checkAnswer(userAnswer) {
    return userAnswer.correct;
  }
}
