// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:language_app/data/models/challenge_data.dart';

enum ExerciseType {
  multipleChoice("multipleChoice"),
  pairMatching("pairMatching"),
  sentenceOrder("sentenceOrder"),
  translateWritten("translateWritten");

  final String value;

  const ExerciseType(this.value);

  static Map<String, ExerciseType> valueMapping = {
    for (var type in ExerciseType.values) type.value: type
  };
}

class Challenge {
  String id;
  String? lessonId = "1";
  ExerciseType exerciseType;
  int order;
  String question;
  ChallengeData data;

  String? imageUrl;
  String? audioUrl;
  String? instruction;

  Challenge(
      {required this.id,
      required this.order,
      required this.question,
      required this.data,
      required this.exerciseType,
      this.imageUrl,
      this.audioUrl,
      this.instruction});

  static ChallengeData challengeDataFromJson(Map<String, dynamic> rawDataValue,
      {required ExerciseType? exerciseType}) {
    switch (exerciseType) {
      case ExerciseType.multipleChoice:
        return MultipleChoiceChallengeData.fromJson(rawDataValue);
      case ExerciseType.pairMatching:
        return PairMatchingChallengeData.fromJson(rawDataValue);
      case ExerciseType.sentenceOrder:
        return SentenceOrderChallengeData.fromJson(rawDataValue);
      case ExerciseType.translateWritten:
        return TranslateChallengeData.fromJson(rawDataValue);
      case null:
        throw AssertionError("Cannot find type of exercise");
    }
  }

  factory Challenge.fromJson(Map<String, dynamic> map) {
    final type = ExerciseType.valueMapping[map["exerciseType"]];

    if (type == null) {
      throw ArgumentError("Invalid exercise type: ${map["exerciseType"]}");
    }

    return Challenge(
      id: map['_id'] as String,
      //  map['lessonId'] != null ? map['lessonId'] as String : null,
      exerciseType: type,
      data: challengeDataFromJson(map['data'] as Map<String, dynamic>,
          exerciseType: type),
      order: map['order'] as int,
      question: map['question'] as String,
      imageUrl: map['imageUrl'] as String?,
      audioUrl: map['audioUrl'] as String?,
      instruction:
          map['instruction'] != null ? map['instruction'] as String : null,
    );
  }

  @override
  String toString() {
    return 'Challenge(id: $id, lessonId: $lessonId, exerciseType: $exerciseType, order: $order, question: $question, instruction: $instruction)';
  }
}
