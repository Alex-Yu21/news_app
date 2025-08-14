import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/remote/news_api_remote.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

void setupLocator() {
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(DioClient.create);
  }
  if (!getIt.isRegistered<NewsApiRemote>()) {
    getIt.registerLazySingleton<NewsApiRemote>(() => NewsApiRemote(getIt()));
  }
  if (!getIt.isRegistered<NewsRepository>()) {
    getIt.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(getIt()),
    );
  }
}
