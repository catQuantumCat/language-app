// modules/mistakes/bloc/mistake_detail_event.dart
part of 'mistake_detail_bloc.dart';

abstract class MistakeDetailEvent extends Equatable {
  const MistakeDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadMistakeDetailEvent extends MistakeDetailEvent {
  final String mistakeId;

  const LoadMistakeDetailEvent(this.mistakeId);

  @override
  List<Object> get props => [mistakeId];
}
