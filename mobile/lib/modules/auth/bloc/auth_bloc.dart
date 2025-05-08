import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/enums/auth_state_enum.dart';

import 'package:language_app/domain/repos/user_repo.dart';

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
    await emit.forEach(_userRepo.watchAppState(),
        onData: (data) {
          log(data.toString(), name: "App state");
          switch (data) {
            case AppStateEnum.initial:
              return AuthState.loading();
            case AppStateEnum.authenticated:
              return AuthState.authenticated();
            case AppStateEnum.unauthenticated:
              return AuthState.unauthenticated();
          }
        },
        onError: (error, stackTrace) => AuthState.unauthenticated());
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    await _userRepo.logout();
    emit(AuthState.unauthenticated());
  }
}
