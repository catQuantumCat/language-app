// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableLanguage _$AvailableLanguageFromJson(Map<String, dynamic> json) =>
    AvailableLanguage(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      flagUrl: json['flagUrl'] as String?,
      description: json['description'] as String,
    );

Map<String, dynamic> _$AvailableLanguageToJson(AvailableLanguage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'flagUrl': instance.flagUrl,
      'description': instance.description,
    };
