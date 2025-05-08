// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      avatar: json['avatar'] as String?,
      hearts: (json['hearts'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      token: json['token'] as String,
    );
