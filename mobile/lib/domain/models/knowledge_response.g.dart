// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnowledgeResponse _$KnowledgeResponseFromJson(Map<String, dynamic> json) =>
    KnowledgeResponse(
      lessonId: json['lessonId'] as String,
      lessonTitle: json['lessonTitle'] as String,
      lessonOrder: json['lessonOrder'] as int,
      vocabulary: (json['vocabulary'] as List<dynamic>)
          .map((e) => Vocabulary.fromJson(e as Map<String, dynamic>))
          .toList(),
      grammar: (json['grammar'] as List<dynamic>)
          .map((e) => Grammar.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KnowledgeResponseToJson(KnowledgeResponse instance) =>
    <String, dynamic>{
      'lessonId': instance.lessonId,
      'lessonTitle': instance.lessonTitle,
      'lessonOrder': instance.lessonOrder,
      'vocabulary': instance.vocabulary,
      'grammar': instance.grammar,
    };

Vocabulary _$VocabularyFromJson(Map<String, dynamic> json) => Vocabulary(
      id: json['_id'] as String,
      englishWord: json['englishWord'] as String,
      vietnameseMeaning: json['vietnameseMeaning'] as String,
      pronunciation: json['pronunciation'] as String,
      audioUrl: json['audioUrl'] as String,
      examples: (json['examples'] as List<dynamic>)
          .map((e) => Example.fromJson(e as Map<String, dynamic>))
          .toList(),
      order: json['order'] as int,
    );

Map<String, dynamic> _$VocabularyToJson(Vocabulary instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'englishWord': instance.englishWord,
      'vietnameseMeaning': instance.vietnameseMeaning,
      'pronunciation': instance.pronunciation,
      'audioUrl': instance.audioUrl,
      'examples': instance.examples,
      'order': instance.order,
    };

Grammar _$GrammarFromJson(Map<String, dynamic> json) => Grammar(
      id: json['_id'] as String,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      examples: (json['examples'] as List<dynamic>)
          .map((e) => Example.fromJson(e as Map<String, dynamic>))
          .toList(),
      order: json['order'] as int,
    );

Map<String, dynamic> _$GrammarToJson(Grammar instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'explanation': instance.explanation,
      'examples': instance.examples,
      'order': instance.order,
    };

Example _$ExampleFromJson(Map<String, dynamic> json) => Example(
      id: json['_id'] as String,
      english: json['english'] as String,
      vietnamese: json['vietnamese'] as String,
    );

Map<String, dynamic> _$ExampleToJson(Example instance) => <String, dynamic>{
      '_id': instance.id,
      'english': instance.english,
      'vietnamese': instance.vietnamese,
    };
