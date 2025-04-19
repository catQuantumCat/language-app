import 'package:flutter/material.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';

class LessonList extends StatelessWidget {
  const LessonList({super.key, required this.numbers});

  final List<int> numbers;

  int get _lengthModifiedByEight => numbers.length - (numbers.length % 4);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final int offset =
            index >= (_lengthModifiedByEight) ? 1 : _offsetCalculator(index);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Left padding: if offset is negative -> use offset
            //Otherwise use 1
            Spacer(flex: offset < 0 ? -(offset) : 1),
            FilledButton(
              onPressed: () => _onLessonPressed(context),
              child: Text("${numbers[index]}"),
            ),
            //Right padding: if offset is positive -> use offset
            //Otherwise use 1
            Spacer(flex: offset < 0 ? 1 : offset)
          ],
        );
      },
      itemCount: numbers.length,
    );
  }

  void _onLessonPressed(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (routeContext) => LessonPage(lesson: dummyLessons.first)));
  }

  ///Return either +-3, +-2, 1\
  ///1: middle\
  ///+2: near right\
  ///+3: far right\
  ///-2: near left\
  ///-3: far left
  int _offsetCalculator(int input) {
    //A full widget curve has 8 elemens
    input = input % 8;

    //If divided by 4 -> start, end or middle of a curve -> middle position
    if (input % 4 == 0) {
      return 1;
    }
    // If greater than 4 -> curves to the left -> negative
    else if (input > 4) {
      //Top of the curve
      if (input % 2 == 0) {
        return -3;
      }
      //Middle of the curve
      else {
        return -2;
      }
    } else
    // If less than 4 -> curves to the right -> positive
    {
      if (input % 2 == 0) {
        //Top of the curve
        return 3;
      } else
      //Middle of the curve
      {
        return 2;
      }
    }
  }
}
