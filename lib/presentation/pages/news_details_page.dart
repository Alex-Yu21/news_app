import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:news_app/app/router.dart';
import 'package:news_app/app/theme/app_icons.dart';
import 'package:news_app/app/theme/app_sizes.dart';
import 'package:news_app/app/theme/app_text.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/widgets/card_shadow.dart';
import 'package:news_app/presentation/widgets/favorite_button.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key, required this.article});

  final Article article;

  static const _appBarHeight = 61.0;
  static const _screenPadding = EdgeInsets.symmetric(horizontal: 16);
  static const _gapAfterSubtitle = 24.0;
  static const _imageTopGap = 10.0;
  static const _imageBottomGap = 18.0;

  static const _favBtnW = 43.0;
  static const _favBtnH = 41.0;

  static const _arrowW = 28.0;
  static const _arrowH = 24.35;

  @override
  Widget build(BuildContext context) {
    final t = context.appText;
    final date = DateFormat('MM.dd.yyyy').format(article.publishedAt);
    final subtitle = article.description;
    final body = article.content;
    final imageUrl = article.urlToImage;
    final br = const BorderRadius.all(Radius.circular(AppSizes.radImage));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        toolbarHeight: _appBarHeight,
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => context.pop(),
              padding: EdgeInsets.only(left: _screenPadding.left),
              icon: SvgPicture.asset(
                AppIcons.backArrow,
                width: _arrowW,
                height: _arrowH,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        actions: [
          FavoriteButton(article: article, width: _favBtnW, height: _favBtnH),
          SizedBox(width: _screenPadding.right),
        ],
      ),
      body: ListView(
        clipBehavior: Clip.none,
        padding: _screenPadding.copyWith(
          bottom: AppSizes.bottomPadding(context),
        ),
        children: [
          Text(article.title, style: t.titleLg),
          if (subtitle != null) Text(subtitle, style: t.subtitleLg),
          const SizedBox(height: _gapAfterSubtitle),
          Row(
            children: [
              Expanded(child: Text(article.sourceName, style: t.body)),
              Text(date, style: t.body),
            ],
          ),
          const SizedBox(height: _imageTopGap),
          if (imageUrl != null)
            CardShadow(
              radius: br,
              child: Hero(
                tag: articleHeroTag(article),
                child: ClipRRect(
                  borderRadius: br,
                  child: AspectRatio(
                    aspectRatio: 328 / 265,
                    child: CardShadow(
                      radius: br,
                      child: ClipRRect(
                        borderRadius: br,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: _imageBottomGap),
          if (body != null) Text(body, style: t.bodyLg),
          // API не забирает статью полностью, решила дать ссылку на полный тест в конце
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => _openArticle(article.url),
              child: Text('read more', style: t.bodyLg),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openArticle(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    );
  }
}
