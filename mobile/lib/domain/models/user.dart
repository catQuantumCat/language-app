import 'package:json_annotation/json_annotation.dart';
import 'package:language_app/domain/models/language.dart';

part 'user.g.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
@JsonSerializable()
class User {
  final String id;
  final String username;
  final String email;
  final String fullName;
  @JsonKey(includeIfNull: false)
  final String? avatar;
  final int hearts;
  final int experience;
  final int streak;
  final List<Language> languages;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.fullName,
      required this.avatar,
      required this.hearts,
      required this.experience,
      required this.streak,
      required this.languages});

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? avatar,
    int? hearts,
    int? experience,
    int? streak,
    List<Language>? languages,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      hearts: hearts ?? this.hearts,
      experience: experience ?? this.experience,
      streak: streak ?? this.streak,
      languages: languages ?? this.languages,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, fullName: $fullName, avatar: $avatar, hearts: $hearts, experience: $experience, streak: $streak, languages: $languages)';
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

/*
{
    "id": "680fa40cbaa2f0cd89aaac8b",
    "username": "huy",
    "email": "huy123@gmail.com",
    "fullName": "Trần Hoàng Phúc Huy",
    "avatar": null,
    "hearts": 5,
    "experience": 0,
    "streak": 0,
    "languages": []
}
*/
