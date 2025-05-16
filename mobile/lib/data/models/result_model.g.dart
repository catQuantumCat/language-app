// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultModel _$ResultModelFromJson(Map<String, dynamic> json) => ResultModel(
      userId: json['userId'] as String,
      lessonId: json['lessonId'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) =>
              ResultIncorrectExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hearts: (json['hearts'] as num).toInt(),
      experienceGained: (json['experienceGained'] as num).toInt(),
      timeSpent: (json['timeSpent'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
    );

Map<String, dynamic> _$ResultModelToJson(ResultModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'lessonId': instance.lessonId,
      'exercises': instance.exercises,
      'hearts': instance.hearts,
      'experienceGained': instance.experienceGained,
      'timeSpent': instance.timeSpent,
      'streak': instance.streak,
    };
