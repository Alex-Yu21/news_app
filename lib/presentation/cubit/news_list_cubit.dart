import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/app/config/app_env.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/enums/news_category.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

enum NewsListStatus { idle, loading, success, empty, error }

const int kInitialPage = 1;
const bool kInitialHasMore = true;
const Duration kDefaultDebounce = Duration(milliseconds: 500);

const _keep = Object();

class NewsListState extends Equatable {
  final NewsListStatus status;
  final List<Article> items;
  final int page;
  final bool hasMore;
  final String country;
  final Set<NewsCategory> categories;
  final Map<NewsCategory, int> categoryPages;
  final String? query;
  final String? error;

  const NewsListState({
    this.status = NewsListStatus.idle,
    this.items = const [],
    this.page = kInitialPage,
    this.hasMore = kInitialHasMore,
    this.country = defaultCountry,
    this.categories = const {},
    this.categoryPages = const {},
    this.query,
    this.error,
  });

  NewsListState copyWith({
    NewsListStatus? status,
    List<Article>? items,
    int? page,
    bool? hasMore,
    String? country,
    Object? categories = _keep,
    Map<NewsCategory, int>? categoryPages,
    Object? query = _keep,
    Object? error = _keep,
  }) {
    return NewsListState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      country: country ?? this.country,
      categories: identical(categories, _keep)
          ? this.categories
          : (categories as Set<NewsCategory>),
      categoryPages: categoryPages ?? this.categoryPages,
      query: identical(query, _keep) ? this.query : query as String?,
      error: identical(error, _keep) ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    page,
    hasMore,
    country,
    categories,
    categoryPages,
    query,
    error,
  ];
}

class NewsListCubit extends Cubit<NewsListState> {
  final NewsRepository _repo;
  final bool fetchOnStart;
  final Duration debounceDuration;

  Timer? _debounce;
  bool _isFetching = false;

  NewsListCubit(
    this._repo, {
    this.fetchOnStart = true,
    this.debounceDuration = kDefaultDebounce,
  }) : super(const NewsListState()) {
    if (fetchOnStart) {
      scheduleMicrotask(_loadInitial);
    }
  }

  Future<void> _loadInitial() => load(reset: true, page: kInitialPage);

  Future<void> load({
    bool reset = false,
    int? page,
    Object? categories = _keep,
    Object? query = _keep,
    String? country,
  }) async {
    if (_isFetching) return;
    _isFetching = true;

    final nextCategories = identical(categories, _keep)
        ? state.categories
        : categories as Set<NewsCategory>;
    final nextQuery = identical(query, _keep) ? state.query : query as String?;
    final nextCountry = country ?? state.country;
    final nextPage = page ?? state.page;
    final isMulti = nextCategories.length > 1;

    Map<NewsCategory, int> nextCategoryPages = state.categoryPages;
    if (reset) {
      nextCategoryPages = isMulti
          ? {for (final c in nextCategories) c: kInitialPage}
          : const {};
      emit(
        state.copyWith(
          status: NewsListStatus.loading,
          page: kInitialPage,
          items: const <Article>[],
          hasMore: kInitialHasMore,
          country: nextCountry,
          categories: nextCategories,
          categoryPages: nextCategoryPages,
          query: nextQuery,
          error: null,
        ),
      );
    }

    try {
      if (!isMulti) {
        final NewsCategory? singleCategory = nextCategories.isEmpty
            ? null
            : nextCategories.first;
        final data = await _repo.getHeadlines(
          country: nextCountry,
          category: singleCategory,
          query: nextQuery,
          page: nextPage,
        );
        final base = reset ? const <Article>[] : state.items;
        final items = _mergeAppend(base, data);
        emit(
          state.copyWith(
            status: items.isEmpty
                ? NewsListStatus.empty
                : NewsListStatus.success,
            items: items,
            page: nextPage,
            hasMore: data.isNotEmpty,
            country: nextCountry,
            categories: nextCategories,
            categoryPages: const {},
            query: nextQuery,
            error: null,
          ),
        );
      } else {
        final pages = state.categoryPages.isEmpty
            ? {for (final c in nextCategories) c: kInitialPage}
            : Map<NewsCategory, int>.from(state.categoryPages);

        final order = nextCategories.toList();
        final futures = order
            .map(
              (c) => _repo.getHeadlines(
                country: nextCountry,
                category: c,
                query: nextQuery,
                page: pages[c] ?? kInitialPage,
              ),
            )
            .toList();

        final results = await Future.wait(futures);
        final batch = <Article>[];
        final updatedPages = <NewsCategory, int>{};

        for (var i = 0; i < order.length; i++) {
          final cat = order[i];
          final data = results[i];
          batch.addAll(data);
          if (data.isNotEmpty) {
            updatedPages[cat] = (pages[cat] ?? kInitialPage) + 1;
          }
        }

        final base = reset ? const <Article>[] : state.items;
        final items = _mergeAppend(base, batch);

        emit(
          state.copyWith(
            status: items.isEmpty
                ? NewsListStatus.empty
                : NewsListStatus.success,
            items: items,
            hasMore: updatedPages.isNotEmpty,
            country: nextCountry,
            categories: nextCategories,
            categoryPages: updatedPages,
            query: nextQuery,
            error: null,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: NewsListStatus.error, error: '$e'));
    } finally {
      _isFetching = false;
    }
  }

  void onToggleCategory(NewsCategory cat, bool selected) {
    final next = Set<NewsCategory>.from(state.categories);
    if (selected) {
      next.add(cat);
    } else {
      next.remove(cat);
    }
    load(reset: true, page: kInitialPage, categories: next);
  }

  void onQueryChanged(String q) {
    final val = q.trim().isEmpty ? null : q.trim();
    if (state.query == val) return;
    _debounce?.cancel();
    _debounce = Timer(debounceDuration, () {
      load(reset: true, page: kInitialPage, query: val);
    });
  }

  Future<void> fetchMore() async {
    if (!state.hasMore || _isFetching) return;
    if (state.categories.length <= 1) {
      await load(reset: false, page: state.page + 1);
    } else {
      await load(reset: false);
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  List<Article> _mergeAppend(List<Article> base, List<Article> incoming) {
    final map = <String, Article>{};
    for (final a in base) {
      map[a.url] = a;
    }
    for (final a in incoming) {
      map[a.url] = a;
    }
    final list = map.values.toList();
    list.sort((x, y) => y.publishedAt.compareTo(x.publishedAt));
    return list;
  }
}
