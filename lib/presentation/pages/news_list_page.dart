import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/news_repository.dart';
import 'package:news_app/presentation/widgets/article_card.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  Future<List<Article>> _load() {
    return GetIt.I<NewsRepository>().getHeadlines(country: 'us');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top headlines')),
      body: FutureBuilder<List<Article>>(
        future: _load(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final items = snap.data ?? const <Article>[];
          if (items.isEmpty) return const Center(child: Text('No articles'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => ArticleCard(article: items[i]),
          );
        },
      ),
    );
  }
}
