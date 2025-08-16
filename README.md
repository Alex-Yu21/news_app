
# News App — Flutter (Clean Architecture, BLoC, TDD)

Небольшое новостное приложение с чистой архитектурой, управлением состоянием через `flutter_bloc`, маршрутизацией `go_router`, DI на `get_it` и сетевым слоем на `dio`. Ошибки API и сети мапятся в доменные `Failure` и показываются в UI.

## Стек
- Flutter
- `flutter_bloc`, `equatable`
- `get_it`
- `go_router`
- `dio`
- `json_serializable`, `build_runner`
- `shared_preferences`
- `cached_network_image`
- `url_launcher`
- Тесты: `bloc_test`, `mocktail`, `flutter_test`

## Быстрый старт
flutter pub get
dart run build_runner build -d
flutter run --dart-define=NEWS_API_KEY=<your_newsapi_key>
flutter analyze
flutter test
dart format --output=none --set-exit-if-changed .
dart fix --apply
- Первый вариант
flutter build apk --release --dart-define=NEWS_API_KEY=<your_newsapi_key>
- Второй вариант 
cp .env.example .env
вписать ( NEWS_API_KEY=<your_newsapi_key> )
flutter run --dart-define=NEWS_API_KEY=$(grep NEWS_API_KEY .env | cut -d= -f2)

## Что реализовано
- Список новостей с фильтрами по категориям и поиском
- Детали статьи с открытием оригинальной ссылки
- Локальные избранные на shared_preferences
- Плавные появления карточек
- Нижняя навигация
- Обработка ошибок API/сети:
    - dio → DioException → Failure (timeout, no internet, HTTP ошибки)
    - NewsListCubit переключает состояние в error и показывает ErrorView

## Переменные окружения
NEWS_API_KEY читается через String.fromEnvironment в app/config/app_env.dart

Сборка релиза

Вариант 1 (явно передать ключ):
flutter build apk --release --dart-define=NEWS_API_KEY=<your_newsapi_key>

Вариант 2 (через .env):
flutter build apk --release \
  --dart-define=NEWS_API_KEY=$(grep NEWS_API_KEY .env | cut -d= -f2)