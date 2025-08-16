import 'package:json_annotation/json_annotation.dart';
import 'package:news_app/domain/entities/article.dart';

part 'article_dto.g.dart';

String? _cleanup(String? raw) {
  if (raw == null) return null;
  var s = raw;
  s = s.replaceAll(RegExp(r'<[^>]+>', caseSensitive: false), '');
  s = s.replaceAll(RegExp(r'\[[^\]]*\]'), '');
  s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
  return s.isEmpty ? null : s;
}

String? _normalizeUrl(String? raw) {
  if (raw == null) return null;
  final s = raw.trim();
  return s.isEmpty ? null : s;
}

String _sourceNameOrUnknown(String? raw) {
  final n = _cleanup(raw);
  return (n == null || n.isEmpty) ? 'Unknown' : n;
}

@JsonSerializable()
class ArticleDto {
  final String title;
  final String? description;
  final String? urlToImage;
  final String url;
  final String publishedAt;
  final SourceDto? source;
  final String? content;

  const ArticleDto({
    required this.title,
    this.description,
    this.urlToImage,
    required this.url,
    required this.publishedAt,
    this.source,
    this.content,
  });

  factory ArticleDto.fromJson(Map<String, dynamic> json) =>
      _$ArticleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDtoToJson(this);

  Article toDomain() {
    final dt =
        DateTime.tryParse(publishedAt) ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

    final t = _cleanup(title) ?? title;
    final d = _cleanup(description);
    final c = _cleanup(content);
    final image = _normalizeUrl(urlToImage);

    return Article(
      title: t,
      description: d,
      content: c,
      urlToImage: image,
      url: url,
      publishedAt: dt,
      sourceName: _sourceNameOrUnknown(source?.name),
    );
  }
}

@JsonSerializable()
class SourceDto {
  final String name;

  const SourceDto({required this.name});

  factory SourceDto.fromJson(Map<String, dynamic> json) =>
      _$SourceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SourceDtoToJson(this);
}
