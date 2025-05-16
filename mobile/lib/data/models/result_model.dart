import 'package:json_annotation/json_annotation.dart';
import 'package:language_app/domain/models/result.dart';

part 'result_model.g.dart';

@JsonSerializable()
class ResultModel {
  final String userId;
  final String lessonId;
  @JsonKey(fromJson: _incorrectListToModel, toJson: _modelToJson)
  final List<ResultIncorrectExerciseModel> exercises;
  final int hearts;
  final int experienceGained;
  final int timeSpent;
  final int streak;

  ResultModel({
    required this.userId,
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

  factory ResultModel.fromJson(Map<String, dynamic> json) =>
      _$ResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResultModelToJson(this);

  factory ResultModel.fromDomain(Result result, {required String userId}) => ResultModel(
        userId: userId,
        lessonId: result.lessonId,
        exercises: result.exercises,
        hearts: result.hearts,
        experienceGained: result.experienceGained, timeSpent: result.timeSpent, streak: result.streak,
      );
}
