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

  Article a(String id, {DateTime? at}) => Article(
    title: 'T$id',
    description: 'D$id',
    publishedAt: at ?? DateTime.utc(2025, 1, 1),
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
            .having((s) => s.items.length, 'items', 2)
            .having((s) => s.categories.isEmpty, 'no categories', true),
      ],
      verify: (_) {
        verify(
          () => repo.getHeadlines(
            country: 'us',
            page: 1,
            category: null,
            query: any(named: 'query'),
          ),
        ).called(1);
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
      'should reload headlines when single category toggled on',
      build: () {
        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: null,
            query: any(named: 'query'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => [a('init')]);

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
        cubit.onToggleCategory(NewsCategory.business, true);
      },
      wait: const Duration(milliseconds: 40),
      expect: () => [
        isA<NewsListState>().having(
          (s) => s.status,
          'status',
          NewsListStatus.loading,
        ),
        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.success)
            .having((s) => s.items.length, 'items', 1)
            .having((s) => s.categories.isEmpty, 'no categories', true),
        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.loading)
            .having(
              (s) => s.categories.contains(NewsCategory.business),
              'has business',
              true,
            ),
        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.success)
            .having((s) => s.items.length, 'items', 2)
            .having((s) => s.categories.length, 'categories count', 1),
      ],
      verify: (_) {
        verify(
          () => repo.getHeadlines(
            country: 'us',
            category: null,
            page: 1,
            query: any(named: 'query'),
          ),
        ).called(1);

        verify(
          () => repo.getHeadlines(
            country: 'us',
            category: NewsCategory.business,
            page: 1,
            query: any(named: 'query'),
          ),
        ).called(1);
      },
    );

    blocTest<NewsListCubit, NewsListState>(
      'should merge results from two categories and deduplicate by url',
      build: () {
        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: null,
            query: any(named: 'query'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => [a('init')]);

        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: NewsCategory.business,
            query: any(named: 'query'),
            page: 1,
          ),
        ).thenAnswer((_) async => [a('b1'), a('dupe')]);

        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: NewsCategory.business,
            query: any(named: 'query'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => [a('b1'), a('dupe')]);
        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: NewsCategory.sports,
            query: any(named: 'query'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => [a('s1'), a('dupe'), a('s2')]);

        return NewsListCubit(repo);
      },
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        cubit.onToggleCategory(NewsCategory.business, true);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        cubit.onToggleCategory(NewsCategory.sports, true);
      },
      wait: const Duration(milliseconds: 80),
      expect: () => [
        isA<NewsListState>().having(
          (s) => s.status,
          'status',
          NewsListStatus.loading,
        ),
        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.success)
            .having((s) => s.items.length, 'items', 1)
            .having((s) => s.categories.isEmpty, 'no categories', true),

        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.loading)
            .having(
              (s) => s.categories,
              'cats',
              containsAll(<NewsCategory>{NewsCategory.business}),
            ),
        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.success)
            .having((s) => s.categories.length, 'categories count', 1)
            .having((s) => s.items.length, 'items', 2),

        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.loading)
            .having(
              (s) => s.categories,
              'cats',
              containsAll(<NewsCategory>{
                NewsCategory.business,
                NewsCategory.sports,
              }),
            ),
        isA<NewsListState>()
            .having((s) => s.status, 'status', NewsListStatus.success)
            .having((s) => s.categories.length, 'categories count', 2)
            .having((s) => s.items.length, 'merged unique count', 4)
            .having(
              (s) => s.items.map((e) => e.url).toSet().containsAll({
                'b1',
                's1',
                's2',
                'dupe',
              }),
              'contains all unique urls',
              true,
            ),
      ],
      verify: (_) {
        verify(
          () => repo.getHeadlines(
            country: 'us',
            category: null,
            page: 1,
            query: any(named: 'query'),
          ),
        ).called(1);

        verify(
          () => repo.getHeadlines(
            country: 'us',
            category: NewsCategory.business,
            page: 1,
            query: any(named: 'query'),
          ),
        ).called(2);

        verify(
          () => repo.getHeadlines(
            country: 'us',
            category: NewsCategory.sports,
            page: 1,
            query: any(named: 'query'),
          ),
        ).called(1);
      },
    );

    blocTest<NewsListCubit, NewsListState>(
      'should debounce search and call repository once for burst of inputs',
      build: () {
        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => [a('init')]);

        when(
          () => repo.getHeadlines(
            country: any(named: 'country'),
            category: any(named: 'category'),
            query: 'apple',
            page: 1,
          ),
        ).thenAnswer((_) async => [a('apple1'), a('apple2')]);

        return NewsListCubit(repo);
      },
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        cubit.onQueryChanged('a');
        cubit.onQueryChanged('ap');
        cubit.onQueryChanged('apple');
      },
      wait: const Duration(milliseconds: 650),
      verify: (_) {
        verify(
          () => repo.getHeadlines(
            country: 'us',
            category: any(named: 'category'),
            page: 1,
            query: any(named: 'query'),
          ),
        ).called(1);
        verify(
          () => repo.getHeadlines(
            country: 'us',
            category: any(named: 'category'),
            query: 'apple',
            page: 1,
          ),
        ).called(1);
      },
    );
  });
}
