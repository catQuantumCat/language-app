import 'dart:developer';

import 'package:animations/animations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:language_app/common/extensions/context_extension.dart';

import 'package:language_app/domain/repos/lesson_repo.dart';
import 'package:language_app/gen/assets.gen.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/lesson/bloc/lesson_bloc.dart';

import 'package:language_app/modules/challenge/base_challenge_widget.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key, required this.lessonId});

  final int lessonId;

  void _returnToMenuTapped(BuildContext context) {
    GoRouter.of(context).go("/home");

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
    //TODO: DI here
    return BlocProvider(
      create: (context) => LessonBloc(
        lessonRepository: getIt<LessonRepo>(),
      ),
      child: BlocListener<LessonBloc, LessonState>(
        listener: (context, state) {
          //TODO handle later
          // if (state.status == LessonStatus.finished) {
          //   showExitDialog(context, state.message!);
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
                return Center(child: CircularProgressIndicator());
              case LessonStatus.inProgress:
                return _questionStackBuilder(context, state);
              case LessonStatus.finished:
                return _buildCompletionScreen(context, state);
            }
          },
        ),
      ),
    );
  }

  void _returnToHome(BuildContext context) {
    GoRouter.of(context).go("/home");
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

  Widget _buildCompletionScreen(BuildContext context, LessonState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Trophy image or celebration image
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorTheme.primary.withAlpha(127)),
            child: Center(
              child: Icon(
                Icons.emoji_events,
                size: 100,
                color: context.colorTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Congratulation text
          Text(
            "Lesson completed",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            state.message ?? 'You\'ve completed the lesson',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32),

          // Metrics section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorTheme.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colorTheme.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMetricRow(
                  context,
                  icon: Icons.timer,
                  title: 'Time',
                  value: '2m 30s',
                ),
                const Divider(height: 24),
                _buildMetricRow(
                  context,
                  icon: Icons.star,
                  title: 'XP Earned',
                  value: '+20 XP',
                ),
                const Divider(height: 24),
                _buildMetricRow(
                  context,
                  icon: Icons.check_circle,
                  title: 'Accuracy',
                  value: '80%',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Continue button
          ElevatedButton(
            onPressed: () => _returnToHome(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: context.colorTheme.primary,
              foregroundColor: context.colorTheme.onPrimary,
            ),
            child: Text(
              'Continue',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.colorTheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorTheme.selection.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            color: context.colorTheme.selection,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
