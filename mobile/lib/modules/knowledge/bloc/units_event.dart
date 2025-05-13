part of 'units_bloc.dart';

abstract class UnitsEvent extends Equatable {
  const UnitsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUnitsEvent extends UnitsEvent {
  final String? languageId;

  const LoadUnitsEvent({this.languageId});

  @override
  List<Object?> get props => [languageId];
}
