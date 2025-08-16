import 'package:dio/dio.dart';
import 'package:news_app/core/errors/failures.dart';

Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure('Request timed out. Try again.');
    case DioExceptionType.connectionError:
    case DioExceptionType.unknown:
      return const NetworkFailure('No internet connection.');
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      var message = 'API error';
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        message = (data['message'] as String?) ?? message;
      }
      return ApiFailure(message, statusCode: code);
    case DioExceptionType.cancel:
      return const UnknownFailure('Request cancelled.');
    default:
      return const UnknownFailure('Unexpected error.');
  }
}
