part of 'lesson_bloc.dart';

enum LessonStatus { loading, inProgress, finished }

enum AnswerStatus {correct, wrong, none}

class LessonState extends Equatable {
  final LessonStatus status;
  final int numOfHeart;
  final Queue<Challenge> challengeQueue;
  final int lessonLength;
  final AnswerStatus answerStatus;
  final bool isOutOfHeart;
  final String? message;

  LessonState._({
    required this.status,
    this.numOfHeart = 0,
    Queue<Challenge>? challengeQueue,
    this.lessonLength = 0,
    this.answerStatus = AnswerStatus.none,
    this.isOutOfHeart = false,
    this.message,
  }) : challengeQueue = challengeQueue ?? Queue<Challenge>();

  LessonState.loading() : this._(status: LessonStatus.loading);

  LessonState.inProgress({
    required int numOfHeart,
    required List<Challenge> challengeList,
    AnswerStatus answerStatus = AnswerStatus.none,
  }) : this._(
          status: LessonStatus.inProgress,
          numOfHeart: numOfHeart,
          challengeQueue: Queue.from(challengeList),
          lessonLength: challengeList.length,
          answerStatus: answerStatus,
        );

  LessonState.finished({bool isOutOfHeart = false})
      : this._(
          status: LessonStatus.finished,
          isOutOfHeart: isOutOfHeart,
          message:
              isOutOfHeart ? "No heart left" : "You've completed this lesson",
        );

  @override
  List<Object?> get props => [
        status,
        numOfHeart,
        challengeQueue,
        lessonLength,
        answerStatus,
        isOutOfHeart,
        message,
      ];

  LessonState copyWith({
    LessonStatus? status,
    int? numOfHeart,
    Queue<Challenge>? challengeQueue,
    int? lessonLength,
    AnswerStatus? answerStatus,
    bool? isOutOfHeart,
    String? message,
  }) {
    return LessonState._(
      status: status ?? this.status,
      numOfHeart: numOfHeart ?? this.numOfHeart,
      challengeQueue: challengeQueue ?? this.challengeQueue,
      lessonLength: lessonLength ?? this.lessonLength,
      answerStatus: answerStatus ?? this.answerStatus,
      isOutOfHeart: isOutOfHeart ?? this.isOutOfHeart,
      message: message ?? this.message,
    );
  }
}
