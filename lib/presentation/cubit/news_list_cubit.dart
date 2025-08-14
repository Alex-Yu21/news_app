import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/enums/news_category.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

enum NewsListStatus { idle, loading, success, empty, error }

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
    this.country = 'us',
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
    NewsCategory? category,
    String? query,
    String? error,
  }) {
    return NewsListState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      country: country ?? this.country,
      category: category ?? this.category,
      query: query ?? this.query,
      error: error,
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
  static const _pageSize = 20;
  final NewsRepository _repo;
  Timer? _debounce;
  bool _isFetching = false;

  NewsListCubit(this._repo) : super(const NewsListState()) {
    scheduleMicrotask(_loadInitial);
  }

  Future<void> _loadInitial() => load(reset: true, page: 1);

  Future<void> load({bool reset = false, int? page}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (reset) emit(state.copyWith(status: NewsListStatus.loading, page: 1));

    final nextPage = page ?? state.page;
    try {
      final data = await _repo.getHeadlines(
        country: state.country,
        category: state.category,
        query: state.query,
        page: nextPage,
      );

      final items = reset ? data : [...state.items, ...data];
      final hasMore = data.length == _pageSize;

      if (items.isEmpty) {
        emit(
          state.copyWith(
            status: NewsListStatus.empty,
            items: items,
            page: nextPage,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: NewsListStatus.success,
            items: items,
            page: nextPage,
            hasMore: hasMore,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: NewsListStatus.error, error: '$e'));
    } finally {
      _isFetching = false;
    }
  }

  void onCategorySelected(NewsCategory? cat) {
    emit(state.copyWith(category: cat));
    load(reset: true, page: 1);
  }

  void onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      emit(state.copyWith(query: q));
      load(reset: true, page: 1);
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
