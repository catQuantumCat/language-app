// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:language_app/domain/models/language.dart';

part 'language_model.g.dart';

@JsonSerializable()
class LanguageModel {
  final String languageId;
  final String languageFlag;
  final int order;
  final int lessonOrder;
  final int unitOrder;
  final String languageName;

  LanguageModel(
      {required this.languageId,
      required this.languageFlag,
      required this.order,
      required this.lessonOrder,
      required this.unitOrder,
      required this.languageName});

  Map<String, dynamic> toJson() => _$LanguageModelToJson(this);

  factory LanguageModel.fromJson(Map<String, dynamic> map) =>
      _$LanguageModelFromJson(map);

  Language toLanguage() {
    return Language(
      languageId: languageId,
      languageFlag: languageFlag,
      order: order,
      lessonOrder: lessonOrder,
      unitOrder: unitOrder,
      languageName: languageName,
    );
  }

  @override
  String toString() {
    return 'LanguageModel(languageId: $languageId, languageFlag: $languageFlag, order: $order, lessonOrder: $lessonOrder, unitOrder: $unitOrder, languageName: $languageName)';
  }
}
