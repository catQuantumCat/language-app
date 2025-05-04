part of 'auth_bloc.dart';

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;

  const AuthState({required this.status, required this.user});

  const AuthState.authenticated({required this.user})
      : status = AuthStatus.authenticated;

  const AuthState.unauthenticated()
      : user = null,
        status = AuthStatus.unauthenticated;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null;

  @override
  List<Object?> get props => [status, user];
}
