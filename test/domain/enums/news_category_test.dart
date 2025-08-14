import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/app/domain/enums/news_category.dart';

void main() {
  group('NewsCategory', () {
    test('should map enum to API string', () {
      expect(NewsCategory.business.api, 'business');
      expect(NewsCategory.entertainment.api, 'entertainment');
      expect(NewsCategory.general.api, 'general');
      expect(NewsCategory.health.api, 'health');
      expect(NewsCategory.science.api, 'science');
      expect(NewsCategory.sports.api, 'sports');
      expect(NewsCategory.technology.api, 'technology');
    });

    test('should parse from API string (case-insensitive)', () {
      expect(NewsCategoryX.fromApi('Business'), NewsCategory.business);
      expect(
        NewsCategoryX.fromApi('entertainment'),
        NewsCategory.entertainment,
      );
      expect(NewsCategoryX.fromApi('GENERAL'), NewsCategory.general);
    });

    test('should return null on unknown or empty', () {
      expect(NewsCategoryX.fromApi('politics'), isNull);
      expect(NewsCategoryX.fromApi(''), isNull);
      expect(NewsCategoryX.fromApi(null), isNull);
    });
  });
}
