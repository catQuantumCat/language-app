import 'package:language_app/data/models/lesson.dart';

class Unit {
  int id;
  String title;
  String description;
  int order;

  List<Lesson>? lessons;

  Unit({
    required this.id,
    required this.title,
    required this.description,
    required this.order,

    this.lessons
  });
}
