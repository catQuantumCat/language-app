import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/data/models/challenge.dart';
import 'package:language_app/data/models/challenge_option.dart';
import 'package:language_app/modules/challenge/widgets/audio_widget.dart';
import 'package:language_app/modules/lesson/bloc/lesson_bloc.dart';
import 'package:language_app/modules/challenge/multiple_choices_challenge_widget.dart';
import 'package:language_app/modules/challenge/pair_matching_challenge_widget.dart';
import 'package:language_app/modules/challenge/sentence_order_challenge_widget.dart';
import 'package:language_app/modules/challenge/translate_challenge_widget.dart';

// ignore: must_be_immutable
abstract class BaseChallengeWidget<T> extends StatelessWidget {
  BaseChallengeWidget(
      {super.key,
      required this.challenge,
      required this.onAnswerTapped,
      required this.answerStatus});

  final Challenge challenge;
  final void Function(T? userAnswer) onAnswerTapped;
  // String? question;
  // final String questionDescription;
  final AnswerStatus answerStatus;
  ValueNotifier<T?> currentAnswer = ValueNotifier<T?>(null);

  final GlobalKey _submitButtonKey = GlobalKey();
  final GlobalKey _bannerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          minimum: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              questionStack(),
              SizedBox(height: 16),
              Expanded(
                child: absorbBody(),
              ),
              SizedBox(
                  height:
                      _getHeightFromKey(context, key: _submitButtonKey) ?? 48)
            ],
          ),
        ),
        _resultBannerBuilder(context),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: submitButtonBuilder(),
        ),
      ],
    );
  }

  AnimatedPositioned _resultBannerBuilder(BuildContext context) {
    final colorTheme = context.colorTheme;

    return AnimatedPositioned(
      curve: Curves.easeOutCubic,
      duration: Duration(milliseconds: 300),
      bottom: answerStatus != AnswerStatus.none
          ? 0
          : -(_getHeightFromKey(context, key: _bannerKey) ?? 200),
      left: 0,
      right: 0,
      child: Container(
        color: answerStatus == AnswerStatus.correct
            ? colorTheme.onCorrect
            : colorTheme.onWrong,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _bannerIconBuilder(context),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      answerStatus == AnswerStatus.correct
                          ? "Correct"
                          : "Incorrect",
                      style: TextStyle(
                          fontSize: 24,
                          color: answerStatus == AnswerStatus.correct
                              ? colorTheme.textPrimary
                              : colorTheme.error),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                  height:
                      _getHeightFromKey(context, key: _submitButtonKey) ?? 48),
            ],
          ),
        ),
      ),
    );
  }

  ClipOval _bannerIconBuilder(BuildContext context) {
    return ClipOval(
      child: Container(
        color: answerStatus == AnswerStatus.correct
            ? context.colorTheme.correct
            : context.colorTheme.wrong,
        height: 20,
        width: 20,
        child: Center(
          child: Icon(
            answerStatus == AnswerStatus.correct
                ? Icons.check
                : Icons.clear_rounded,
            size: 18,
            color: context.colorTheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget bodyWidgetBuilder();
  Widget absorbBody() => AbsorbPointer(
        absorbing: answerStatus != AnswerStatus.none,
        child: bodyWidgetBuilder(),
      );
  Widget questionStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (challenge.question != null) ...[
              Text(challenge.instruction),
              Text(
                challenge.question!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  challenge.instruction,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        if (challenge.audioUrl != null) AudioWidget(using: challenge.audioUrl!),
        if (challenge.imageUrl != null) ...[
          SizedBox(height: 16),
          SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              challenge.imageUrl ?? "",
            ),
          )
        ]
      ],
    );
  }

  @nonVirtual
  Widget submitButtonBuilder() {
    return ValueListenableBuilder<T?>(
        key: _submitButtonKey,
        valueListenable: currentAnswer,
        builder: (context, value, _) {
          log(value.toString());
          if (answerStatus != AnswerStatus.none) {
            return FilledButton(
              onPressed: () => onAnswerTapped(value),
              style: answerStatus == AnswerStatus.correct
                  ? context.customButtomTheme.primaryButton
                  : context.customButtomTheme.errorFilledButton,
              child: Text(_getButtonLabel()),
            );
          }

          final bool hasAnswered = !(value == null ||
              (value is String && value.isEmpty) ||
              (value is Iterable && value.isEmpty));

          return FilledButton(
              onPressed:
                  hasAnswered == true ? () => onAnswerTapped(value) : null,
              child: Text(_getButtonLabel()));
        });
  }

  double? _getHeightFromKey(BuildContext context, {required GlobalKey key}) {
    if (key.currentContext == null) {
      return null; // Default height
    }
    final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    return box.hasSize ? box.size.height : null;
  }

  String _getButtonLabel() {
    switch (answerStatus) {
      case AnswerStatus.correct:
        return "Continue";

      case AnswerStatus.wrong:
        return "Got it";

      case AnswerStatus.none:
        return "Check";
    }
  }
}

class ChallengeWidgetFactory {
  static BaseChallengeWidget produce<T>(
      {required Key key,
      required Challenge challenge,
      required void Function(T? userAnswer) onAnswerTapped,
      required AnswerStatus answerStatus}) {
    switch (challenge.exerciseType) {
      case ExerciseType.multipleChoice:
        return MultipleChoicesChallengeWidget(
          challenge: challenge,
          onAnswerTapped: onAnswerTapped as void Function(ChallengeOption?),
          answerStatus: answerStatus,
        );

      case ExerciseType.translateWritten:
        return TranslateChallengeWidget(
          challenge: challenge,
          onAnswerTapped: onAnswerTapped as void Function(String?),
          answerStatus: answerStatus,
        );

      case ExerciseType.sentenceOrder:
        return SentenceOrderChallengeWidget(
            challenge: challenge,
            onAnswerTapped:
                onAnswerTapped as void Function(List<SentenceOrderOption>?),
            answerStatus: answerStatus);

      case ExerciseType.pairMatching:
        return PairMatchingChallengeWidget(
            challenge: challenge,
            onAnswerTapped: onAnswerTapped as void Function(void),
            answerStatus: answerStatus);
    }
  }
}
