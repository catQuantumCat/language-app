import 'package:flutter/material.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/modules/home/home_view.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: LessonPage(
      //   lesson: dummyLessons[0],
      // ),
      home: HomePage(
        unit: dummyUnits[0],
      ),
    );
  }
}
