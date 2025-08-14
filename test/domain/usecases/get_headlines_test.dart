import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/enums/news_category.dart';
import 'package:news_app/domain/repositories/news_repository.dart';
import 'package:news_app/domain/usecases/get_headlines.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository repo;
  late GetHeadlines usecase;

  setUp(() {
    repo = MockNewsRepository();
    usecase = GetHeadlines(repo);
  });

  test('calls repository with correct params and returns articles', () async {
    final sample = Article(
      title: 'Hello',
      description: 'Short',
      publishedAt: DateTime.utc(2025, 1, 1),
      url: 'u1',
      urlToImage: null,
      sourceName: 'S',
    );

    when(
      () => repo.getHeadlines(
        country: any(named: 'country'),
        category: any<NewsCategory?>(named: 'category'),
        query: any<String?>(named: 'query'),
        page: any(named: 'page'),
      ),
    ).thenAnswer((_) async => [sample]);

    final result = await usecase(
      country: 'us',
      category: NewsCategory.business,
      query: 'apple',
      page: 2,
    );

    expect(result, [sample]);
    verify(
      () => repo.getHeadlines(
        country: 'us',
        category: NewsCategory.business,
        query: 'apple',
        page: 2,
      ),
    ).called(1);
  });

  test('uses page=1 by default', () async {
    when(
      () => repo.getHeadlines(
        country: any(named: 'country'),
        category: any<NewsCategory?>(named: 'category'),
        query: any<String?>(named: 'query'),
        page: any(named: 'page'),
      ),
    ).thenAnswer((_) async => const []);

    await usecase(country: 'de');

    verify(
      () => repo.getHeadlines(
        country: 'de',
        category: null,
        query: null,
        page: 1,
      ),
    ).called(1);
  });
}
