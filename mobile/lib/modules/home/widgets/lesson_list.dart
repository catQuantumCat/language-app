import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/domain/models/lesson.dart';
import 'package:language_app/theme/color_theme.dart';

class LessonList extends StatelessWidget {
  const LessonList(
      {super.key,
      required this.lessons,
      required this.languageId,
      required this.isUnlocked,
      required this.currentLessonIndex});

  final String languageId;
  final List<Lesson> lessons;
  final bool isUnlocked;
  final int currentLessonIndex;

  int get _lengthModifiedByEight => lessons.length - (lessons.length % 4);

  @override
  Widget build(BuildContext context) {
    log("currentLessonIndex: $currentLessonIndex");
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final bool isLessonUnlocked =
            (lessons[index].order <= currentLessonIndex && isUnlocked);

        final int offset =
            index >= (_lengthModifiedByEight) ? 1 : _offsetCalculator(index);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: offset < 0 ? -(offset) : 1),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colorTheme.border.withAlpha(127),
                    offset: Offset(0, 4),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: isLessonUnlocked
                      ? context.colorTheme.primary
                      : context.colorTheme.border,
                  foregroundColor: isLessonUnlocked
                      ? context.colorTheme.onPrimary
                      : Colors.grey,
                  minimumSize: Size(64, 64),
                  shape: CircleBorder(),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                onPressed: () => isLessonUnlocked
                    ? _onLessonPressed(context,
                        unitId: lessons[index].unitId,
                        lessonId: lessons[index].id)
                    : null,
                child: Text(
                  "${lessons[index].order}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Spacer(flex: offset < 0 ? 1 : offset)
          ],
        );
      },
      itemCount: lessons.length,
    );
  }

  void _onLessonPressed(BuildContext context,
      {required String unitId, required String lessonId}) {
    GoRouter.of(context).go("/lesson/$languageId/$unitId/$lessonId");
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
