import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/pages/favorites_page.dart';
import 'package:news_app/presentation/pages/news_details_page.dart';
import 'package:news_app/presentation/pages/news_list_page.dart';
import 'package:news_app/presentation/widgets/card_shadow.dart';

const double _kLR = 19;
const double _kBottomGap = 20;
const double _kBarHeight = 84;
const double _kRadius = 16;
const Color _kBorderColor = Color(0xFFCECECE);
const Color _kShadowColor = Color(0x26000000);

const Size _kNewsIconSize = Size(36, 27);
const Size _kFavIconSize = Size(41, 33);

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  int _indexOf(String path) => path.startsWith('/favorites') ? 1 : 0;

  void _onTap(BuildContext context, int index) {
    if (index == 0) {
      context.go('/');
    } else {
      context.go('/favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final currentIndex = _indexOf(path);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(top: true, bottom: false, child: child),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bottomInset + _kBottomGap + _kBarHeight / 2,
            child: const IgnorePointer(child: ColoredBox(color: Colors.white)),
          ),
          _BottomNavBar(
            bottomInset: bottomInset,
            currentIndex: currentIndex,
            onTap: (i) => _onTap(context, i),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.bottomInset,
    required this.currentIndex,
    required this.onTap,
  });

  final double bottomInset;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(_kRadius)),
    side: BorderSide(color: _kBorderColor, width: 0.5),
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _kLR,
      right: _kLR,
      bottom: bottomInset + _kBottomGap,
      height: _kBarHeight,
      child: CardShadow(
        child: Material(
          color: Colors.white,
          shape: _shape,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: _kBarHeight,
            child: Row(
              children: [
                Expanded(
                  child: _NavItem(
                    isActive: currentIndex == 0,
                    asset: 'assets/icons/news_list.svg',
                    activeAsset: 'assets/icons/news_list_pressed.svg',
                    size: _kNewsIconSize,
                    onTap: () => onTap(0),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    isActive: currentIndex == 1,
                    asset: 'assets/icons/favorite.svg',
                    activeAsset: 'assets/icons/favorite_pressed.svg',
                    size: _kFavIconSize,
                    onTap: () => onTap(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.isActive,
    required this.asset,
    required this.activeAsset,
    required this.size,
    required this.onTap,
  });

  final bool isActive;
  final String asset;
  final String activeAsset;
  final Size size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final a = isActive ? activeAsset : asset;
    return InkResponse(
      onTap: onTap,
      containedInkWell: true,
      highlightShape: BoxShape.rectangle,
      splashFactory: InkRipple.splashFactory,
      child: Center(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: SvgPicture.asset(a, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

String articleHeroTag(Article a) => 'article-image-${a.urlToImage ?? a.url}';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'list',
          pageBuilder: (_, __) => const NoTransitionPage(child: NewsListPage()),
          routes: [
            GoRoute(
              path: 'details',
              name: 'details',
              builder: (context, state) {
                final article = state.extra! as Article;
                return NewsDetailsPage(article: article);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          builder: (_, __) => const FavoritesPage(),
        ),
      ],
    ),
  ],
);
