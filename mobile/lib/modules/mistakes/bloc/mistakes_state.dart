// modules/mistakes/bloc/mistakes_state.dart
part of 'mistakes_bloc.dart';

class MistakesState extends Equatable {
  final ViewStateEnum viewState;
  final List<MistakeEntry> mistakes;
  final String? errorMessage;

  const MistakesState({
    required this.viewState,
    this.mistakes = const [],
    this.errorMessage,
  });

  MistakesState copyWith({
    ViewStateEnum? viewState,
    List<MistakeEntry>? mistakes,
    String? errorMessage,
  }) {
    return MistakesState(
      viewState: viewState ?? this.viewState,
      mistakes: mistakes ?? this.mistakes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [viewState, mistakes, errorMessage];
}
