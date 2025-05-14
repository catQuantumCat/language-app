// domain/models/user_profile.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:language_app/domain/models/language.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserLanguageProfile {
  final String languageId;
  final String? languageFlag;
  final int? lessonOrder;
  final int? order;

  UserLanguageProfile({
    required this.languageId,
    this.languageFlag,
    this.lessonOrder,
    this.order,
  });

  factory UserLanguageProfile.fromJson(Map<String, dynamic> json) =>
      _$UserLanguageProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserLanguageProfileToJson(this);
}

@JsonSerializable()
class UserProfile {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String? avatar;
  final int hearts;
  final int experience;
  final int streak;
  final List<UserLanguageProfile> languages;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.avatar,
    required this.hearts,
    required this.experience,
    required this.streak,
    required this.languages,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
