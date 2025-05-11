import 'package:json_annotation/json_annotation.dart';
import 'package:language_app/domain/models/challenge.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  String id;
  String unitId;
  String title;
  int order;

  @JsonKey(includeToJson: false, includeFromJson: false)
  List<Challenge>? challenges;

  Lesson(
      {required this.id,
      required this.unitId,
      required this.title,
      required this.order,
      this.challenges});

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
