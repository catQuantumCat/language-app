import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_app/data/models/unit.dart';

import 'package:language_app/modules/home/widgets/lesson_list.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class UnitList extends StatefulWidget {
  const UnitList(
      {super.key,
      required this.units,
      required this.itemPositionsListener,
      required this.languageId,
      required this.currentUnitIndex,
      required this.currentLessonIndex});

  final ItemPositionsListener itemPositionsListener;
  final List<Unit> units;
  final String languageId;
  final int currentUnitIndex;
  final int currentLessonIndex;
  @override
  State<UnitList> createState() => _UnitListState();
}

class _UnitListState extends State<UnitList> {
  //if currentLessonIndex is equals to length of lessons, the lesson index = 1, unit indext += 1

  late final int _currentUnitIndex;
  late final int _currentLessonIndex;

  @override
  void initState() {
    _currentUnitIndex = widget.currentLessonIndex == widget.units.length
        ? widget.currentUnitIndex + 1
        : widget.currentUnitIndex;
    _currentLessonIndex = widget.currentLessonIndex == widget.units.length
        ? 1
        : widget.currentLessonIndex;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      separatorBuilder: (context, index) => _separatorBuild(context, index),
      padding: EdgeInsets.zero,
      itemPositionsListener: widget.itemPositionsListener,
      itemBuilder: (context, index) => LessonList(
          isUnlocked: _currentUnitIndex > index,
          currentLessonIndex: _currentLessonIndex + 1,
          lessons: widget.units[index].lessons ?? [],
          languageId: widget.languageId),
      itemCount: widget.units.length,
    );
  }

  Widget _separatorBuild(BuildContext context, int index) {
    if (index > widget.units.length - 2) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        spacing: 16,
        children: [
          Expanded(child: Divider()),
          Text(widget.units[index + 1].title),
          Expanded(child: Divider()),
        ],
      ),
    );
  }
}
