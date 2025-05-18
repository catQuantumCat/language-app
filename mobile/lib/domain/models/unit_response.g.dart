// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitResponse _$UnitResponseFromJson(Map<String, dynamic> json) => UnitResponse(
      languageId: json['languageId'] as String,
      order: (json['order'] as num).toInt(),
      title: json['title'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$UnitResponseToJson(UnitResponse instance) =>
    <String, dynamic>{
      'languageId': instance.languageId,
      'order': instance.order,
      'title': instance.title,
      'id': instance.id,
    };
