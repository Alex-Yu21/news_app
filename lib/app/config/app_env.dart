const newsApiKey = String.fromEnvironment('NEWS_API_KEY', defaultValue: '');

const defaultCountry = String.fromEnvironment(
  'NEWS_COUNTRY',
  defaultValue: 'us',
);

void ensureApiKey() {
  if (newsApiKey.isEmpty) {
    throw StateError(
      'NEWS_API_KEY is missing. Run with --dart-define=NEWS_API_KEY=...',
    );
  }
}
