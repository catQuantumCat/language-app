import 'package:flutter/material.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final dummyData = [
    "Introduction",
    "Basic Phrases",
    "Numbers",
    "Days of the Week",
    "Colors"
  ];

  void navigateToLesson(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonPage(),
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
                Text("Unit 1", style: TextStyle(fontSize: 20)),
                Text("Getting to know each other",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => ListTile(
                onTap: () => navigateToLesson(context),
                title: Text("Lesson $index: ${(dummyData[index])}"),
              ),
              itemCount: dummyData.length,
            ),
          )
        ],
      ),
    );
  }
}
