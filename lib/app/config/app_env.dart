const newsApiKey = String.fromEnvironment('NEWS_API_KEY', defaultValue: '');
void ensureApiKey() {
  if (newsApiKey.isEmpty) {
    throw StateError(
      'NEWS_API_KEY is missing. Run with --dart-define=NEWS_API_KEY=...',
    );
  }
}
