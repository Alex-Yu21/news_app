import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/app/network/dio_client.dart';
import 'package:news_app/data/datasources/remote/news_api_remote.dart';
import 'package:news_app/data/repositories/news_repository_impl.dart';
import 'package:news_app/domain/repositories/news_repository.dart';
import 'package:news_app/presentation/cubit/news_list_cubit.dart';

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

  if (!getIt.isRegistered<NewsListCubit>()) {
    getIt.registerFactory<NewsListCubit>(
      () => NewsListCubit(getIt<NewsRepository>()),
    );
  }
}
