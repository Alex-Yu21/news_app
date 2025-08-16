import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:news_app/app/router.dart';
import 'package:news_app/app/theme/app_sizes.dart';
import 'package:news_app/app/theme/app_text.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/widgets/card_shadow.dart';
import 'package:news_app/presentation/widgets/favorite_button.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).extension<AppText>();
    final date = DateFormat('MM.dd.yyyy').format(article.publishedAt);
    final subtitle = (article.description ?? '').trim();
    final body = (article.content ?? '').trim();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 28),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => context.pop(),
            icon: SvgPicture.asset(
              'assets/icons/back_arrow.svg',
              width: 28,
              height: 24.35,
              fit: BoxFit.contain,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 16),
            child: FavoriteButton(article: article, height: 41, width: 43),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        clipBehavior: Clip.none,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: AppSizes.bottomPadding(context),
        ),
        children: [
          const SizedBox(height: 8.38),
          Text(article.title, style: text?.titleLg),
          const SizedBox(height: 8),
          if (subtitle.isNotEmpty) Text(subtitle, style: text?.subtitleLg),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Text(article.sourceName, style: text?.body)),
              Text(date, style: text?.body),
            ],
          ),
          const SizedBox(height: 10),
          if ((article.urlToImage ?? '').isNotEmpty)
            CardShadow(
              radius: const BorderRadius.all(
                Radius.circular(AppSizes.radImage),
              ),
              child: Hero(
                tag: articleHeroTag(article),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppSizes.radImage),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: article.urlToImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 18),
          if (body.isNotEmpty) Text(body, style: text?.bodyLg),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                final uri = Uri.tryParse(article.url);
                if (uri != null) {
                  launchUrl(
                    uri,
                    mode: LaunchMode.inAppBrowserView,
                    webViewConfiguration: const WebViewConfiguration(
                      enableJavaScript: true,
                    ),
                  );
                }
              },
              child: Text('read more', style: text?.bodyLg),
            ),
          ),
        ],
      ),
    );
  }
}
