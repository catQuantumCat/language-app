import 'package:json_annotation/json_annotation.dart';
import 'package:language_app/domain/models/result.dart';

part 'result_model.g.dart';

@JsonSerializable()
class ResultModel {
  final String userId;
  final String lessonId;
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
