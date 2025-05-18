part of 'units_bloc.dart';

class UnitsState extends Equatable {
  final ViewStateEnum viewState;
  final List<UnitResponse> units;
  final String? selectedLanguageId;
  final String? errorMessage;

  const UnitsState({
    required this.viewState,
    this.units = const [],
    this.selectedLanguageId,
    this.errorMessage,
  });

  UnitsState copyWith({
    ViewStateEnum? viewState,
    List<UnitResponse>? units,
    String? selectedLanguageId,
    String? errorMessage,
  }) {
    return UnitsState(
      viewState: viewState ?? this.viewState,
      units: units ?? this.units,
      selectedLanguageId: selectedLanguageId ?? this.selectedLanguageId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [viewState, units, selectedLanguageId, errorMessage];
}
