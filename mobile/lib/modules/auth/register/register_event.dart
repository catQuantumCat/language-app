part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUsernameChanged extends RegisterEvent {
  final String username;

  const RegisterUsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class RegisterFullNameChanged extends RegisterEvent {
  final String fullName;

  const RegisterFullNameChanged(this.fullName);

  @override
  List<Object> get props => [fullName];
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;

  const RegisterConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
