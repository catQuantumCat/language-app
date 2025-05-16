// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Result {
  final String lessonId;
  @JsonKey(fromJson: _incorrectListToModel, toJson: _modelToJson)
  final List<ResultIncorrectExerciseModel> exercises;
  final int hearts;
  final int experienceGained;
  final int timeSpent;
  final int streak;

  Result({
    required this.lessonId,
    required this.exercises,
    required this.hearts,
    required this.experienceGained,
    required this.timeSpent,
    required this.streak,
  });

  static List<ResultIncorrectExerciseModel> _incorrectListToModel(
          List<Map<String, dynamic>> data) =>
      data.map((e) => ResultIncorrectExerciseModel.fromJson(e)).toList();

  static List<Map<String, dynamic>> _modelToJson(
          List<ResultIncorrectExerciseModel> data) =>
      data.map((e) => e.toJson()).toList();

    
}

class ResultIncorrectExerciseModel {
  final String exerciseId;

  ResultIncorrectExerciseModel({required this.exerciseId});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'exerciseId': exerciseId,
    };
  }

  factory ResultIncorrectExerciseModel.fromJson(Map<String, dynamic> map) {
    return ResultIncorrectExerciseModel(
      exerciseId: map['exerciseId'] as String,
    );
  }

  @override
  String toString() => 'ResultIncorrectExerciseModel(exerciseId: $exerciseId)';
}
