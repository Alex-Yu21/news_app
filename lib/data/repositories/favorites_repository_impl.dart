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
      'title': a.title,
      'description': a.description,
      'publishedAt': a.publishedAt.toIso8601String(),
      'url': a.url,
      'urlToImage': a.urlToImage,
      'sourceName': a.sourceName,
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
    final list = await local.allJson();
    return list
        .map(
          (s) => ArticleDto.fromJson(
            jsonDecode(s) as Map<String, dynamic>,
          ).toDomain(),
        )
        .toList(growable: false);
  }

  @override
  Future<Set<String>> getIds() => local.ids();

  @override
  Future<bool> exists(String url) => local.exists(url);
}
