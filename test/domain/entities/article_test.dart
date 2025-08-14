import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/app/domain/entities/article.dart';

void main() {
  group('Article', () {
    test('should hold basic fields', () {
      final a = Article(
        title: 'AppMint',
        description: 'Test',
        publishedAt: DateTime.utc(2025, 8, 10, 12, 0, 0),
        url: 'https://example.com/appmint',
        urlToImage: 'https://example.com/img.png',
        sourceName: 'Example',
      );

      expect(a.title, 'AppMint');
      expect(a.description, 'Test');
      expect(a.publishedAt, DateTime.utc(2025, 8, 10, 12, 0, 0));
      expect(a.url, 'https://example.com/appmint');
      expect(a.urlToImage, 'https://example.com/img.png');
      expect(a.sourceName, 'Example');
    });

    test('should support value equality', () {
      final a1 = Article(
        title: 'T',
        description: null,
        publishedAt: DateTime.utc(2025, 1, 1),
        url: 'u',
        urlToImage: null,
        sourceName: 'S',
      );
      final a2 = Article(
        title: 'T',
        description: null,
        publishedAt: DateTime.utc(2025, 1, 1),
        url: 'u',
        urlToImage: null,
        sourceName: 'S',
      );

      expect(a1, equals(a2));
      expect(a1.hashCode, equals(a2.hashCode));
    });

    test('should allow nullable image and description', () {
      final a = Article(
        title: 'No image',
        description: null,
        publishedAt: DateTime.utc(2025, 1, 1),
        url: 'u',
        urlToImage: null,
        sourceName: 'S',
      );

      expect(a.urlToImage, isNull);
      expect(a.description, isNull);
    });
  });
}
