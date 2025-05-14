// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rank_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRankDetail _$UserRankDetailFromJson(Map<String, dynamic> json) =>
    UserRankDetail(
      userId: json['userId'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      avatar: json['avatar'] as String?,
      experience: (json['experience'] as num).toInt(),
      languageFlag: json['languageFlag'] as String?,
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$UserRankDetailToJson(UserRankDetail instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'fullName': instance.fullName,
      'avatar': instance.avatar,
      'experience': instance.experience,
      'languageFlag': instance.languageFlag,
      'rank': instance.rank,
    };

UserRankInfo _$UserRankInfoFromJson(Map<String, dynamic> json) => UserRankInfo(
      currentUser:
          UserRankDetail.fromJson(json['currentUser'] as Map<String, dynamic>),
      aboveUsers: (json['aboveUsers'] as List<dynamic>)
          .map((e) => UserRankDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      belowUsers: (json['belowUsers'] as List<dynamic>)
          .map((e) => UserRankDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserRankInfoToJson(UserRankInfo instance) =>
    <String, dynamic>{
      'currentUser': instance.currentUser,
      'aboveUsers': instance.aboveUsers,
      'belowUsers': instance.belowUsers,
    };
