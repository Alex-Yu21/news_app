import 'package:dio/dio.dart';
import 'package:news_app/app/config/app_env.dart';

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('X-Api-Key', () => newsApiKey);
    handler.next(options);
  }
}
