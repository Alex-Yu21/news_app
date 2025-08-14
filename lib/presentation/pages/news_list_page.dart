import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/cubit/news_list_cubit.dart';
import 'package:news_app/presentation/widgets/article_card.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top headlines')),
      body: BlocBuilder<NewsListCubit, NewsListState>(
        builder: (context, state) {
          switch (state.status) {
            case NewsListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case NewsListStatus.error:
              return Center(child: Text(state.error ?? 'Error'));
            case NewsListStatus.empty:
              return const Center(child: Text('No articles'));
            case NewsListStatus.success:
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<NewsListCubit>().load(reset: true, page: 1),
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (_, i) => ArticleCard(article: state.items[i]),
                ),
              );
            case NewsListStatus.idle:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
