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

  const ArticleDto({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    required this.publishedAt,
    required this.source,
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
    description: description,
    publishedAt: DateTime.parse(publishedAt),
    url: url,
    urlToImage: urlToImage,
    sourceName: source.name,
  );
}
