// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeOption _$ChallengeOptionFromJson(Map<String, dynamic> json) =>
    ChallengeOption(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );

MultipleChoiceOption _$MultipleChoiceOptionFromJson(
        Map<String, dynamic> json) =>
    MultipleChoiceOption(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      correct: json['correct'] as bool,
      text: json['text'] as String,
      audioUrl: json['audioUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

PairMatchingOption _$PairMatchingOptionFromJson(Map<String, dynamic> json) =>
    PairMatchingOption(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      text: json['text'] as String,
      pairId: (json['pairId'] as num).toInt(),
      column: $enumDecode(_$PairMachingEnumEnumMap, json['column']),
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );

const _$PairMachingEnumEnumMap = {
  PairMachingEnum.left: 'left',
  PairMachingEnum.right: 'right',
};

SentenceOrderOption _$SentenceOrderOptionFromJson(Map<String, dynamic> json) =>
    SentenceOrderOption(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      text: json['text'] as String,
      order: (json['order'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
