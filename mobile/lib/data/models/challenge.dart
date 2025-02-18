import 'package:language_app/data/models/challenge_data.dart';

enum ChallengeType {
  multipleChoice,
  multipleChoiceWithImages,
  pairMatching,
  sentenceOrder,
  translateWritten
}

class Challenge {
  int id;
  int lessonId;
  ChallengeType type;
  int order;
  String question;
  ChallengeData data;

  Challenge(
      {required this.id,
      required this.lessonId,
      required this.order,
      required this.question,
      required this.data,
      required this.type});
}
