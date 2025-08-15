// lib/data/dto/article_dto.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:news_app/domain/entities/article.dart';

part 'article_dto.g.dart';

@JsonSerializable()
class ArticleDto {
  final String title;
  final String? description;
  @JsonKey(name: 'urlToImage')
  final String? urlToImage;
  final String url;
  final String publishedAt;
  final SourceDto source;
  final String? content;

  const ArticleDto({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    required this.publishedAt,
    required this.source,
    this.content,
  });

  factory ArticleDto.fromJson(Map<String, dynamic> json) =>
      _$ArticleDtoFromJson(json);
}

@JsonSerializable()
class SourceDto {
  final String name;
  const SourceDto({required this.name});

  factory SourceDto.fromJson(Map<String, dynamic> json) =>
      _$SourceDtoFromJson(json);
}

extension ArticleDtoX on ArticleDto {
  Article toDomain() => Article(
    title: title,
    description: _cleanup(description),
    publishedAt: DateTime.parse(publishedAt),
    url: url,
    urlToImage: urlToImage,
    sourceName: source.name,
    content: _cleanup(content),
  );
}

String? _cleanup(String? raw) {
  if (raw == null) return null;
  var s = raw;
  s = s.replaceAll(RegExp(r'<[^>]+>', caseSensitive: false), '');
  s = s.replaceAll(RegExp(r'\[[^\]]*\]'), '');
  s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
  return s.isEmpty ? null : s;
}
