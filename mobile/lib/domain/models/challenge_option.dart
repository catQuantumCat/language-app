// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

class ChallengeOption {
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

  factory ChallengeOption.fromJson(Map<String, dynamic> json) {
    return ChallengeOption(
      id: json['id'] as String? ?? "",
      exerciseId: json['exerciseId'] as String? ?? "",
      text: json['text'] as String? ?? "",
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
  }

  @override
  String toString() {
    return 'ChallengeOption(id: $id, exerciseId: $exerciseId, text: $text, audioUrl: $audioUrl, imageUrl: $imageUrl)';
  }
}

class MultipleChoiceOption extends ChallengeOption {
  final bool correct;

  MultipleChoiceOption({
    required super.id,
    required super.exerciseId,
    required this.correct,
    required super.text,
    super.audioUrl,
    super.imageUrl,
  });

  @override
  factory MultipleChoiceOption.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceOption(
      id: json['id'] as String? ?? "",
      exerciseId: json['exerciseId'] as String? ?? "",
      correct: json['correct'] as bool? ?? json['isCorrect'] as bool? ?? false,
      text: json['text'] as String? ?? "",
      audioUrl: json['audioUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

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

class PairMatchingOption extends ChallengeOption {
  @JsonKey()
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
  factory PairMatchingOption.fromJson(Map<String, dynamic> json) {
    return PairMatchingOption(
      id: json['id'] as String? ?? "",
      exerciseId: json['exerciseId'] as String? ?? "",
      text: json['text'] as String? ?? "",
      pairId: (json['pairId'] as num?)?.toInt() ?? 0,
      column: _parseColumn(json['column'] as String?),
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
  }

  static PairMachingEnum _parseColumn(String? value) {
    if (value == 'left') return PairMachingEnum.left;
    if (value == 'right') return PairMachingEnum.right;
    return PairMachingEnum.left; // Default value
  }

  @override
  String toString() {
    return 'PairMatchingOption(id: $id, exerciseId: $exerciseId, text: $text, audioUrl: $audioUrl, imageUrl: $imageUrl, pairId: $pairId, column: $column)';
  }
}

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
  factory SentenceOrderOption.fromJson(Map<String, dynamic> json) {
    return SentenceOrderOption(
      id: json['id'] as String? ?? "",
      exerciseId: json['exerciseId'] as String? ?? "",
      text: json['text'] as String? ?? "",
      order: (json['order'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
  }
}
