import 'package:flutter/material.dart';

import 'package:language_app/modules/home/widgets/lesson_list.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class UnitList extends StatefulWidget {
  const UnitList(
      {super.key, required this.units, required this.itemPositionsListener});

  final ItemPositionsListener itemPositionsListener;
  final List<List<int>> units;

  @override
  State<UnitList> createState() => _UnitListState();
}

class _UnitListState extends State<UnitList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      separatorBuilder: (context, index) => Divider(),
      padding: EdgeInsets.zero,
      itemPositionsListener: widget.itemPositionsListener,
      itemBuilder: (context, index) => LessonList(numbers: widget.units[index]),
      itemCount: widget.units.length,
    );
  }
}
