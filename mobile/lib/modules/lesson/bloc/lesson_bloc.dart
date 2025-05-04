import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/domain/models/challenge.dart';

import 'package:language_app/domain/repo/lesson_repo.dart';

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
    add(LessonStartEvent());
  }

  void _onLessonStart(LessonStartEvent event, Emitter<LessonState> emit) async {
    emit(LessonState.loading());
    final challengeList = await _lessonRepository.getChallengeList();
    emit(LessonState.inProgress(numOfHeart: 3, challengeList: challengeList));
  }

  void _onCheckAnswer(CheckAnswerEvent event, Emitter<LessonState> emit) {
    final Queue<Challenge> challengeQueue = state.challengeQueue;
    int numOfHeart = state.numOfHeart;
    int? userProgressIndex = state.userProgressIndex;

    if (userProgressIndex == null) {
      emit(LessonState.finished(
        hasWon: false,
      ));
      return;
    }

    final bool isCorrect =
        challengeQueue.first.data.checkAnswer(event.userAnswer);

    if (isCorrect == true) {
      userProgressIndex++;
    } else if (isCorrect == false) {
      numOfHeart--;
    }

    emit(state.copyWith(
        answerStatus:
            isCorrect == true ? AnswerStatus.correct : AnswerStatus.wrong,
        numOfHeart: numOfHeart != state.numOfHeart ? numOfHeart : null,
        userProgressIndex: userProgressIndex != state.userProgressIndex
            ? userProgressIndex
            : null));
  }

  void _onContinueTapped(ContinueEvent event, Emitter<LessonState> emit) {
    var numOfHeart = state.numOfHeart;
    final Queue<Challenge> challengeQueue = state.challengeQueue;

    switch (state.answerStatus) {
      case AnswerStatus.correct:
        challengeQueue.removeFirst();

      case AnswerStatus.wrong:
        challengeQueue.addLast(challengeQueue.removeFirst());

      case AnswerStatus.none:
    }

    //End condition
    if (numOfHeart == 0 || state.userProgressIndex == state.lessonLength) {
      emit(LessonState.finished(hasWon: numOfHeart == 0));
    } else {
      emit(state.copyWith(answerStatus: AnswerStatus.none));
    }
  }

  void _onExitTapped(LessonExitEvent event, Emitter<LessonState> emit) {
    emit(LessonState.finished(hasWon: true));
  }
}
