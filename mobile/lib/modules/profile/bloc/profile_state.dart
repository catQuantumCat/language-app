
// modules/profile/bloc/profile_state.dart
part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final ViewStateEnum viewState;
  final User? userProfile;
  final UserRankDetail? userRank;
  final String? errorMessage;
  
  // Trạng thái cập nhật
  final ViewStateEnum updateState;
  final String? updateMessage;
  
  // Lưu trữ avatar mới
  final File? avatarFile;
  final String? avatarUrl;

  const ProfileState({
    required this.viewState,
    this.userProfile,
    this.userRank,
    this.errorMessage,
    this.updateState = ViewStateEnum.initial,
    this.updateMessage,
    this.avatarFile,
    this.avatarUrl,
  });

  ProfileState copyWith({
    ViewStateEnum? viewState,
    User? userProfile,
    UserRankDetail? userRank,
    String? errorMessage,
    ViewStateEnum? updateState,
    String? updateMessage,
    File? avatarFile,
    String? avatarUrl,
  }) {
    return ProfileState(
      viewState: viewState ?? this.viewState,
      userProfile: userProfile ?? this.userProfile,
      userRank: userRank ?? this.userRank,
      errorMessage: errorMessage ?? this.errorMessage,
      updateState: updateState ?? this.updateState,
      updateMessage: updateMessage ?? this.updateMessage,
      avatarFile: avatarFile ?? this.avatarFile,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [
    viewState, 
    userProfile, 
    userRank, 
    errorMessage, 
    updateState, 
    updateMessage,
    avatarFile,
    avatarUrl,
  ];
}
