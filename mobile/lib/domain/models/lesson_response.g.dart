// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonResponse _$LessonResponseFromJson(Map<String, dynamic> json) =>
    LessonResponse(
      experienceReward: json['experienceReward'] as int,
      order: json['order'] as int,
      title: json['title'] as String,
      unitId: json['unitId'] as String,
      id: json['id'] as String,
      progress: LessonProgress.fromJson(json['progress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LessonResponseToJson(LessonResponse instance) =>
    <String, dynamic>{
      'experienceReward': instance.experienceReward,
      'order': instance.order,
      'title': instance.title,
      'unitId': instance.unitId,
      'id': instance.id,
      'progress': instance.progress,
    };

LessonProgress _$LessonProgressFromJson(Map<String, dynamic> json) =>
    LessonProgress(
      completed: json['completed'] as bool,
      score: json['score'] as int,
      attempts: json['attempts'] as int,
    );

Map<String, dynamic> _$LessonProgressToJson(LessonProgress instance) =>
    <String, dynamic>{
      'completed': instance.completed,
      'score': instance.score,
      'attempts': instance.attempts,
    };
