// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'challenge_option.g.dart';

@JsonSerializable(createToJson: false)
class ChallengeOption {
  @JsonKey(name: "_id")
  final String id;
  final String exerciseId;
  final String text;
  final String? audioUrl;
  final String? imageUrl;
  ChallengeOption(
      {required this.id,
      required this.exerciseId,
      required this.text,
      this.imageUrl,
      this.audioUrl});

  factory ChallengeOption.fromJson(Map<String, dynamic> map) =>
      _$ChallengeOptionFromJson(map);

  @override
  String toString() {
    return 'ChallengeOption(id: $id, exerciseId: $exerciseId, text: $text, audioUrl: $audioUrl, imageUrl: $imageUrl)';
  }
}

@JsonSerializable(createToJson: false)
class MultipleChoiceOption extends ChallengeOption {
  final bool correct;

  MultipleChoiceOption(
      {required super.id,
      required super.exerciseId,
      required this.correct,
      required super.text,
      super.audioUrl,
      super.imageUrl});

  @override
  factory MultipleChoiceOption.fromJson(Map<String, dynamic> map) =>
      _$MultipleChoiceOptionFromJson(map);

  @override
  String toString() {
    return 'MultipleChoiceOption(id: $id, exerciseId: $exerciseId, text: $text, audioUrl: $audioUrl, imageUrl: $imageUrl, correct: $correct)';
  }
}

enum PairMachingEnum {
  @JsonValue("left")
  left,
  @JsonValue("right")
  right,
}

@JsonSerializable(createToJson: false)
class PairMatchingOption extends ChallengeOption {
  final int pairId;
  final PairMachingEnum column;
  PairMatchingOption(
      {required super.id,
      required super.exerciseId,
      required super.text,
      required this.pairId,
      required this.column,
      super.imageUrl,
      super.audioUrl});

  @override
  factory PairMatchingOption.fromJson(Map<String, dynamic> map) =>
      _$PairMatchingOptionFromJson(map);

  @override
  String toString() {
    return 'PairMatchingOption(id: $id, exerciseId: $exerciseId, text: $text, audioUrl: $audioUrl, imageUrl: $imageUrl, pairId: $pairId, column: $column)';
  }
}

@JsonSerializable(createToJson: false)
class SentenceOrderOption extends ChallengeOption {
  int order;
  SentenceOrderOption(
      {required super.id,
      required super.exerciseId,
      required super.text,
      required this.order,
      super.imageUrl,
      super.audioUrl});

  @override
  String toString() => 'SentenceOrderOption(order: $order)';

  @override
  factory SentenceOrderOption.fromJson(Map<String, dynamic> map) =>
      _$SentenceOrderOptionFromJson(map);
}
