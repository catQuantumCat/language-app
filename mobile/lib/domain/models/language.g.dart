// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      languageId: json['languageId'] as String,
      languageFlag: json['languageFlag'] as String,
      order: (json['order'] as num).toInt(),
      lessonOrder: (json['lessonOrder'] as num).toInt(),
      unitOrder: (json['unitOrder'] as num).toInt(),
      languageName: json['languageName'] as String,
    );

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'languageId': instance.languageId,
      'languageFlag': instance.languageFlag,
      'order': instance.order,
      'lessonOrder': instance.lessonOrder,
      'unitOrder': instance.unitOrder,
      'languageName': instance.languageName,
    };
