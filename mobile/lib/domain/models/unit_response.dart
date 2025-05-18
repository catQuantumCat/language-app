import 'package:json_annotation/json_annotation.dart';

part 'unit_response.g.dart';

@JsonSerializable()
class UnitResponse {
  final String languageId;
  final int order;
  final String title;
  final String id;

  UnitResponse({
    required this.languageId,
    required this.order,
    required this.title,
    required this.id,
  });

  factory UnitResponse.fromJson(Map<String, dynamic> json) =>
      _$UnitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnitResponseToJson(this);
}
