// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultModel _$ResultModelFromJson(Map<String, dynamic> json) => ResultModel(
      userId: json['userId'] as String,
      lessonId: json['lessonId'] as String,
      exercises: ResultModel._incorrectListToModel(
          json['exercises'] as List<Map<String, dynamic>>),
      hearts: (json['hearts'] as num).toInt(),
      experienceGained: (json['experienceGained'] as num).toInt(),
      timeSpent: (json['timeSpent'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
    );

Map<String, dynamic> _$ResultModelToJson(ResultModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'lessonId': instance.lessonId,
      'exercises': ResultModel._modelToJson(instance.exercises),
      'hearts': instance.hearts,
      'experienceGained': instance.experienceGained,
      'timeSpent': instance.timeSpent,
      'streak': instance.streak,
    };
