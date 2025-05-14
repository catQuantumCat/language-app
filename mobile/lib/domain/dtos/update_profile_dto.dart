// domain/dtos/update_profile_dto.dart
class UpdateProfileDto {
  final String? fullName;
  final String? email;
  final String? password;
  final String? avatar;

  UpdateProfileDto({
    this.fullName,
    this.email,
    this.password,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (avatar != null) data['avatar'] = avatar;
    
    return data;
  }
}
