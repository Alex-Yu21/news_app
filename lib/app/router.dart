import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/presentation/pages/news_list_page.dart';

Widget _stub(String title) => Scaffold(
  appBar: AppBar(title: Text(title)),
  body: const SizedBox(),
);

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const NewsListPage()),
    GoRoute(path: '/details', builder: (_, __) => _stub('Details (stub)')),
    GoRoute(path: '/favorites', builder: (_, __) => _stub('Favorites (stub)')),
  ],
);
