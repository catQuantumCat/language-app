import 'dart:collection';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/data/models/challenge.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  LessonBloc() : super(LessonState.loading()) {
    on<LessonStartEvent>(_onLessonStart);
    on<CheckAnswerEvent>(_onCheckAnswer);
    on<ContinueEvent>(_onContinueTapped);
    on<LessonExitEvent>(_onExitTapped);
    add(LessonStartEvent());
  }

  void _onLessonStart(LessonStartEvent event, Emitter<LessonState> emit) {
    emit(LessonState.loading());
    emit(LessonState.inProgress(numOfHeart: 3, challengeList: dummyChallenges));
  }

  void _onCheckAnswer(CheckAnswerEvent event, Emitter<LessonState> emit) {
    final challengeQueue = state.challengeQueue;

    log(challengeQueue.first.data.toString());

    final bool isCorrect =
        challengeQueue.first.data.checkAnswer(event.userAnswer);

    log("$isCorrect");

    emit(
      state.copyWith(
        answerStatus:
            isCorrect == true ? AnswerStatus.correct : AnswerStatus.wrong,
      ),
    );
  }

  void _onContinueTapped(ContinueEvent event, Emitter<LessonState> emit) {
    var numOfHeart = state.numOfHeart;
    var challengeQueue = state.challengeQueue;

    log(state.answerStatus.toString(), name: "onContinueTapped");

    if (state.answerStatus == AnswerStatus.none) return;

    if (state.answerStatus == AnswerStatus.correct) {
      challengeQueue.removeFirst();
    } else {
      numOfHeart--;
      challengeQueue.addLast(challengeQueue.removeFirst());
    }

    if (numOfHeart == 0 || challengeQueue.isEmpty) {
      emit(LessonState.finished(isOutOfHeart: numOfHeart == 0));
    } else {
      log(state.answerStatus.toString(), name: "onContinueTapped after");
      emit(state.copyWith(
          numOfHeart: numOfHeart,
          challengeQueue: challengeQueue,
          answerStatus: AnswerStatus.none));
    }
  }

  void _onExitTapped(LessonExitEvent event, Emitter<LessonState> emit) {
    emit(LessonState.finished(isOutOfHeart: true));
  }
}
