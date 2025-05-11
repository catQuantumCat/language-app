import 'package:equatable/equatable.dart';
import 'package:language_app/domain/models/user.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  const LoadUserProfile();
}

class UserProfileUpdated extends ProfileEvent {
  final User user;

  const UserProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserProfileEmptied extends ProfileEvent {
  const UserProfileEmptied();
}
