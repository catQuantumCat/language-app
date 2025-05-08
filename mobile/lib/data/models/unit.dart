import 'package:language_app/domain/models/lesson.dart';

class Unit {
  int id;
  String title;
  int order;

  List<Lesson>? lessons;

  Unit(
      {required this.id,
      required this.title,
      required this.order,
      this.lessons});
}
