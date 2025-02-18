import 'package:flutter/material.dart';
import 'package:language_app/data/models/lesson.dart';
import 'package:language_app/data/models/unit.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return HomeView(
      unit: unit,
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.unit});

  final Unit unit;

  void navigateToLesson(BuildContext context, {Lesson? lesson}) {
    if (lesson == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonPage(lesson: lesson),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Language app"),
        backgroundColor: Color(0xFF59CC01),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Unit ${unit.id}", style: TextStyle(fontSize: 20)),
                Text(unit.title,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => ListTile(
                onTap: () =>
                    navigateToLesson(context, lesson: unit.lessons?[index]),
                title: Text("Lesson $index: ${unit.lessons?[index].title}"),
              ),
              itemCount: unit.lessons?.length ?? 0,
            ),
          )
        ],
      ),
    );
  }
}
