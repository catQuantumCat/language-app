import 'package:flutter/material.dart';
import 'package:language_app/data/models/lesson.dart';
import 'package:language_app/data/models/unit.dart';
import 'package:language_app/modules/home/widgets/header_widget.dart';

import 'package:language_app/modules/home/widgets/unit_list.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.unit});

  final Unit unit;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<List<int>> numbers = [
    List<int>.generate(12, (index) => index),
    List<int>.generate(18, (index) => index),
    List<int>.generate(20, (index) => index),
  ];

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_onPositionChange);
  }

  void _onPositionChange() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final firstVisibleIndex = positions.first.index;
      if (firstVisibleIndex != _currentIndexNotifier.value) {
        _currentIndexNotifier.value = firstVisibleIndex;
      }
    }
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onPositionChange);
    _currentIndexNotifier.dispose();
    super.dispose();
  }

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
    return Column(
      children: [
        HeaderWidget(currentIndexNotifier: _currentIndexNotifier),
        Expanded(
            child: UnitList(
                units: numbers, itemPositionsListener: itemPositionsListener))
      ],
    );
  }
}
