import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/data/datasources/local/favorites_local.dart';
import 'package:news_app/data/repositories/favorites_repository_impl.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('should save and remove favorite article', () async {
    final prefs = await SharedPreferences.getInstance();
    final FavoritesRepository repo = FavoritesRepositoryImpl(
      FavoritesLocal(prefs),
    );

    final art = a('1');

    await repo.save(art);
    expect(await repo.exists(art.url), true);
    expect(await repo.getIds(), {art.url});
    expect((await repo.getAll()).length, 1);

    await repo.remove(art.url);
    expect(await repo.exists(art.url), false);
    expect(await repo.getIds(), <String>{});
    expect((await repo.getAll()).length, 0);
  });

  test('should restore favorites list from storage', () async {
    final prefs = await SharedPreferences.getInstance();

    final repo1 = FavoritesRepositoryImpl(FavoritesLocal(prefs));
    await repo1.save(a('1'));
    await repo1.save(a('2'));

    final repo2 = FavoritesRepositoryImpl(FavoritesLocal(prefs));
    final items = await repo2.getAll();

    expect(items.length, 2);
    expect((await repo2.getIds()).length, 2);
  });
}
