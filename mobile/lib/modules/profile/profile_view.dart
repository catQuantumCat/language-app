// modules/profile/profile_view.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/language.dart';
import 'package:language_app/domain/models/user.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/gen/assets.gen.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/auth/bloc/auth_bloc.dart';
import 'package:language_app/modules/profile/bloc/profile_bloc.dart';
import 'package:language_app/modules/profile/widgets/edit_profile_dialog.dart';
import 'package:language_app/modules/profile/widgets/profile_section.dart';
import 'package:language_app/modules/profile/widgets/stats_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        userRepo: getIt<UserRepo>(),
      )..add(LoadProfileEvent()),
      child: const ProfileContent(),
    );
  }
}

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.updateState == ViewStateEnum.succeed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.updateMessage ?? 'Cập nhật thành công'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.updateState == ViewStateEnum.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.updateMessage ?? 'Cập nhật thất bại'),
                backgroundColor: context.colorTheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.viewState == ViewStateEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.viewState == ViewStateEnum.failed) {
            return _buildErrorView(context, state.errorMessage);
          } else if (state.userProfile != null) {
            return _buildProfileView(context, state);
          } else {
            return const Center(child: Text('Không có dữ liệu'));
          }
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: context.colorTheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Không thể tải thông tin hồ sơ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'Đã xảy ra lỗi',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colorTheme.error,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(LoadProfileEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorTheme.primary,
              foregroundColor: context.colorTheme.onPrimary,
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, ProfileState state) {
    final profile = state.userProfile!;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(LoadProfileEvent());
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            toolbarHeight: 20,
            collapsedHeight: 20,
            pinned: false,
            floating: true,
            snap: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(context, profile, state),
              stretchModes: const [
                StretchMode.zoomBackground,
              ],
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                children: [
                  _buildStatistics(context, profile, state),
                  const SizedBox(height: 32),
                  ProfileSection(
                    title: 'Ngôn ngữ đang học',
                    child: _buildLanguagesList(context, profile.languages),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    User profile,
    ProfileState state,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        // Background profile image
        profile.avatar != null && profile.avatar!.isNotEmpty
            ? Image.network(
                profile.avatar!,
                fit: BoxFit.cover,
              )
            : Container(
                color: context.colorTheme.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person,
                  size: 120,
                  color: context.colorTheme.primary,
                ),
              ),
        // Gradient overlay for readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        // Centered user info
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${profile.username}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.email_outlined, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      profile.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: kToolbarHeight + 16,
          right: 16,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'change_avatar',
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, color: context.colorTheme.primary),
                      const SizedBox(width: 12),
                      const Text('Đổi ảnh đại diện'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit_profile',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: context.colorTheme.primary),
                      const SizedBox(width: 12),
                      const Text('Chỉnh sửa thông tin'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: context.colorTheme.error),
                      const SizedBox(width: 12),
                      Text(
                        'Đăng xuất',
                        style: TextStyle(color: context.colorTheme.error),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'change_avatar':
                    _showImageSourceOptions(context);
                    break;
                  case 'edit_profile':
                    _showEditProfileDialog(context, profile);
                    break;
                  case 'logout':
                    _showLogoutConfirmation(context);
                    break;
                }
              },
            ),
          ),
        ),
        if (state.updateState == ViewStateEnum.loading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatistics(
    BuildContext context,
    User profile,
    ProfileState state,
  ) {
    return ProfileSection(
      title: 'Thống kê',
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 20 / 9,
        children: [
          StatsCard(
            icon: Icons.star,
            iconColor: Colors.blue,
            title: 'Tổng kinh nghiệm',
            value: '${profile.experience}',
          ),
          StatsCard(
            icon: Icons.favorite,
            iconColor: context.colorTheme.heartColor,
            title: 'Tim',
            value: '${profile.hearts}',
          ),
          StatsCard(
            icon: Icons.local_fire_department,
            iconColor: context.colorTheme.streakFireColor,
            title: 'Ngày streak',
            value: '${profile.streak}',
          ),
          StatsCard(
            icon: Icons.leaderboard,
            iconColor: Colors.purple,
            title: 'Thứ hạng',
            value: state.userRank != null ? '${state.userRank!.rank}' : '-',
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesList(BuildContext context, List<Language> languages) {
    if (languages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text('Chưa có ngôn ngữ nào được chọn'),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: languages.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 16,
      ),
      itemBuilder: (context, index) {
        final language = languages[index];
        return Card(
          color: context.colorTheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 2,
            ),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.colorTheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: language.languageFlag != null &&
                          language.languageFlag!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            language.languageFlag!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.language,
                                color: context.colorTheme.primary),
                          ),
                        )
                      : Icon(Icons.language, color: context.colorTheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.languageName,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bài học hiện tại: ${language.lessonOrder}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Chương hiện tại: ${language.unitOrder}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogOutEvent());
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colorTheme.error,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Chụp ảnh mới'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Chọn từ thư viện'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        // Thêm file vào state mà không hiển thị dialog loading
        context.read<ProfileBloc>().add(
              ChangeAvatarEvent(
                imageFile: File(image.path),
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể chọn ảnh: ${e.toString()}'),
            backgroundColor: context.colorTheme.error,
          ),
        );
      }
    }
  }

  // Giả lập việc upload ảnh
  Future<String> _uploadImage(File imageFile) async {
    // Trong thực tế, bạn sẽ upload ảnh lên server và nhận về URL
    // Đây chỉ là giả lập
    await Future.delayed(const Duration(seconds: 1));
    return "https://example.com/uploaded_avatar.jpg";
  }

  void _showEditProfileDialog(BuildContext context, User profile) {
    showDialog(
      context: context, // Truyền context đúng
      builder: (dialogContext) => BlocProvider.value(
        value: context
            .read<ProfileBloc>(), // Sử dụng BlocProvider.value để chia sẻ bloc
        child: EditProfileDialog(
          initialFullName: profile.fullName,
          initialEmail: profile.email,
        ),
      ),
    );
  }
}
