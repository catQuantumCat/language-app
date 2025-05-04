import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:language_app/domain/models/user.dart';
import 'package:language_app/domain/repo/user_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepo _userRepo;

  AuthBloc({required UserRepo userRepo})
      : _userRepo = userRepo,
        super(AuthState.loading()) {
    on<InitEvent>(_onInit);
    on<LogOutEvent>(_onLogOut);

    add(InitEvent());
  }

  Future<void> _onInit(InitEvent event, Emitter<AuthState> emit) async {
    try {
      final User? user = await _userRepo.getUserInfo();
      final String? token = await _userRepo.getToken();

      // Only authenticate if both user and token exist
      if (user != null && token != null) {
        emit(AuthState.authenticated(user: user));
      }
    } catch (e) {
      // User info not found or other error, remain unauthenticated
      log('No stored user credentials found: ${e.toString()}',
          name: 'AuthBloc');
      emit(AuthState.unauthenticated());
    }

    await emit.forEach(await _userRepo.getUserInfoStream(),
        onData: (data) {
          log(data?.email.toString() ?? "null", name: "on token data");
          if (data == null) {
            return AuthState.unauthenticated();
          }
          return AuthState.authenticated(user: data);
        },
        onError: (error, stackTrace) => AuthState.unauthenticated());
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    await _userRepo.logout();
    emit(AuthState.unauthenticated());
  }

  //TODO: remove before commit

  // void _changeAuthState(
  //   User? user,
  //   Emitter<AuthState> emit,
  // ) {
  //   if (user == null) {
  //     emit(const AuthState.unauthenticated());
  //   } else {
  //     emit(AuthState.authenticated(user: user));
  //   }
  // }
}
