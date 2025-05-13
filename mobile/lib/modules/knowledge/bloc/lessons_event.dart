part of 'lessons_bloc.dart';

abstract class LessonsEvent extends Equatable {
  const LessonsEvent();

  @override
  List<Object> get props => [];
}

class LoadLessonsEvent extends LessonsEvent {
  final String unitId;
  final String unitTitle;
  final int unitOrder;

  const LoadLessonsEvent({
    required this.unitId,
    required this.unitTitle,
    required this.unitOrder,
  });

  @override
  List<Object> get props => [unitId, unitTitle, unitOrder];
}
