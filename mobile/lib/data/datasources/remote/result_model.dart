class ResultModel {
  final String userId;
  final String lessonId;
  final List<ExerciseResult> exercises;
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

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'lessonId': lessonId,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'hearts': hearts,
      'experienceGained': experienceGained,
      'timeSpent': timeSpent,
      'streak': streak,
    };
  }

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      userId: json['userId'],
      lessonId: json['lessonId'],
      exercises: (json['exercises'] as List)
          .map((e) => ExerciseResult.fromJson(e))
          .toList(),
      hearts: json['hearts'],
      experienceGained: json['experienceGained'],
      timeSpent: json['timeSpent'],
      streak: json['streak'],
    );
  }
}

class ExerciseResult {
  final String exerciseId;

  ExerciseResult({required this.exerciseId});

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
    };
  }

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      exerciseId: json['exerciseId'],
    );
  }
}
