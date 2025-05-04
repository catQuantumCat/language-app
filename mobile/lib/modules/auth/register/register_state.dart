part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String fullName;
  final RegisterStatus status;
  final String errorMessage;

  const RegisterState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.fullName = '',
    this.status = RegisterStatus.initial,
    this.errorMessage = '',
  });

  RegisterState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    String? fullName,
    RegisterStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      fullName: fullName ?? this.fullName,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        username,
        email,
        password,
        confirmPassword,
        fullName,
        status,
        errorMessage,
      ];
}
