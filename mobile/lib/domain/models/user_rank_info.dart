// domain/models/user_rank_info.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_rank_info.g.dart';

@JsonSerializable()
class UserRankDetail {
  final String userId;
  final String username;
  final String fullName;
  final String? avatar;
  final int experience;
  final String? languageFlag;
  final int rank;

  UserRankDetail({
    required this.userId,
    required this.username,
    required this.fullName,
    this.avatar,
    required this.experience,
    this.languageFlag,
    required this.rank,
  });

  factory UserRankDetail.fromJson(Map<String, dynamic> json) =>
      _$UserRankDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UserRankDetailToJson(this);
}

@JsonSerializable()
class UserRankInfo {
  final UserRankDetail currentUser;
  final List<UserRankDetail> aboveUsers;
  final List<UserRankDetail> belowUsers;

  UserRankInfo({
    required this.currentUser,
    required this.aboveUsers,
    required this.belowUsers,
  });

  factory UserRankInfo.fromJson(Map<String, dynamic> json) =>
      _$UserRankInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserRankInfoToJson(this);
}
