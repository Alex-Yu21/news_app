import 'package:flutter/material.dart';

@immutable
class Article {
  final String title;
  final String? description;
  final DateTime publishedAt;
  final String url;
  final String? urlToImage;
  final String sourceName;
  final String? content;

  const Article({
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.url,
    required this.urlToImage,
    required this.sourceName,
    this.content,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'source': {'name': sourceName},
    'author': null,
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'publishedAt': publishedAt.toIso8601String(),
    'content': content,
  };

  factory Article.fromJson(Map<String, dynamic> json) {
    String? asString(dynamic v) => v is String ? v : null;
    String? nn(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();

    final srcMap = json['source'] as Map<String, dynamic>?;
    final src =
        nn(asString(json['sourceName'])) ??
        nn(asString(srcMap?['name'])) ??
        'Unknown';

    final publishedRaw = asString(json['publishedAt']);
    final published =
        DateTime.tryParse(publishedRaw ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

    final image = nn(asString(json['urlToImage']));

    return Article(
      title: json['title'] as String,
      description: nn(asString(json['description'])),
      publishedAt: published,
      url: json['url'] as String,
      urlToImage: image,
      sourceName: src,
      content: nn(asString(json['content'])),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article &&
        other.title == title &&
        other.description == description &&
        other.publishedAt == publishedAt &&
        other.url == url &&
        other.urlToImage == urlToImage &&
        other.sourceName == sourceName &&
        other.content == content;
  }

  @override
  int get hashCode => Object.hash(
    title,
    description,
    publishedAt,
    url,
    urlToImage,
    sourceName,
    content,
  );

  @override
  String toString() =>
      'Article(title: $title, source: $sourceName, date: $publishedAt)';
}
