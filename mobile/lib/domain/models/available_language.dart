import 'package:json_annotation/json_annotation.dart';

part 'available_language.g.dart';

/*
"description": "",
        "name": "English",
        "flagUrl": "English",
        "isActive": true,
        "code": "EN",
"id": "68022c102f05fe8c6a1166e4"
*/

@JsonSerializable()
class AvailableLanguage {
  final String id;
  final String name;
  final String code;
  final String? flagUrl;

  final String description;

  AvailableLanguage(
      {required this.id,
      required this.name,
      required this.code,
      this.flagUrl,
      required this.description});

  factory AvailableLanguage.fromJson(Map<String, dynamic> json) =>
      _$AvailableLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableLanguageToJson(this);
}
