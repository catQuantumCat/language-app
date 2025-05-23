import 'dart:collection';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/domain/models/challenge.dart';
import 'package:language_app/domain/models/result.dart';
import 'package:language_app/domain/models/user.dart';

import 'package:language_app/domain/repos/lesson_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonRepo _lessonRepository;
  final UserRepo _userRepository;

  late final String unitId;
  late final String lessonId;
  late final String languageId;
  late final User? user;

  LessonBloc(
      {required LessonRepo lessonRepository, required UserRepo userRepository})
      : _lessonRepository = lessonRepository,
        _userRepository = userRepository,
        super(LessonState.loading()) {
    on<LessonStartEvent>(_onLessonStart);
    on<CheckAnswerEvent>(_onCheckAnswer);
    on<ContinueEvent>(_onContinueTapped);
    on<LessonExitEvent>(_onExitTapped);
  }

  void _onLessonStart(LessonStartEvent event, Emitter<LessonState> emit) async {
    emit(LessonState.loading());
    unitId = event.unitId;
    lessonId = event.lessonId;
    languageId = event.languageId;
    user = await _userRepository.getUserInfo();
    final challengeList =
        await _lessonRepository.getChallengeList(lessonId: event.lessonId);
    if (challengeList.isEmpty) {
      emit(LessonState.error(message: "No challenges found"));
    } else {
      emit(LessonState.inProgress(
          numOfHeart: user?.hearts ?? 1, challengeList: challengeList));
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
      streak = 0;
    }
    if (isFirstAttempt) {
      totalAttempts++;
    }

    List<String> updatedIncorrectExerciseIds = state.incorrectExerciseIds;
    if (!isCorrect) {
      updatedIncorrectExerciseIds = [
        ...state.incorrectExerciseIds,
        challengeQueue.first.id
      ];
    }

    emit(state.copyWith(
        incorrectExerciseIds: updatedIncorrectExerciseIds,
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

  Future<void> _onContinueTapped(
      ContinueEvent event, Emitter<LessonState> emit) async {
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

    // End condition
    if (state.userProgressIndex == state.lessonLength) {
      if (startTime != null) {
        lessonDuration = DateTime.now().difference(startTime);
      }

      final updatedState = LessonState.finished(
        startTime: startTime,
        lessonDuration: lessonDuration,
        streak: streak,
        totalAttempts: totalAttempts,
        correctFirstAttempts: correctFirstAttempts,
        earnedXP: earnedXP,
        numOfHeart: numOfHeart,
        incorrectExerciseIds: state.incorrectExerciseIds,
      );
      emit(LessonState.loading());

      await _sendResult(updatedState, emit);
      emit(updatedState);
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

    final updatedState = LessonState.finished(
      startTime: startTime,
      lessonDuration: lessonDuration,
      streak: state.streak,
      totalAttempts: state.totalAttempts,
      correctFirstAttempts: state.correctFirstAttempts,
      earnedXP: state.earnedXP,
      numOfHeart: state.numOfHeart,
    );

    emit(updatedState);
    _sendResult(updatedState, emit);
  }

  Future<void> _sendResult(LessonState state, Emitter<LessonState> emit) async {
    log("state.incorrectExerciseIds: ${state.incorrectExerciseIds}",
        name: "Log exercise ids");
    final Result result = Result(
      lessonId: lessonId,
      exercises: state.incorrectExerciseIds
          .map((e) => ResultIncorrectExerciseModel(exerciseId: e))
          .toList(),
      hearts: state.numOfHeart,
      experienceGained: state.earnedXP > 0 ? state.earnedXP : 25,
      timeSpent: state.lessonDuration?.inSeconds ?? 0,
      streak: 1,
    );

    try {
      if (user != null) {
        await _lessonRepository.sendResult(
            languageId: languageId,
            result: result,
            unitId: unitId,
            userId: user!.id);

        await _userRepository.forceUpdateUserProfile();
      }
    } catch (e) {
      emit(LessonState.error(message: 'Error sending lesson results: $e'));
    }
  }
}
