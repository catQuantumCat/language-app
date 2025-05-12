// modules/mistakes/bloc/mistake_detail_state.dart
part of 'mistake_detail_bloc.dart';

class MistakeDetailState extends Equatable {
  final ViewStateEnum viewState;
  final MistakeDetail? mistakeDetail;
  final String? errorMessage;

  const MistakeDetailState({
    required this.viewState,
    this.mistakeDetail,
    this.errorMessage,
  });

  MistakeDetailState copyWith({
    ViewStateEnum? viewState,
    MistakeDetail? mistakeDetail,
    String? errorMessage,
  }) {
    return MistakeDetailState(
      viewState: viewState ?? this.viewState,
      mistakeDetail: mistakeDetail ?? this.mistakeDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [viewState, mistakeDetail, errorMessage];
}
