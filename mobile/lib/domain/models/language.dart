// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable()
class Language {
  final String languageId;
  final String flagUrl;
  final int level;
  final int experience;

  const Language(
      {required this.languageId,
      required this.flagUrl,
      required this.level,
      required this.experience});

  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  factory Language.fromJson(Map<String, dynamic> map) => _$LanguageFromJson(map);
}
