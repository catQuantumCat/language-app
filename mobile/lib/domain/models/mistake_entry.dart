// domain/models/mistake_entry.dart
import 'package:language_app/domain/models/challenge.dart';

class MistakeEntry {
  final String id;
  final String exerciseId;
  final int? unitOrder;
  final String? unitName;
  final int lessonOrder;
  final String lessonName;
  final String instruction;
  final String? question;
  final String createdAt;

  MistakeEntry({
    required this.id,
    required this.exerciseId,
    this.unitOrder,
    this.unitName,
    required this.lessonOrder,
    required this.lessonName,
    required this.instruction,
    this.question,
    required this.createdAt,
  });

  factory MistakeEntry.fromJson(Map<String, dynamic> json) {
    return MistakeEntry(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      unitOrder: json['unitOrder'] as int?,
      unitName: json['unitName'] as String?,
      lessonOrder: json['lessonOrder'] as int,
      lessonName: json['lessonName'] as String,
      instruction: json['instruction'] as String,
      question: json['question'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }
}

class MistakeDetail {
  final String id;
  final int? unitOrder;
  final String? unitName;
  final int lessonOrder;
  final Challenge exercise;
  final String createdAt;

  MistakeDetail({
    required this.id,
    this.unitOrder,
    this.unitName,
    required this.lessonOrder,
    required this.exercise,
    required this.createdAt,
  });

  factory MistakeDetail.fromJson(Map<String, dynamic> json) {
  final exerciseData = json['exercise'] as Map<String, dynamic>? ?? {};
  
  // Thêm lessonId vào exerciseData nếu không có
  if (!exerciseData.containsKey('lessonId') && json.containsKey('lessonId')) {
    exerciseData['lessonId'] = json['lessonId'] as String? ?? "default";
  }
  
  return MistakeDetail(
    id: json['id'] as String? ?? "",
    unitOrder: json['unitOrder'] as int?,
    unitName: json['unitName'] as String?,
    lessonOrder: json['lessonOrder'] as int? ?? 0,
    exercise: Challenge.fromJson(exerciseData),
    createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
  );
}

}
