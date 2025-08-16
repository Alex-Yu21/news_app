import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';
import 'package:news_app/presentation/cubit/favorites_cubit.dart';

class MockFavRepo extends Mock implements FavoritesRepository {}

Article a(String id) => Article(
  title: 'T$id',
  description: 'D$id',
  publishedAt: DateTime.utc(2025, 1, 1),
  url: 'https://example.com/$id',
  urlToImage: null,
  sourceName: 'S',
  content: 'C$id',
);

void main() {
  late MockFavRepo repo;

  setUpAll(() {
    registerFallbackValue(a('fallback'));
  });

  setUp(() {
    repo = MockFavRepo();
  });

  blocTest<FavoritesCubit, FavoritesState>(
    'should toggle favorite id in state',
    build: () {
      when(() => repo.getIds()).thenAnswer((_) async => <String>{});
      when(() => repo.getAll()).thenAnswer((_) async => <Article>[]);
      when(() => repo.save(any())).thenAnswer((_) async {});
      when(() => repo.remove(any())).thenAnswer((_) async {});
      return FavoritesCubit(repo);
    },
    act: (cubit) async {
      await cubit.load();
      when(() => repo.save(any())).thenAnswer((_) async {});
      when(
        () => repo.getIds(),
      ).thenAnswer((_) async => {'https://example.com/1'});
      when(() => repo.getAll()).thenAnswer((_) async => [a('1')]);
      await cubit.toggle(a('1'));
      when(() => repo.remove(any())).thenAnswer((_) async {});
      when(() => repo.getIds()).thenAnswer((_) async => <String>{});
      when(() => repo.getAll()).thenAnswer((_) async => <Article>[]);
      await cubit.toggle(a('1'));
    },
    verify: (_) {
      verify(() => repo.save(any())).called(1);
      verify(() => repo.remove(any())).called(1);
    },
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'should expose favorites items list',
    build: () {
      when(() => repo.getIds()).thenAnswer((_) async => {'u1', 'u2'});
      when(() => repo.getAll()).thenAnswer((_) async => [a('1'), a('2')]);
      return FavoritesCubit(repo);
    },
    act: (cubit) async {
      await cubit.load();
    },
    expect: () => [
      const FavoritesState(status: FavoritesStatus.loading),
      isA<FavoritesState>().having((s) => s.items.length, 'items', 2),
    ],
  );

  test('should toggle and then list contains saved article', () async {
    final localRepo = MockFavRepo();
    when(() => localRepo.getIds()).thenAnswer((_) async => <String>{});
    when(() => localRepo.getAll()).thenAnswer((_) async => <Article>[]);
    when(() => localRepo.exists(any())).thenAnswer((_) async => false);
    when(() => localRepo.save(any())).thenAnswer((_) async {});
    when(() => localRepo.remove(any())).thenAnswer((_) async {});

    final cubit = FavoritesCubit(localRepo);
    await cubit.load();

    final art = a('1');

    when(() => localRepo.getIds()).thenAnswer((_) async => {art.url});
    when(() => localRepo.getAll()).thenAnswer((_) async => [art]);
    await cubit.toggle(art);

    expect(cubit.state.ids.contains(art.url), true);
    expect(cubit.state.items.length, 1);
    expect(cubit.state.items.first.url, art.url);
  });
}
