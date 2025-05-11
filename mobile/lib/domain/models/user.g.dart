// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      avatar: json['avatar'] as String?,
      hearts: (json['hearts'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => Language.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'fullName': instance.fullName,
      if (instance.avatar case final value?) 'avatar': value,
      'hearts': instance.hearts,
      'experience': instance.experience,
      'streak': instance.streak,
      'languages': instance.languages,
    };
