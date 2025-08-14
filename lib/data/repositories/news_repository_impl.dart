import 'package:news_app/data/datasources/remote/news_api_remote.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/enums/news_category.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiRemote _remote;
  NewsRepositoryImpl(this._remote);

  @override
  Future<List<Article>> getHeadlines({
    required String country,
    NewsCategory? category,
    String? query,
    int page = 1,
  }) {
    return _remote.fetchHeadlines(
      country: country,
      category: category?.api,
      query: query,
      page: page,
      pageSize: 20,
    );
  }
}
