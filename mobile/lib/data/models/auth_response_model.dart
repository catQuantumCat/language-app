import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:language_app/data/models/language_model.dart';
import 'package:language_app/domain/models/user.dart';

part 'auth_response_model.g.dart';

@JsonSerializable(createToJson: false)
class AuthResponseModel {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String? avatar;
  final int hearts;
  final int experience;
  final int streak;
  final List<LanguageModel> languages;
  final String token;

  AuthResponseModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.fullName,
      required this.avatar,
      required this.hearts,
      required this.experience,
      required this.streak,
      required this.languages,
      required this.token});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  User toUser() {
    return User(
        id: id,
        username: username,
        email: email,
        fullName: fullName,
        avatar: avatar,
        hearts: hearts,
        experience: experience,
        streak: streak,
        languages: languages.map((lang) => lang.toLanguage()).toList());
  }
}
