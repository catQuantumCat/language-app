// domain/dtos/update_profile_dto.dart
import 'dart:io';

class UpdateProfileDto {
  final String? fullName;
  final String? email;
  final String? password;
  final String? avatar;
  final File? avatarFile;
  final List<Map<String, dynamic>>? languages;
  final String? lastSelectedLanguage;

  UpdateProfileDto({
    this.fullName,
    this.email,
    this.password,
    this.avatar,
    this.avatarFile,
    this.languages,
    this.lastSelectedLanguage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (avatar != null) data['avatar'] = avatar;
    if (languages != null) data['languages'] = languages;
    if (lastSelectedLanguage != null)
      data['lastSelectedLanguage'] = lastSelectedLanguage;

    return data;
  }
}
