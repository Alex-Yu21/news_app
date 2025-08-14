import 'package:dio/dio.dart';
import 'package:news_app/data/dto/article_dto.dart';
import 'package:news_app/domain/entities/article.dart';

class NewsApiRemote {
  final Dio _dio;
  NewsApiRemote(this._dio);

  Future<List<Article>> fetchHeadlines({
    required String country,
    int page = 1,
    int pageSize = 20,
    String? category,
    String? query,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/top-headlines',
      queryParameters: {
        'country': country,
        'page': page,
        'pageSize': pageSize,
        if (category != null && category.isNotEmpty) 'category': category,
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );

    final data = res.data ?? const {};
    final list = (data['articles'] as List? ?? const [])
        .cast<Map<String, dynamic>>();

    return list.map((j) => ArticleDto.fromJson(j).toDomain()).toList();
  }
}
