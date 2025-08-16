import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/app/network/dio_client.dart';
import 'package:news_app/data/datasources/local/favorites_local.dart';
import 'package:news_app/data/datasources/remote/news_api_remote.dart';
import 'package:news_app/data/repositories/favorites_repository_impl.dart';
import 'package:news_app/data/repositories/news_repository_impl.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';
import 'package:news_app/domain/repositories/news_repository.dart';
import 'package:news_app/presentation/cubit/favorites_cubit.dart';
import 'package:news_app/presentation/cubit/news_list_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(DioClient.create);
  }

  getIt.registerLazySingleton<NewsApiRemote>(() => NewsApiRemote(getIt()));
  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(getIt()),
  );
  getIt.registerFactory<NewsListCubit>(() => NewsListCubit(getIt()));

  if (!getIt.isRegistered<SharedPreferences>()) {
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);
  }

  getIt.registerLazySingleton<FavoritesLocal>(() => FavoritesLocal(getIt()));
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<FavoritesCubit>(() => FavoritesCubit(getIt()));
}
