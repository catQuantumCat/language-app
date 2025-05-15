// modules/profile/bloc/profile_bloc.dart
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/domain/dtos/update_profile_dto.dart';
import 'package:language_app/domain/models/user_profile.dart';
import 'package:language_app/domain/models/user_rank_info.dart';
import 'package:language_app/domain/repos/user_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepo _userRepo;

  ProfileBloc({required UserRepo userRepo})
      : _userRepo = userRepo,
        super(ProfileState(viewState: ViewStateEnum.initial)) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangeAvatarEvent>(_onChangeAvatar);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(viewState: ViewStateEnum.loading));

    try {
      final userProfile = await _userRepo.getUserProfile();
      final userRankInfo = await _userRepo.getUserRankInfo();
      
      emit(state.copyWith(
        viewState: ViewStateEnum.succeed,
        userProfile: userProfile,
        userRank: userRankInfo.currentUser,
      ));
    } catch (e) {
      emit(state.copyWith(
        viewState: ViewStateEnum.failed,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateProfile(
  UpdateProfileEvent event,
  Emitter<ProfileState> emit,
) async {
  if (state.userProfile == null) return;
  
  emit(state.copyWith(
    updateState: ViewStateEnum.loading,
    updateMessage: 'Đang cập nhật thông tin...',
  ));

  try {
    final updatedProfile = await _userRepo.updateUserProfile(
      state.userProfile!.id,
      UpdateProfileDto(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        avatarFile: state.avatarFile,
      ),
    );
    
    emit(state.copyWith(
      userProfile: updatedProfile,
      updateState: ViewStateEnum.succeed,
      updateMessage: 'Cập nhật thành công!',
      avatarFile: null, // Reset avatarFile sau khi cập nhật
    ));
  } catch (e) {
    emit(state.copyWith(
      updateState: ViewStateEnum.failed,
      updateMessage: 'Cập nhật thất bại: ${e.toString()}',
    ));
  }
}

 Future<void> _onChangeAvatar(
  ChangeAvatarEvent event,
  Emitter<ProfileState> emit,
) async {
  if (event.imageFile != null && state.userProfile != null) {
    // Cập nhật state để hiển thị loading
    emit(state.copyWith(
      avatarFile: event.imageFile,
      updateState: ViewStateEnum.loading,
      updateMessage: 'Đang cập nhật ảnh đại diện...',
    ));
    
    try {
      final updatedProfile = await _userRepo.updateUserProfile(
        state.userProfile!.id,
        UpdateProfileDto(
          avatarFile: event.imageFile,
        ),
      );
      
      emit(state.copyWith(
        userProfile: updatedProfile,
        updateState: ViewStateEnum.succeed,
        updateMessage: 'Cập nhật ảnh đại diện thành công!',
        avatarFile: null, // Reset avatarFile sau khi cập nhật
      ));
    } catch (e) {
      emit(state.copyWith(
        updateState: ViewStateEnum.failed,
        updateMessage: 'Cập nhật ảnh đại diện thất bại: ${e.toString()}',
      ));
    }
  } else {
    // Chỉ cập nhật avatarFile trong state nếu không có profile
    emit(state.copyWith(
      avatarFile: event.imageFile,
    ));
  }
}
}
