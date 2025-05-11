import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/domain/models/challenge.dart';

import 'package:language_app/domain/repos/lesson_repo.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonRepo _lessonRepository;

  LessonBloc({required LessonRepo lessonRepository})
      : _lessonRepository = lessonRepository,
        super(LessonState.loading()) {
    on<LessonStartEvent>(_onLessonStart);
    on<CheckAnswerEvent>(_onCheckAnswer);
    on<ContinueEvent>(_onContinueTapped);
    on<LessonExitEvent>(_onExitTapped);
  }

  void _onLessonStart(LessonStartEvent event, Emitter<LessonState> emit) async {
    emit(LessonState.loading());
    final challengeList =
        await _lessonRepository.getChallengeList(lessonId: event.lessonId);
    if (challengeList.isEmpty) {
      emit(LessonState.error(message: "No challenges found"));
    } else {
      emit(LessonState.inProgress(numOfHeart: 3, challengeList: challengeList));
    }
  }

  void _onCheckAnswer(CheckAnswerEvent event, Emitter<LessonState> emit) {
    final Queue<Challenge> challengeQueue = state.challengeQueue;
    int numOfHeart = state.numOfHeart;
    int? userProgressIndex = state.userProgressIndex;
    int streak = state.streak;
    int totalAttempts = state.totalAttempts;
    int correctFirstAttempts = state.correctFirstAttempts;
    bool isFirstAttempt = state.answerStatus == AnswerStatus.none;

    if (userProgressIndex == null) {
      emit(LessonState.error(message: "No index found"));
      return;
    }

    final bool isCorrect =
        challengeQueue.first.data.checkAnswer(event.userAnswer);

    if (isCorrect == true) {
      userProgressIndex++;
      if (isFirstAttempt) {
        streak++;
        correctFirstAttempts++;
      }
    } else if (isCorrect == false) {
      numOfHeart--;
      streak = 0; // Reset streak on wrong answer
    }
    if (isFirstAttempt) {
      totalAttempts++;
    }

    emit(state.copyWith(
        answerStatus:
            isCorrect == true ? AnswerStatus.correct : AnswerStatus.wrong,
        numOfHeart: numOfHeart != state.numOfHeart ? numOfHeart : null,
        userProgressIndex: userProgressIndex != state.userProgressIndex
            ? userProgressIndex
            : null,
        streak: streak,
        totalAttempts: totalAttempts,
        correctFirstAttempts: correctFirstAttempts));
  }

  void _onContinueTapped(ContinueEvent event, Emitter<LessonState> emit) {
    var numOfHeart = state.numOfHeart;
    final Queue<Challenge> challengeQueue = state.challengeQueue;
    int streak = state.streak;
    int totalAttempts = state.totalAttempts;
    int correctFirstAttempts = state.correctFirstAttempts;
    DateTime? startTime = state.startTime;
    Duration? lessonDuration;
    int earnedXP = 25;
    if (streak >= 5) {
      earnedXP += (streak ~/ 5) * 5;
    }

    switch (state.answerStatus) {
      case AnswerStatus.correct:
        challengeQueue.removeFirst();
        break;
      case AnswerStatus.wrong:
        challengeQueue.addLast(challengeQueue.removeFirst());
        break;
      case AnswerStatus.none:
        break;
    }

    //End condition
    if (numOfHeart == 0 || state.userProgressIndex == state.lessonLength) {
      if (startTime != null) {
        lessonDuration = DateTime.now().difference(startTime);
      }
      emit(LessonState.finished(
        startTime: startTime,
        lessonDuration: lessonDuration,
        streak: streak,
        totalAttempts: totalAttempts,
        correctFirstAttempts: correctFirstAttempts,
        earnedXP: earnedXP,
      ));
    } else {
      emit(state.copyWith(answerStatus: AnswerStatus.none));
    }
  }

  void _onExitTapped(LessonExitEvent event, Emitter<LessonState> emit) {
    DateTime? startTime = state.startTime;
    Duration? lessonDuration;
    if (startTime != null) {
      lessonDuration = DateTime.now().difference(startTime);
    }
    emit(LessonState.finished(
      startTime: startTime,
      lessonDuration: lessonDuration,
      streak: state.streak,
      totalAttempts: state.totalAttempts,
      correctFirstAttempts: state.correctFirstAttempts,
      earnedXP: state.earnedXP,
    ));
  }
}
