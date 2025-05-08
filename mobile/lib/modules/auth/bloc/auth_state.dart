part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AppStateEnum status;

  const AuthState({required this.status});

  const AuthState.authenticated() : status = AppStateEnum.authenticated;

  const AuthState.unauthenticated() : status = AppStateEnum.unauthenticated;

  const AuthState.loading() : status = AppStateEnum.initial;

  @override
  List<Object?> get props => [status];
}
