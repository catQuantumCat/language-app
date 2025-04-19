import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:language_app/data/models/lesson.dart';
import 'package:language_app/data/repo_imp/lesson_repo_imp.dart';
import 'package:language_app/gen/assets.gen.dart';
import 'package:language_app/modules/lesson/bloc/lesson_bloc.dart';

import 'package:language_app/modules/challenge/base_challenge_widget.dart';

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
      create: (context) => LessonBloc(
          lessonRepository:
              LessonRepoImp(remoteDatasource: LessonRemoteDatasource())),
      child: BlocListener<LessonBloc, LessonState>(
        listener: (context, state) {
          if (state.status == LessonStatus.finished) {
            showExitDialog(context, state.message!);
          }
          // if (state.answerStatus != AnswerStatus.none) {
          //   showDialog(
          //     context: context,
          //     builder: (dialogContext) => AlertDialog(
          //       title: Text(state.answerStatus == AnswerStatus.correct
          //           ? "Correct"
          //           : "Not correct"),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             Navigator.pop(dialogContext);
          //           },
          //           child: Text("Continue"),
          //         )
          //       ],
          //     ),
          //   );
          // }
        },
        child: LessonView(),
      ),
    );
  }
}

class LessonView extends StatelessWidget {
  const LessonView({super.key});

  void _onAnswerTapped<T>(BuildContext context, T? userAnswer) {
    log("onAnswerTapped");

    if (userAnswer == null) {
      return;
    }
    context.read<LessonBloc>().add(CheckAnswerEvent<T>(userAnswer: userAnswer));
  }

  void _onExitTapped(BuildContext context) {
    context.read<LessonBloc>().add(LessonExitEvent());
  }

  void _onContinueTapped(BuildContext context) {
    log("onContinueTapped");
    context.read<LessonBloc>().add(ContinueEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        minimum: EdgeInsets.symmetric(horizontal: 0),
        child: BlocBuilder<LessonBloc, LessonState>(
          builder: (context, state) {
            switch (state.status) {
              case LessonStatus.loading:
                return CircularProgressIndicator();
              case LessonStatus.inProgress:
                return _questionStackBuilder(context, state);
              case LessonStatus.finished:
                return Placeholder();
            }
          },
        ),
      ),
    );
  }

  Column _questionStackBuilder(BuildContext context, LessonState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8),
        _challengeControllerRowBuilder(context, state),
        SizedBox(height: 16),
        Expanded(
          child: _animatedQuestionBuilder(state, context),
        )
      ],
    );
  }

  //Animation
  //Use a transition switcher to for applying 2 animations for incoming and outgoing widget
  //Each widget wrapped with an animatedOpacity, animate from 0-1 with incoming and 1-0 with outgoing

  //Beneth is slide animation:
  //  Incoming: right to center; x: 1->0
  //  Outgoing: center to left: x: 0->-1

  Widget _animatedQuestionBuilder(LessonState state, BuildContext context) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation,
          Animation<double> secondAnimation) {
        return FadeTransition(
          opacity: ReverseAnimation(secondAnimation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-1, 0.0),
            )
                .chain(CurveTween(curve: Curves.easeInOut))
                .animate(secondAnimation),
            child: FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
                child: child,
              ),
            ),
          ),
        );
      },
      child: ChallengeWidgetFactory.produce(
        key: ValueKey(state.challengeQueue.first),
        challenge: state.challengeQueue.first,
        onAnswerTapped: (isCorrect) => state.answerStatus == AnswerStatus.none
            ? _onAnswerTapped(context, isCorrect)
            : _onContinueTapped(context),
        answerStatus: state.answerStatus,
      ),
    );
  }

  Widget _challengeControllerRowBuilder(
      BuildContext context, LessonState state) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              child: Icon(Icons.clear), onTap: () => _onExitTapped(context)),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutSine,
              tween: Tween<double>(
                begin: 0,
                end: (state.userProgressIndex ?? 0) / (state.lessonLength ?? 1),
              ),
              builder: (context, value, _) => LinearProgressIndicator(
                borderRadius: BorderRadius.circular(8),
                backgroundColor: context.colorTheme.border,
                color: context.colorTheme.primary,
                value: value,
                minHeight: 15,
              ),
            ),
          ),
          Assets.heart.svg(),
          SizedBox(width: 8),
          Text("${state.numOfHeart}")
        ],
      ),
    );
  }
}
