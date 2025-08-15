import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/widgets/article_card.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

Article _article({
  String title = 'Title',
  String? description = 'Subtitle',
  DateTime? publishedAt,
  String url = 'https://example.com',
  String? urlToImage,
  String sourceName = 'Wall Street Journal',
}) {
  return Article(
    title: title,
    description: description,
    publishedAt: publishedAt ?? DateTime.utc(2025, 1, 1),
    url: url,
    urlToImage: urlToImage,
    sourceName: sourceName,
  );
}

void main() {
  testWidgets('should show description when present', (tester) async {
    final a = _article(description: 'Desc', sourceName: 'WSJ');
    await tester.pumpWidget(_wrap(ArticleCard(article: a)));
    expect(find.text('Desc'), findsOneWidget);
    expect(find.text('WSJ'), findsNothing);
  });

  testWidgets('should fallback to source name when description is empty', (
    tester,
  ) async {
    final a = _article(description: null, sourceName: 'WSJ');
    await tester.pumpWidget(_wrap(ArticleCard(article: a)));
    expect(find.text('WSJ'), findsOneWidget);
  });

  testWidgets('should show acronym WSJ for long source without image', (
    tester,
  ) async {
    final a = _article(urlToImage: null, sourceName: 'Wall Street Journal');
    await tester.pumpWidget(_wrap(ArticleCard(article: a)));
    expect(find.text('WSJ'), findsOneWidget);
  });

  testWidgets('should show full short source name for placeholder', (
    tester,
  ) async {
    final a = _article(urlToImage: null, sourceName: 'ABC News');
    await tester.pumpWidget(_wrap(ArticleCard(article: a)));
    expect(find.text('ABC News'), findsOneWidget);
  });
}
