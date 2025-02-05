import 'package:flutter/material.dart';
import 'package:language_app/modules/home/home_view.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}
