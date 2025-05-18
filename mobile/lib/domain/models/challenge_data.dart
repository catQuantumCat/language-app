import 'package:language_app/domain/models/challenge_option.dart';



abstract class ChallengeData<T> {
  bool checkAnswer(T userAnswer);
}


class TranslateChallengeData extends ChallengeData<String> {
  TranslateChallengeData(
      {required this.acceptedAnswer, required this.translateWord});

  List<String> acceptedAnswer;
  String translateWord;

  @override
  bool checkAnswer(String userAnswer) {
    // Process user answer
    final userWords = userAnswer
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim()
        .split(RegExp(r'\s+')) 
        .where((word) => word.isNotEmpty)
        .toList();

    // Process all accepted answers
    for (final accepted in acceptedAnswer) {
      final acceptedWords = accepted
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '') 
          .trim()
          .split(RegExp(r'\s+')) // Split on whitespace
          .where((word) => word.isNotEmpty)
          .toList();

      // Calculate how many words from accepted answer are in user answer
      int matchingWords = 0;
      for (final word in acceptedWords) {
        if (userWords.contains(word)) {
          matchingWords++;
        }
      }

      // Check if we have at least 80% match
      if (matchingWords / acceptedWords.length >= 0.8) {
        return true;
      }
    }
    return false;
  }

  factory TranslateChallengeData.fromJson(Map<String, dynamic> json) {
    return TranslateChallengeData(
      acceptedAnswer: (json['acceptedAnswer'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      translateWord: json['translateWord'] as String? ?? "",
    );
  }
}


class MultipleChoiceChallengeData extends ChallengeData<MultipleChoiceOption> {
  MultipleChoiceChallengeData({required this.options});

  List<MultipleChoiceOption> options;

  @override
  bool checkAnswer(userAnswer) {
    return userAnswer.correct;
  }

  factory MultipleChoiceChallengeData.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceChallengeData(
      options: (json['options'] as List<dynamic>?)
              ?.map((e) =>
                  MultipleChoiceOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}


class SentenceOrderChallengeData
    extends ChallengeData<List<SentenceOrderOption>> {
  List<SentenceOrderOption> options;
  int sentenceLength;

  SentenceOrderChallengeData({
    required this.options,
    required this.sentenceLength,
  });

  @override
  bool checkAnswer(List<SentenceOrderOption> userAnswer) {
    if (userAnswer.length != sentenceLength) return false;

    for (int i = 0; i < sentenceLength; i++) {
      if (userAnswer[i].order != i + 1) return false;
    }
    return true;
  }

  factory SentenceOrderChallengeData.fromJson(Map<String, dynamic> json) {
    return SentenceOrderChallengeData(
      options: (json['options'] as List<dynamic>?)
              ?.map((e) =>
                  SentenceOrderOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sentenceLength: json['sentenceLength'] as int? ??
          (json['options'] as List<dynamic>?)?.length ??
          0,
    );
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

  factory PairMatchingChallengeData.fromJson(Map<String, dynamic> json) {
    return PairMatchingChallengeData(
      options: (json['options'] as List<dynamic>?)
              ?.map(
                  (e) => PairMatchingOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
