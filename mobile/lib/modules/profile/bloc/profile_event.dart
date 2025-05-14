// modules/profile/bloc/profile_event.dart
part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String? fullName;
  final String? email;
  final String? password;

  const UpdateProfileEvent({
    this.fullName,
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

class ChangeAvatarEvent extends ProfileEvent {
  final File? imageFile;
  final String? imageUrl;

  const ChangeAvatarEvent({
    this.imageFile,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [imageFile, imageUrl];
}
