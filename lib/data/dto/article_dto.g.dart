// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleDto _$ArticleDtoFromJson(Map<String, dynamic> json) => ArticleDto(
  title: json['title'] as String,
  description: json['description'] as String?,
  urlToImage: json['urlToImage'] as String?,
  url: json['url'] as String,
  publishedAt: json['publishedAt'] as String,
  source: json['source'] == null
      ? null
      : SourceDto.fromJson(json['source'] as Map<String, dynamic>),
  content: json['content'] as String?,
);

Map<String, dynamic> _$ArticleDtoToJson(ArticleDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'urlToImage': instance.urlToImage,
      'url': instance.url,
      'publishedAt': instance.publishedAt,
      'source': instance.source,
      'content': instance.content,
    };

SourceDto _$SourceDtoFromJson(Map<String, dynamic> json) =>
    SourceDto(name: json['name'] as String);

Map<String, dynamic> _$SourceDtoToJson(SourceDto instance) => <String, dynamic>{
  'name': instance.name,
};
