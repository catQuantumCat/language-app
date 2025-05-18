// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      id: json['id'] as String,
      unitId: json['unitId'] as String,
      title: json['title'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'unitId': instance.unitId,
      'title': instance.title,
      'order': instance.order,
    };
