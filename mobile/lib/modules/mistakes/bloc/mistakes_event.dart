// modules/mistakes/bloc/mistakes_event.dart
part of 'mistakes_bloc.dart';

abstract class MistakesEvent extends Equatable {
  const MistakesEvent();

  @override
  List<Object> get props => [];
}

class LoadMistakesEvent extends MistakesEvent {}
