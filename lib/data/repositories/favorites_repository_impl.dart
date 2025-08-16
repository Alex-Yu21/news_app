import 'dart:convert';

import 'package:news_app/data/datasources/local/favorites_local.dart';
import 'package:news_app/data/dto/article_dto.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocal local;
  FavoritesRepositoryImpl(this.local);

  Map<String, dynamic> _toJson(Article a) {
    return {
      'source': {'name': a.sourceName},
      'author': null,
      'title': a.title,
      'description': a.description,
      'url': a.url,
      'urlToImage': a.urlToImage,
      'publishedAt': a.publishedAt.toIso8601String(),
      'content': a.content,
    };
  }

  @override
  Future<void> save(Article article) async {
    final jsonMap = _toJson(article);
    await local.put(article.url, jsonEncode(jsonMap));
  }

  @override
  Future<void> remove(String url) => local.delete(url);

  @override
  Future<List<Article>> getAll() async {
    final raw = await local.allJson();
    final items = <Article>[];
    for (final s in raw) {
      final decoded = jsonDecode(s);
      if (decoded is Map<String, dynamic>) {
        items.add(ArticleDto.fromJson(decoded).toDomain());
      }
    }
    return List.unmodifiable(items);
  }

  @override
  Future<Set<String>> getIds() => local.ids();

  @override
  Future<bool> exists(String url) => local.exists(url);
}
