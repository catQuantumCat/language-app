// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable()
class Language {
  final String languageId;
  final String languageFlag;
  final int order;
  final int lessonOrder;

  const Language(
      {required this.languageId,
      required this.languageFlag,
      required this.order,
      required this.lessonOrder});

  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  factory Language.fromMap(Map<String, dynamic> map) => _$LanguageFromJson(map);
}
