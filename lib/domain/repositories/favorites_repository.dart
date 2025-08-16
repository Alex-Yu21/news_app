import 'package:news_app/domain/entities/article.dart';

abstract class FavoritesRepository {
  Future<void> save(Article article);
  Future<void> remove(String url);
  Future<List<Article>> getAll();
  Future<Set<String>> getIds();
  Future<bool> exists(String url);
}
