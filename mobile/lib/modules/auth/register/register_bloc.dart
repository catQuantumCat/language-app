import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/data/models/register_model.dart';
import 'package:language_app/domain/models/user.dart';
import 'package:language_app/domain/repo/user_repo.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepo _userRepo;

  RegisterBloc({required UserRepo userRepo})
      : _userRepo = userRepo,
        super(const RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterFullNameChanged>(_onFullNameChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  void _onUsernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      username: event.username,
      status: RegisterStatus.initial,
      errorMessage: '',
    ));
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      status: RegisterStatus.initial,
      errorMessage: '',
    ));
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      status: RegisterStatus.initial,
      errorMessage: '',
    ));
  }

  void _onFullNameChanged(
    RegisterFullNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      fullName: event.fullName,
      status: RegisterStatus.initial,
      errorMessage: '',
    ));
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      status: RegisterStatus.initial,
      errorMessage: '',
    ));
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.username.isEmpty ||
        state.email.isEmpty ||
        state.password.isEmpty ||
        state.fullName.isEmpty) {
      return emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'All fields are required',
      ));
    }

    if (state.password != state.confirmPassword) {
      return emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Passwords do not match',
      ));
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(state.email)) {
      return emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Please enter a valid email address',
      ));
    }

    // Validate password strength
    if (state.password.length < 6) {
      return emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Password must be at least 6 characters long',
      ));
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      await _userRepo.register(
        data: RegisterModel(
          username: state.username,
          email: state.email,
          password: state.password,
          fullName: state.fullName,
        ),
      );
      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
