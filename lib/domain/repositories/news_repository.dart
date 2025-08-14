import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/enums/news_category.dart';

abstract class NewsRepository {
  Future<List<Article>> getHeadlines({
    required String country,
    NewsCategory? category,
    String? query,
    int page = 1,
  });
}
