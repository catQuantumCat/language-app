import 'package:json_annotation/json_annotation.dart';
import 'package:language_app/domain/models/language.dart';

part 'language_model.g.dart';

@JsonSerializable()
class LanguageModel {
  final String languageId;
  final String flagUrl;
  final int order;
  final int lessonOrder;

  LanguageModel(
      {required this.languageId,
      required this.flagUrl,
      required this.order,
      required this.lessonOrder});

  Map<String, dynamic> toJson() => _$LanguageModelToJson(this);

  factory LanguageModel.fromJson(Map<String, dynamic> map) =>
      _$LanguageModelFromJson(map);

  Language toLanguage() {
    return Language(
        flagUrl: flagUrl,
        languageId: languageId,
        level: order,
        experience: lessonOrder);
  }
}
