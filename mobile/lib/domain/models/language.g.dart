// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      languageId: json['languageId'] as String,
      level: (json['level'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
    );

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'languageId': instance.languageId,
      'level': instance.level,
      'experience': instance.experience,
    };
