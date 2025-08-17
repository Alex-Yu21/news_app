import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/app/theme/app_icons.dart';
import 'package:news_app/app/theme/app_sizes.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/pages/favorites_page.dart';
import 'package:news_app/presentation/pages/news_details_page.dart';
import 'package:news_app/presentation/pages/news_list_page.dart';
import 'package:news_app/presentation/widgets/card_shadow.dart';

const _kBarPadding = EdgeInsets.symmetric(horizontal: 19);
const _kBarBottomGap = 20.0;
const _kBarHeight = 84.0;

const _kNewsIconSize = Size(36, 27);
const _kFavIconSize = Size(41, 33);

@immutable
enum AppRoute {
  list('/', 'list'),
  details('details', 'details'),
  favorites('/favorites', 'favorites');

  final String path;
  final String routeName;
  const AppRoute(this.path, this.routeName);
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  int _indexOf(String path) => path.startsWith(AppRoute.favorites.path) ? 1 : 0;

  void _onTap(BuildContext context, int index) {
    final target = index == 0 ? AppRoute.list : AppRoute.favorites;
    context.goNamed(target.routeName);
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
          /* Подложка под AppBar. Добавила чтобы при скролле контент не «просвечивал» под навбаром - 
 на экране деталей паддинг по краям страници меньше и без обложки обрезается текст.*/
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bottomInset + _kBarBottomGap + _kBarHeight,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00FFFFFF), Colors.white],
                  stops: [0, 0.15],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset + _kBarBottomGap,
            height: _kBarHeight,
            child: Padding(
              padding: _kBarPadding,
              child: CardShadow(
                child: Material(
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(AppSizes.radS),
                    side: BorderSide(color: Color(0xFFCECECE), width: 0.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    height: _kBarHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: _NavItem(
                            isActive: currentIndex == 0,
                            asset: AppIcons.newsList,
                            activeAsset: AppIcons.newsListPr,
                            size: _kNewsIconSize,
                            onTap: () => _onTap(context, 0),
                          ),
                        ),
                        Expanded(
                          child: _NavItem(
                            isActive: currentIndex == 1,
                            asset: AppIcons.fvt,
                            activeAsset: AppIcons.fvtPr,
                            size: _kFavIconSize,
                            onTap: () => _onTap(context, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
    return InkWell(
      onTap: onTap,
      splashFactory: InkRipple.splashFactory,
      child: Center(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: SvgPicture.asset(
            isActive ? activeAsset : asset,
            fit: BoxFit.contain,
          ),
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
          path: AppRoute.list.path,
          name: AppRoute.list.routeName,
          pageBuilder: (_, __) => const NoTransitionPage(child: NewsListPage()),
          routes: [
            GoRoute(
              path: AppRoute.details.path,
              name: AppRoute.details.routeName,
              redirect: (context, state) =>
                  state.extra is Article ? null : AppRoute.list.path,
              builder: (context, state) {
                final article = state.extra! as Article;
                return NewsDetailsPage(article: article);
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoute.favorites.path,
          name: AppRoute.favorites.routeName,
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: FavoritesPage()),
        ),
      ],
    ),
  ],
);
