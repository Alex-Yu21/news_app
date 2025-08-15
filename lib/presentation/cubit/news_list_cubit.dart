import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/app/config/app_env.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/enums/news_category.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

enum NewsListStatus { idle, loading, success, empty, error }

const _keep = Object();

class NewsListState extends Equatable {
  final NewsListStatus status;
  final List<Article> items;
  final int page;
  final bool hasMore;
  final String country;
  final NewsCategory? category;
  final String? query;
  final String? error;

  const NewsListState({
    this.status = NewsListStatus.idle,
    this.items = const [],
    this.page = 1,
    this.hasMore = true,
    this.country = defaultCountry,
    this.category,
    this.query,
    this.error,
  });

  NewsListState copyWith({
    NewsListStatus? status,
    List<Article>? items,
    int? page,
    bool? hasMore,
    String? country,
    Object? category = _keep,
    Object? query = _keep,
    Object? error = _keep,
  }) {
    return NewsListState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      country: country ?? this.country,
      category: identical(category, _keep)
          ? this.category
          : category as NewsCategory?,
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
    category,
    query,
    error,
  ];
}

class NewsListCubit extends Cubit<NewsListState> {
  final NewsRepository _repo;
  Timer? _debounce;
  bool _isFetching = false;

  NewsListCubit(this._repo) : super(const NewsListState()) {
    scheduleMicrotask(_loadInitial);
  }

  Future<void> _loadInitial() => load(reset: true, page: 1);

  Future<void> load({
    bool reset = false,
    int? page,
    Object? category = _keep,
    Object? query = _keep,
    String? country,
  }) async {
    if (_isFetching) return;
    _isFetching = true;

    final nextCategory = identical(category, _keep)
        ? state.category
        : category as NewsCategory?;
    final nextQuery = identical(query, _keep) ? state.query : query as String?;
    final nextCountry = country ?? state.country;
    final nextPage = page ?? state.page;

    if (reset) {
      emit(
        state.copyWith(
          status: NewsListStatus.loading,
          page: 1,
          items: const [],
          hasMore: true,
          country: nextCountry,
          category: nextCategory,
          query: nextQuery,
          error: null,
        ),
      );
    }

    try {
      final data = await _repo.getHeadlines(
        country: nextCountry,
        category: nextCategory,
        query: nextQuery,
        page: nextPage,
      );

      final items = reset ? data : [...state.items, ...data];
      final hasMore = data.isNotEmpty;
      emit(
        state.copyWith(
          status: items.isEmpty ? NewsListStatus.empty : NewsListStatus.success,
          items: items,
          page: nextPage,
          hasMore: hasMore,
          country: nextCountry,
          category: nextCategory,
          query: nextQuery,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NewsListStatus.error, error: '$e'));
    } finally {
      _isFetching = false;
    }
  }

  void onCategorySelected(NewsCategory? cat) {
    final next = (state.category == cat) ? null : cat;
    load(reset: true, page: 1, category: next);
  }

  void onQueryChanged(String q) {
    final val = q.trim().isEmpty ? null : q.trim();

    if (state.query == val) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      load(reset: true, page: 1, query: val);
    });
  }

  Future<void> fetchMore() async {
    if (!state.hasMore || _isFetching) return;
    await load(reset: false, page: state.page + 1);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
