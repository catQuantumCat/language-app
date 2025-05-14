// modules/profile/profile_view.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/user_profile.dart';
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
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        backgroundColor: context.colorTheme.primary,
        foregroundColor: context.colorTheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
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
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar và thông tin cơ bản
              _buildProfileHeader(context, profile, state),
              
              const SizedBox(height: 24),
              
              // Thống kê
              _buildStatistics(context, profile, state),
              
              const SizedBox(height: 24),
              
              // Ngôn ngữ đang học
              ProfileSection(
                title: 'Ngôn ngữ đang học',
                child: _buildLanguagesList(context, profile.languages),
              ),
              
              const SizedBox(height: 16),
              
              // Nút chỉnh sửa hồ sơ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.updateState == ViewStateEnum.loading
                      ? null
                      : () => _showEditProfileDialog(context, profile),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorTheme.primary,
                    foregroundColor: context.colorTheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Chỉnh sửa hồ sơ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context, 
    UserProfile profile,
    ProfileState state,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            // Avatar
            GestureDetector(
              onTap: () => _showImageSourceOptions(context),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: context.colorTheme.primary.withOpacity(0.1),
                backgroundImage: _getProfileImage(state, profile),
                child: _getAvatarChild(state, profile),
              ),
            ),
            
            // Edit avatar button
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colorTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, size: 20),
                  color: context.colorTheme.onPrimary,
                  onPressed: () => _showImageSourceOptions(context),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Tên người dùng
        Text(
          profile.fullName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        
        const SizedBox(height: 4),
        
        // Username
        Text(
          '@${profile.username}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        
        const SizedBox(height: 8),
        
        // Email
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email_outlined,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              profile.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ],
    );
  }

  ImageProvider? _getProfileImage(ProfileState state, UserProfile profile) {
    if (state.avatarFile != null) {
      return FileImage(state.avatarFile!);
    } else if (profile.avatar != null && profile.avatar!.isNotEmpty) {
      return NetworkImage(profile.avatar!);
    }
    return null;
  }

  Widget? _getAvatarChild(ProfileState state, UserProfile profile) {
    if (state.avatarFile != null || (profile.avatar != null && profile.avatar!.isNotEmpty)) {
      return null;
    }
    return Icon(
      Icons.person,
      size: 60,
      color: context.colorTheme.primary,
    );
  }

  Widget _buildStatistics(
    BuildContext context, 
    UserProfile profile,
    ProfileState state,
  ) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            icon: Icons.star,
            // modules/profile/profile_view.dart (tiếp tục)
            iconColor: context.colorTheme.warning,
            title: 'Kinh nghiệm',
            value: '${profile.experience}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsCard(
            icon: Icons.favorite,
            iconColor: context.colorTheme.heartColor,
            title: 'Tim',
            value: '${profile.hearts}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsCard(
            icon: Icons.local_fire_department,
            iconColor: context.colorTheme.streakFireColor,
            title: 'Streak',
            value: '${profile.streak}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsCard(
            icon: Icons.leaderboard,
            iconColor: Colors.purple,
            title: 'Hạng',
            value: state.userRank != null ? '${state.userRank!.rank}' : '-',
          ),
        ),
      ],
    );
  }

  Widget _buildLanguagesList(BuildContext context, List<UserLanguageProfile> languages) {
    if (languages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text('Chưa có ngôn ngữ nào được chọn'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: languages.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final language = languages[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colorTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: language.languageFlag != null && language.languageFlag!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      language.languageFlag!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          Icon(Icons.language, color: context.colorTheme.primary),
                    ),
                  )
                : Icon(Icons.language, color: context.colorTheme.primary),
          ),
          title: Text('Ngôn ngữ ${index + 1}'),
          subtitle: language.lessonOrder != null 
              ? Text('Bài học hiện tại: ${language.lessonOrder}')
              : null,
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Điều hướng đến trang chi tiết ngôn ngữ
          },
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
      builder: (context) => SafeArea(
        child: Column(
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
      
      if (image != null) {
        // Upload ảnh lên server và lấy URL
        // Đây là nơi bạn sẽ thêm code upload ảnh
        // Giả sử sau khi upload thành công, bạn nhận được URL
        final String imageUrl = await _uploadImage(File(image.path));
        
        context.read<ProfileBloc>().add(
          ChangeAvatarEvent(
            imageFile: File(image.path),
            imageUrl: imageUrl,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể chọn ảnh: ${e.toString()}'),
          backgroundColor: context.colorTheme.error,
        ),
      );
    }
  }

  // Giả lập việc upload ảnh
  Future<String> _uploadImage(File imageFile) async {
    // Trong thực tế, bạn sẽ upload ảnh lên server và nhận về URL
    // Đây chỉ là giả lập
    await Future.delayed(const Duration(seconds: 1));
    return "https://example.com/uploaded_avatar.jpg";
  }

  void _showEditProfileDialog(BuildContext context, UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        initialFullName: profile.fullName,
        initialEmail: profile.email,
        onSave: (fullName, email, password) {
          context.read<ProfileBloc>().add(
            UpdateProfileEvent(
              fullName: fullName.isNotEmpty ? fullName : null,
              email: email.isNotEmpty ? email : null,
              password: password.isNotEmpty ? password : null,
            ),
          );
        },
      ),
    );
  }
}

