// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageModel _$LanguageModelFromJson(Map<String, dynamic> json) =>
    LanguageModel(
      languageId: json['languageId'] as String,
      level: (json['level'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
    );

Map<String, dynamic> _$LanguageModelToJson(LanguageModel instance) =>
    <String, dynamic>{
      'languageId': instance.languageId,
      'level': instance.level,
      'experience': instance.experience,
    };
