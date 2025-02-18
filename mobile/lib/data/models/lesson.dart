import 'package:language_app/data/models/challenge.dart';

class Lesson {
  int id;
  int unitId;
  String title;
  int order;

  List<Challenge>? challenges;

  Lesson({
    required this.id,
    required this.unitId,
    required this.title,
    required this.order,

    this.challenges
  });
}
