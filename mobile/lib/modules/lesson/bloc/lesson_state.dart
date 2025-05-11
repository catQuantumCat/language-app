// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'lesson_bloc.dart';

enum LessonStatus { loading, inProgress, finished, error }

enum AnswerStatus { correct, wrong, none }

class LessonState extends Equatable {
  final LessonStatus status;
  final int numOfHeart;
  final Queue<Challenge> challengeQueue;
  final int? lessonLength;
  final int? userProgressIndex;
  final AnswerStatus answerStatus;

  final String? message;
  final DateTime? startTime;
  final Duration? lessonDuration;
  final int streak;
  final int totalAttempts;
  final int correctFirstAttempts;
  final int earnedXP;
  final List<String> incorrectExerciseIds;

  double get accuracy =>
      totalAttempts == 0 ? 0 : correctFirstAttempts / totalAttempts;

  bool get isOutOfHeart => numOfHeart == 0;

  bool get isInProgress => totalAttempts != 0;

  LessonState._({
    required this.status,
    this.numOfHeart = 0,
    Queue<Challenge>? challengeQueue,
    this.lessonLength,
    this.answerStatus = AnswerStatus.none,
    this.userProgressIndex,
    this.message,
    this.startTime,
    this.lessonDuration,
    this.streak = 0,
    this.totalAttempts = 0,
    this.correctFirstAttempts = 0,
    this.earnedXP = 0,
    this.incorrectExerciseIds = const [],
  }) : challengeQueue = challengeQueue ?? Queue<Challenge>();

  LessonState.loading() : this._(status: LessonStatus.loading);

  LessonState.inProgress({
    required int numOfHeart,
    required List<Challenge> challengeList,
    AnswerStatus answerStatus = AnswerStatus.none,
  }) : this._(
          status: LessonStatus.inProgress,
          numOfHeart: numOfHeart,
          userProgressIndex: 0,
          challengeQueue: Queue.from(challengeList),
          lessonLength: challengeList.length,
          answerStatus: answerStatus,
          startTime: DateTime.now(),
        );

  LessonState.finished({
    DateTime? startTime,
    Duration? lessonDuration,
    int streak = 0,
    int totalAttempts = 0,
    int correctFirstAttempts = 0,
    int earnedXP = 0,
  }) : this._(
          status: LessonStatus.finished,
          message: "You've completed this lesson",
          startTime: startTime,
          lessonDuration: lessonDuration,
          streak: streak,
          totalAttempts: totalAttempts,
          correctFirstAttempts: correctFirstAttempts,
          earnedXP: earnedXP,
        );

  LessonState.error({required String message})
      : this._(
          status: LessonStatus.error,
          message: message,
        );

  @override
  List<Object?> get props => [
        status,
        numOfHeart,
        challengeQueue,
        lessonLength,
        answerStatus,
        message,
        startTime,
        lessonDuration,
        streak,
        totalAttempts,
        correctFirstAttempts,
        earnedXP,
        incorrectExerciseIds,
      ];

  LessonState copyWith({
    LessonStatus? status,
    int? numOfHeart,
    Queue<Challenge>? challengeQueue,
    int? lessonLength,
    int? userProgressIndex,
    AnswerStatus? answerStatus,
    String? message,
    DateTime? startTime,
    Duration? lessonDuration,
    int? streak,
    int? totalAttempts,
    int? correctFirstAttempts,
    int? earnedXP,
    List<String>? incorrectExerciseIds,
  }) {
    return LessonState._(
      status: status ?? this.status,
      numOfHeart: numOfHeart ?? this.numOfHeart,
      challengeQueue: challengeQueue ?? this.challengeQueue,
      lessonLength: lessonLength ?? this.lessonLength,
      userProgressIndex: userProgressIndex ?? this.userProgressIndex,
      answerStatus: answerStatus ?? this.answerStatus,
      message: message ?? this.message,
      startTime: startTime ?? this.startTime,
      lessonDuration: lessonDuration ?? this.lessonDuration,
      streak: streak ?? this.streak,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      correctFirstAttempts: correctFirstAttempts ?? this.correctFirstAttempts,
      earnedXP: earnedXP ?? this.earnedXP,
      incorrectExerciseIds: incorrectExerciseIds ?? this.incorrectExerciseIds,
    );
  }
}
