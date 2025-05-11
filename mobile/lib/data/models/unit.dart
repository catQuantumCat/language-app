// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:language_app/domain/models/lesson.dart';

part 'unit.g.dart';

@JsonSerializable()
class Unit {
  String id;
  String title;
  int order;
  @JsonKey(includeIfNull: false)
  List<Lesson>? lessons;

  Unit(
      {required this.id,
      required this.title,
      required this.order,
      this.lessons});

  Unit copyWith({
    String? id,
    String? title,
    int? order,
    List<Lesson>? lessons,
  }) {
    return Unit(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      lessons: lessons ?? this.lessons,
    );
  }

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);

  @override
  String toString() {
    return 'Unit(id: $id, title: $title, order: $order, lessons length: ${lessons?.length})';
  }
}
