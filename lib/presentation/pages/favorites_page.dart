import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/app/router.dart';
import 'package:news_app/app/theme/app_sizes.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/cubit/favorites_cubit.dart';
import 'package:news_app/presentation/widgets/article_card.dart';
import 'package:news_app/presentation/widgets/favorite_button.dart';
import 'package:news_app/presentation/widgets/slide_up_reveal.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  static const _listBaseInsets = EdgeInsets.only(top: 109, left: 19, right: 19);
  static const _cardsPadding = EdgeInsets.only(bottom: 16);
  static const _favBtnW = 33.0;
  static const _favBtnH = 32.0;

  final _listKey = GlobalKey<AnimatedListState>();
  final List<Article> _renderItems = [];

  FavoritesStatus? _lastStatus;
  bool _reveal = false;

  String _id(Article a) => a.url;

  static const _cardShadowDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: Color(0x26000000),
        blurRadius: 6.1,
        offset: Offset(0, 3),
        spreadRadius: 0,
      ),
    ],
  );

  Widget _builCard(Article a) {
    return InkWell(
      onTap: () => context.pushNamed('details', extra: a),
      child: DecoratedBox(
        decoration: _cardShadowDecoration,
        child: ArticleCard(
          article: a,
          heroTag: articleHeroTag(a),
          trailing: FavoriteButton(
            article: a,
            width: _favBtnW,
            height: _favBtnH,
          ),
        ),
      ),
    );
  }

  Widget _tile(Animation<double> animation, Widget child) {
    final curve = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    return Padding(
      padding: _cardsPadding,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.05),
          end: Offset.zero,
        ).animate(curve),
        child: FadeTransition(opacity: curve, child: child),
      ),
    );
  }

  void _sync(List<Article> next) {
    final nextIds = next.map(_id).toSet();

    for (int i = _renderItems.length - 1; i >= 0; i--) {
      final a = _renderItems[i];
      if (!nextIds.contains(_id(a))) {
        final removed = _renderItems.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, anim) => _tile(anim, _builCard(removed)),
          duration: Duration(milliseconds: 220),
        );
      }
    }

    for (int i = 0; i < next.length; i++) {
      final a = next[i];
      final idx = _renderItems.indexWhere((x) => _id(x) == _id(a));
      if (idx == -1) {
        _renderItems.insert(i, a);
        _listKey.currentState?.insertItem(
          i,
          duration: Duration(milliseconds: 240),
        );
      } else if (idx != i) {
        final moved = _renderItems.removeAt(idx);
        _renderItems.insert(i, moved);
      }
    }
  }

  bool _takeReveal() {
    final v = _reveal;
    _reveal = false;
    return v;
  }

  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, FavoritesState>(
      listenWhen: (prev, curr) =>
          prev.items != curr.items || prev.status != curr.status,
      listener: (context, state) {
        final shouldReveal =
            _lastStatus != FavoritesStatus.ready &&
            state.status == FavoritesStatus.ready &&
            state.items.isNotEmpty;

        if (_renderItems.isEmpty &&
            state.status == FavoritesStatus.ready &&
            state.items.isNotEmpty) {
          _renderItems
            ..clear()
            ..addAll(state.items);
        } else {
          _sync(state.items);
        }

        _reveal = _reveal || shouldReveal;
        _lastStatus = state.status;
      },
      builder: (context, state) {
        if (state.status == FavoritesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_renderItems.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }

        final padding = _listBaseInsets.add(
          EdgeInsets.only(bottom: AppSizes.bottomPadding(context)),
        );

        final list = AnimatedList(
          key: _listKey,
          padding: padding,
          initialItemCount: _renderItems.length,
          itemBuilder: (context, index, animation) =>
              _tile(animation, _builCard(_renderItems[index])),
        );

        return SlideUpReveal(
          enabled: _takeReveal(),
          from: AppSizes.bottomPadding(context),
          child: list,
        );
      },
    );
  }
}
