import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/app/di/locator.dart';
import 'package:news_app/app/router.dart';
import 'package:news_app/app/theme/app_theme.dart';
import 'package:news_app/presentation/cubit/news_list_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsListCubit>(create: (_) => getIt<NewsListCubit>()),
      ],
      child: MaterialApp.router(
        title: 'News',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}
