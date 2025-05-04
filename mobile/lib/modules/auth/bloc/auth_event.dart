part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

//Save new key
// final class SaveTokenEvent implements AuthEvent {
//   @override
//   List<Object?> get props => [];
//   final UserDTO userData;

//   SaveTokenEvent({required this.userData});

//   @override
//   bool? get stringify => true;
// }

final class InitEvent implements AuthEvent {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

//Remove old key
final class LogOutEvent implements AuthEvent {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

//Check if key is exist
final class CheckTokenEvent implements AuthEvent {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => true;
}
