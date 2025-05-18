import 'package:json_annotation/json_annotation.dart';

part 'lesson_response.g.dart';

@JsonSerializable()
class LessonResponse {
  final int experienceReward;
  final int order;
  final String title;
  final String unitId;
  final String id;
  final LessonProgress progress;

  LessonResponse({
    required this.experienceReward,
    required this.order,
    required this.title,
    required this.unitId,
    required this.id,
    required this.progress,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LessonResponseToJson(this);
}

@JsonSerializable()
class LessonProgress {
  final bool completed;
  final int score;
  final int attempts;

  LessonProgress({
    required this.completed,
    required this.score,
    required this.attempts,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) =>
      _$LessonProgressFromJson(json);

  Map<String, dynamic> toJson() => _$LessonProgressToJson(this);
}
