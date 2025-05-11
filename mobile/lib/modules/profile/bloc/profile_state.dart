import 'package:equatable/equatable.dart';
import 'package:language_app/domain/models/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoadInProgress extends ProfileState {
  const ProfileLoadInProgress();
}

class ProfileLoadSuccess extends ProfileState {
  final User user;

  const ProfileLoadSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileLoadFailure extends ProfileState {
  final String error;

  const ProfileLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
