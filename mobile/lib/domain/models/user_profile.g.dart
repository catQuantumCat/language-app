// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLanguageProfile _$UserLanguageProfileFromJson(Map<String, dynamic> json) =>
    UserLanguageProfile(
      languageId: json['languageId'] as String,
      languageFlag: json['languageFlag'] as String?,
      lessonOrder: (json['lessonOrder'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserLanguageProfileToJson(
        UserLanguageProfile instance) =>
    <String, dynamic>{
      'languageId': instance.languageId,
      'languageFlag': instance.languageFlag,
      'lessonOrder': instance.lessonOrder,
      'order': instance.order,
    };

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      avatar: json['avatar'] as String?,
      hearts: (json['hearts'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => UserLanguageProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'fullName': instance.fullName,
      'avatar': instance.avatar,
      'hearts': instance.hearts,
      'experience': instance.experience,
      'streak': instance.streak,
      'languages': instance.languages,
    };
