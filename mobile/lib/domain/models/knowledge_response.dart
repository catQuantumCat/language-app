import 'package:json_annotation/json_annotation.dart';

part 'knowledge_response.g.dart';

@JsonSerializable()
class KnowledgeResponse {
  final String lessonId;
  final String lessonTitle;
  final int lessonOrder;
  final List<Vocabulary> vocabulary;
  final List<Grammar> grammar;

  KnowledgeResponse({
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonOrder,
    required this.vocabulary,
    required this.grammar,
  });

  factory KnowledgeResponse.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KnowledgeResponseToJson(this);
}

@JsonSerializable()
class Vocabulary {
  @JsonKey(name: '_id')
  final String id;
  final String englishWord;
  final String vietnameseMeaning;
  final String pronunciation;
  final String audioUrl;
  final List<Example> examples;
  final int order;

  Vocabulary({
    required this.id,
    required this.englishWord,
    required this.vietnameseMeaning,
    required this.pronunciation,
    required this.audioUrl,
    required this.examples,
    required this.order,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) =>
      _$VocabularyFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyToJson(this);
}

@JsonSerializable()
class Grammar {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String explanation;
  final List<Example> examples;
  final int order;

  Grammar({
    required this.id,
    required this.title,
    required this.explanation,
    required this.examples,
    required this.order,
  });

  factory Grammar.fromJson(Map<String, dynamic> json) =>
      _$GrammarFromJson(json);

  Map<String, dynamic> toJson() => _$GrammarToJson(this);
}

@JsonSerializable()
class Example {
  @JsonKey(name: '_id')
  final String id;
  final String english;
  final String vietnamese;

  Example({
    required this.id,
    required this.english,
    required this.vietnamese,
  });

  factory Example.fromJson(Map<String, dynamic> json) =>
      _$ExampleFromJson(json);

  Map<String, dynamic> toJson() => _$ExampleToJson(this);
}
