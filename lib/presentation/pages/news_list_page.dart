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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Top headlines')),
        body: BlocBuilder<NewsListCubit, NewsListState>(
          builder: (context, state) {
            Widget content;

            switch (state.status) {
              case NewsListStatus.loading:
                content = const Center(child: CircularProgressIndicator());
                break;

              case NewsListStatus.error:
                content = Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.error ?? 'Something went wrong'),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context.read<NewsListCubit>().load(
                            reset: true,
                            page: 1,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
                break;

              case NewsListStatus.empty:
                content = const Center(child: Text('No articles'));
                break;

              case NewsListStatus.success:
                final items = state.items;

                content = NotificationListener<ScrollNotification>(
                  onNotification: (sn) {
                    if (sn.metrics.pixels >= sn.metrics.maxScrollExtent - 400) {
                      context.read<NewsListCubit>().fetchMore();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () => context.read<NewsListCubit>().load(
                      reset: true,
                      page: 1,
                    ),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: items.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i < items.length) {
                          return ArticleCard(article: items[i]);
                        }
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                  child: SearchField(
                    onChanged: context.read<NewsListCubit>().onQueryChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CategoryChips(
                    value: state.category,
                    onSelected: context
                        .read<NewsListCubit>()
                        .onCategorySelected,
                  ),
                ),
                const Divider(height: 1),
                Expanded(child: content),
              ],
            );
          },
        ),
      ),
    );
  }
}
