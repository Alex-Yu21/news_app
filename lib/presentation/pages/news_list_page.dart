import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/app/router.dart';
import 'package:news_app/app/theme/app_sizes.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/cubit/news_list_cubit.dart';
import 'package:news_app/presentation/widgets/article_card.dart';
import 'package:news_app/presentation/widgets/card_shadow.dart';
import 'package:news_app/presentation/widgets/category_chips.dart';
import 'package:news_app/presentation/widgets/search_field.dart';
import 'package:news_app/presentation/widgets/slide_up_reveal.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  static const _searchPadding = EdgeInsets.only(top: 28, left: 22, right: 22);
  static const _chipsPadding = EdgeInsets.only(
    top: 34,
    left: 19,
    right: 19,
    bottom: 22,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<NewsListCubit, NewsListState>(
            builder: (context, state) {
              final cubit = context.read<NewsListCubit>();

              return Column(
                children: [
                  Padding(
                    padding: _searchPadding,
                    child: SearchField(onChanged: cubit.onQueryChanged),
                  ),
                  Padding(
                    padding: _chipsPadding,
                    child: CategoryChips(
                      values: state.categories,
                      onToggle: cubit.onToggleCategory,
                    ),
                  ),
                  Expanded(
                    child: _NewsListBody(state: state, cubit: cubit),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NewsListBody extends StatefulWidget {
  const _NewsListBody({required this.state, required this.cubit});

  final NewsListState state;
  final NewsListCubit cubit;

  @override
  State<_NewsListBody> createState() => _NewsListBodyState();
}

class _NewsListBodyState extends State<_NewsListBody> {
  NewsListStatus? _lastStatus;

  @override
  void initState() {
    super.initState();
    _lastStatus = widget.state.status;
  }

  @override
  void didUpdateWidget(covariant _NewsListBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    _lastStatus = oldWidget.state.status;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = widget.cubit;

    switch (state.status) {
      case NewsListStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case NewsListStatus.error:
        return _ErrorView(
          message: state.error ?? 'Something went wrong',
          onRetry: () => cubit.load(reset: true, page: 1),
        );
      case NewsListStatus.empty:
        return const Center(child: Text('No articles'));
      case NewsListStatus.success:
        final shouldAnimate =
            _lastStatus != NewsListStatus.success && state.items.isNotEmpty;

        final list = _ArticlesList(
          items: state.items,
          hasMore: state.hasMore,
          onFetchMore: cubit.fetchMore,
          onRefresh: () => cubit.load(reset: true, page: 1),
        );
        return SlideUpReveal(
          enabled: shouldAnimate,
          from: AppSizes.bottomPadding(context),
          child: list,
        );

      case NewsListStatus.idle:
        return const SizedBox.shrink();
    }
  }
}

class _ArticlesList extends StatefulWidget {
  const _ArticlesList({
    required this.items,
    required this.hasMore,
    required this.onFetchMore,
    required this.onRefresh,
  });

  final List<Article> items;
  final bool hasMore;
  final VoidCallback onFetchMore;
  final Future<void> Function() onRefresh;

  @override
  State<_ArticlesList> createState() => _ArticlesListState();
}

class _ArticlesListState extends State<_ArticlesList> {
  late final ScrollController _controller;
  int _autoTries = 0;
  static const _kThresholdPx = 400.0;
  static const _kMaxAutoTries = 3;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) => _tryAutoFetchIfShort());
  }

  @override
  void didUpdateWidget(covariant _ArticlesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != oldWidget.items.length) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _tryAutoFetchIfShort(),
      );
    }
  }

  void _onScroll() {
    if (!_controller.hasClients || !widget.hasMore) return;
    final extentAfter = _controller.position.extentAfter;
    if (extentAfter < _kThresholdPx) {
      widget.onFetchMore();
    }
  }

  void _tryAutoFetchIfShort() {
    if (!mounted || !widget.hasMore || !_controller.hasClients) return;

    final isShort = _controller.position.maxScrollExtent <= 0;
    if (isShort && _autoTries < _kMaxAutoTries) {
      _autoTries++;
      widget.onFetchMore();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: AppSizes.bottomPadding(context)),
        itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i < widget.items.length) {
            final Article article = widget.items[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 19, right: 19),
              child: CardShadow(
                child: ArticleCard(
                  article: article,
                  heroTag: articleHeroTag(article),
                  onTap: () => context.pushNamed('details', extra: article),
                ),
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: AppSizes.iconM,
                height: AppSizes.iconM,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
