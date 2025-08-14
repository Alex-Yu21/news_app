import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/enums/news_category.dart';
import 'package:news_app/domain/repositories/news_repository.dart';
import 'package:news_app/presentation/cubit/news_list_cubit.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository repo;

  setUp(() {
    repo = MockNewsRepository();
  });

  Article a(String id) => Article(
    title: 'T$id',
    description: 'D$id',
    publishedAt: DateTime.utc(2025, 1, 1),
    url: id,
    urlToImage: null,
    sourceName: 'S',
  );

  group('NewsListCubit', () {
    blocTest<NewsListCubit, NewsListState>(
      'should load headlines on start and emit success',
      build: () {
        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => [a('1'), a('2')]);
        return NewsListCubit(repo);
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        isA<NewsListState>().having(
          (s) => s.status,
          'status',
          NewsListStatus.loading,
        ),
        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.success)
            .having((s) => s.items.length, 'items', 2),
      ],
      verify: (_) {
        verify(() => repo.getHeadlines(country: 'us', page: 1)).called(1);
      },
    );

    blocTest<NewsListCubit, NewsListState>(
      'should map repository error to error state',
      build: () {
        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
          ),
        ).thenThrow(Exception('boom'));
        return NewsListCubit(repo);
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        isA<NewsListState>().having(
          (s) => s.status,
          'status',
          NewsListStatus.loading,
        ),
        isA<NewsListState>().having(
          (s) => s.status,
          'status',
          NewsListStatus.error,
        ),
      ],
    );
    blocTest<NewsListCubit, NewsListState>(
      'should reload headlines when category changes',
      build: () {
        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: null,
            query: any(named: 'query'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => [a('1')]);

        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: NewsCategory.business,
            query: any(named: 'query'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => [a('b1'), a('b2')]);

        return NewsListCubit(repo);
      },
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        cubit.onCategorySelected(NewsCategory.business);
      },
      wait: const Duration(milliseconds: 30),
      expect: () => [
        isA<NewsListState>().having(
          (s) => s.status,
          'status',
          NewsListStatus.loading,
        ),
        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.success)
            .having((s) => s.items.length, 'items', 1)
            .having((s) => s.category, 'category', null),

        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.loading)
            .having((s) => s.page, 'page', 1)
            .having((s) => s.category, 'category', NewsCategory.business),
        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.success)
            .having((s) => s.items.length, 'items', 2)
            .having((s) => s.items.first.url, 'first url', 'b1')
            .having((s) => s.category, 'category', NewsCategory.business),
      ],
      verify: (_) {
        verify(
          () => repo.getHeadlines(country: 'us', category: null, page: 1),
        ).called(1);
        verify(
          () => repo.getHeadlines(
            country: 'us',
            category: NewsCategory.business,
            page: 1,
          ),
        ).called(1);
      },
    );
  });
}
