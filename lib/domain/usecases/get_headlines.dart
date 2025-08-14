import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/enums/news_category.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

class GetHeadlines {
  final NewsRepository _repo;
  const GetHeadlines(this._repo);

  Future<List<Article>> call({
    required String country,
    NewsCategory? category,
    String? query,
    int page = 1,
  }) {
    return _repo.getHeadlines(
      country: country,
      category: category,
      query: query,
      page: page,
    );
  }
}
