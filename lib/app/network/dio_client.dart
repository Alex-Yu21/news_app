import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_key_interceptor.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://newsapi.org/v2/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(ApiKeyInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
      );
    }

    return dio;
  }
}
