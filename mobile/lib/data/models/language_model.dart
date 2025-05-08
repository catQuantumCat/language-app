import 'package:json_annotation/json_annotation.dart';
import 'package:language_app/domain/models/language.dart';

part 'language_model.g.dart';

@JsonSerializable()
class LanguageModel {
  final String languageId;
  final int level;
  final int experience;

  LanguageModel(
      {required this.languageId,
      required this.level,
      required this.experience});

  Map<String, dynamic> toJson() => _$LanguageModelToJson(this);

  factory LanguageModel.fromJson(Map<String, dynamic> map) =>
      _$LanguageModelFromJson(map);

  Language toLanguage() {
    return Language(
        languageId: languageId, level: level, experience: experience);
  }
}
