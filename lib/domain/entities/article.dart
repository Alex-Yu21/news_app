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
