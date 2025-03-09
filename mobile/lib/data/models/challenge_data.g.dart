// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslateChallengeData _$TranslateChallengeDataFromJson(
        Map<String, dynamic> json) =>
    TranslateChallengeData(
      acceptedAnswer: (json['acceptedAnswer'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

MultipleChoiceChallengeData _$MultipleChoiceChallengeDataFromJson(
        Map<String, dynamic> json) =>
    MultipleChoiceChallengeData(
      options: (json['options'] as List<dynamic>)
          .map((e) => MultipleChoiceOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

SentenceOrderChallengeData _$SentenceOrderChallengeDataFromJson(
        Map<String, dynamic> json) =>
    SentenceOrderChallengeData(
      options: (json['options'] as List<dynamic>)
          .map((e) => SentenceOrderOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      optionLength: (json['optionLength'] as num).toInt(),
    );

PairMatchingChallengeData _$PairMatchingChallengeDataFromJson(
        Map<String, dynamic> json) =>
    PairMatchingChallengeData(
      options: (json['options'] as List<dynamic>)
          .map((e) => PairMatchingOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
