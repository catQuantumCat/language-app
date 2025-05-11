// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageModel _$LanguageModelFromJson(Map<String, dynamic> json) =>
    LanguageModel(
      languageId: json['languageId'] as String,
      flagUrl: json['flagUrl'] as String,
      order: (json['order'] as num).toInt(),
      lessonOrder: (json['lessonOrder'] as num).toInt(),
    );

Map<String, dynamic> _$LanguageModelToJson(LanguageModel instance) =>
    <String, dynamic>{
      'languageId': instance.languageId,
      'flagUrl': instance.flagUrl,
      'order': instance.order,
      'lessonOrder': instance.lessonOrder,
    };
