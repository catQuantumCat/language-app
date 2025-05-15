import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/data/models/login_model.dart';

import 'package:language_app/domain/repos/user_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepo _userRepo;

  LoginBloc({required UserRepo userRepo})
      : _userRepo = userRepo,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      username: event.username,
      status: LoginStatus.initial,
      errorMessage: '',
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      status: LoginStatus.initial,
      errorMessage: '',
    ));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.username.isEmpty || state.password.isEmpty) {
      return emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Username and password cannot be empty',
      ));
    }

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      await _userRepo.login(
        data: LoginModel(
          username: state.username,
          password: state.password,
        ),
      );
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      rethrow;
      //TODO: add later
      // emit(state.copyWith(
      //   status: LoginStatus.failure,
      //   errorMessage: e.toString(),
      // ));
    }
  }
}
