import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/domain/models/user.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/modules/profile/bloc/profile_event.dart';
import 'package:language_app/modules/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepo _userRepo;
  StreamSubscription? _userSubscription;

  ProfileBloc({required UserRepo userRepo})
      : _userRepo = userRepo,
        super(const ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UserProfileUpdated>(_onUserProfileUpdated);
    on<UserProfileEmptied>(_onUserProfileEmptied);

    _userSubscription = _userRepo.watchUserInfo().listen((user) {
      if (user != null) {
        add(UserProfileUpdated(user));
      } else {
        add(const UserProfileEmptied());
      }
    });
  }

  void _onLoadUserProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoadInProgress());

    final user = await _userRepo.getUserInfo();

    user != null
        ? emit(ProfileLoadSuccess(user: user))
        : emit(const ProfileLoadFailure(error: "User data not available"));
  }

  void _onUserProfileUpdated(
      UserProfileUpdated event, Emitter<ProfileState> emit) {
    emit(ProfileLoadSuccess(user: event.user));
  }

  void _onUserProfileEmptied(
      UserProfileEmptied event, Emitter<ProfileState> emit) {
    emit(const ProfileLoadFailure(error: "User data not available"));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
