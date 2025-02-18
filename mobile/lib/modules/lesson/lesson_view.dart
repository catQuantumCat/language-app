import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/data/models/lesson.dart';
import 'package:language_app/modules/lesson/bloc/lesson_bloc.dart';

import 'package:language_app/modules/lesson/widget/challenge/base_challenge_widget.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key, required this.lesson});

  final Lesson lesson;

  void _returnToMenuTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void showExitDialog(BuildContext context, String dialogTitle) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogTitle),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _returnToMenuTapped(context);
            },
            child: Text("Return to menu"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LessonBloc(),
      child: BlocListener<LessonBloc, LessonState>(
        listener: (context, state) {
          if (state.status == LessonStatus.finished) {
            showExitDialog(context, state.message!);
          }
        },
        child: LessonView(),
      ),
    );
  }
}

class LessonView extends StatelessWidget {
  const LessonView({super.key});

  void _onAnswerTapped<T>(BuildContext context, T userAnswer) {
    context.read<LessonBloc>().add(CheckAnswerEvent<T>(userAnswer: userAnswer));
  }

  void _onExitTapped(BuildContext context) {
    context.read<LessonBloc>().add(LessonExitEvent());
  }

  void _onContinueTapped(BuildContext context) {
    context.read<LessonBloc>().add(ContinueEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<LessonBloc, LessonState>(
          builder: (context, state) {
            switch (state.status) {
              case LessonStatus.loading:
                return CircularProgressIndicator();

              case LessonStatus.inProgress:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _onExitTapped(context),
                              icon: const Icon(Icons.clear),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                                "Q: ${state.challengeQueue.first.order}/${state.challengeQueue.length}"),
                          ],
                        ),
                        Text("${state.numOfHeart} hearts left"),
                      ],
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ChallengeWidgetFactory.produce(
                          challenge: state.challengeQueue.first,
                          onAnswerTapped: (isCorrect) =>
                              _onAnswerTapped(context, isCorrect),
                          onContinueTapped: () => _onContinueTapped(context)),
                    )
                  ],
                );
              case LessonStatus.finished:
                return Placeholder();
            }
          },
        ),
      ),
    );
  }
}
