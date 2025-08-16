import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';

enum FavoritesStatus { idle, loading, ready, error }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final Set<String> ids;
  final List<Article> items;
  final String? error;

  const FavoritesState({
    this.status = FavoritesStatus.idle,
    this.ids = const {},
    this.items = const [],
    this.error,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    Set<String>? ids,
    List<Article>? items,
    String? error,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      ids: ids ?? this.ids,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, ids, items, error];
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repo;
  FavoritesCubit(this.repo) : super(const FavoritesState());

  Future<void> load() async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    await _reload();
  }

  bool isFavorite(String url) => state.ids.contains(url);

  Future<void> toggle(Article a) async {
    final wasFav = state.ids.contains(a.url);
    final optimistic = Set<String>.from(state.ids);
    if (wasFav) {
      optimistic.remove(a.url);
    } else {
      optimistic.add(a.url);
    }
    emit(state.copyWith(ids: optimistic));

    try {
      if (wasFav) {
        await repo.remove(a.url);
      } else {
        await repo.save(a);
      }
      await _reload();
    } catch (e) {
      emit(state.copyWith(status: FavoritesStatus.error, error: '$e'));
    }
  }

  Future<void> _reload() async {
    final ids = await repo.getIds();
    final items = await repo.getAll();
    emit(FavoritesState(status: FavoritesStatus.ready, ids: ids, items: items));
  }
}
