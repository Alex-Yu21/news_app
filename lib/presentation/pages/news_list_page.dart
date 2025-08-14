import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/cubit/news_list_cubit.dart';
import 'package:news_app/presentation/widgets/article_card.dart';
import 'package:news_app/presentation/widgets/category_chips.dart';
import 'package:news_app/presentation/widgets/search_field.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top headlines')),
      body: BlocBuilder<NewsListCubit, NewsListState>(
        builder: (context, state) {
          final cubit = context.read<NewsListCubit>();

          Widget content;
          switch (state.status) {
            case NewsListStatus.loading:
              content = const Center(child: CircularProgressIndicator());
              break;
            case NewsListStatus.error:
              content = Center(child: Text(state.error ?? 'Error'));
              break;
            case NewsListStatus.empty:
              content = const Center(child: Text('No articles'));
              break;
            case NewsListStatus.success:
              content = ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (_, i) => ArticleCard(article: state.items[i]),
              );
              break;
            case NewsListStatus.idle:
              content = const SizedBox.shrink();
              break;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: SearchField(onChanged: cubit.onQueryChanged),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CategoryChips(
                  value: state.category,
                  onSelected: cubit.onCategorySelected,
                ),
              ),
              const Divider(height: 1),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }
}
