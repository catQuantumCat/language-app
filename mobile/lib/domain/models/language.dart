// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable()
class Language {
  final String languageId;
  final String languageFlag;
  final int order;
  final int lessonOrder;
  final int unitOrder;
  final String languageName;
  const Language(
      {required this.languageId,
      required this.languageFlag,
      required this.order,
      required this.lessonOrder,
      required this.unitOrder,
      required this.languageName});

  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  factory Language.fromJson(Map<String, dynamic> map) =>
      _$LanguageFromJson(map);

  @override
  String toString() {
    return 'Language(languageId: $languageId, languageFlag: $languageFlag, order: $order, lessonOrder: $lessonOrder, unitOrder: $unitOrder, languageName: $languageName)';
  }

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;

    return other.languageId == languageId;
  }

  @override
  int get hashCode {
    return languageId.hashCode ^
        languageFlag.hashCode ^
        order.hashCode ^
        lessonOrder.hashCode ^
        unitOrder.hashCode ^
        languageName.hashCode;
  }
}
