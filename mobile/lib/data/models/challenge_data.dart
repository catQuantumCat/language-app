import 'package:language_app/data/models/challenge_option.dart';

abstract class ChallengeData {
  bool checkAnswer(dynamic userAnswer);
}

class TranslateChallengeData extends ChallengeData {
  TranslateChallengeData({required this.answers});

  List<String> answers;
  @override
  bool checkAnswer(covariant String userAnswer) {
    return answers.contains(userAnswer.toLowerCase());
  }
}

class MultipleChoiceChallengeData extends ChallengeData {
  MultipleChoiceChallengeData({required this.options});

  List<ChallengeOption> options;

  @override
  bool checkAnswer(covariant ChallengeOption userAnswer) {
    return userAnswer.correct;
  }
}
