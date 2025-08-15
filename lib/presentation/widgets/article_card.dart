import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/app/theme/app_sizes.dart';
import 'package:news_app/app/theme/app_text.dart';
import 'package:news_app/domain/entities/article.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.heroTag,
  });

  final Article article;
  final VoidCallback? onTap;
  final Object? heroTag;

  String _formatDate(DateTime? dt) =>
      dt == null ? '' : DateFormat('MM.dd.yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).extension<AppText>() ?? AppText.satoshi();
    final subtitle = (article.description?.trim().isNotEmpty ?? false)
        ? article.description!.trim()
        : (article.sourceName);

    Widget image = SizedBox(
      width: AppSizes.imageWidth,
      height: AppSizes.imageHeigth,
      child: _ArticleImage(
        url: article.urlToImage,
        sourceName: article.sourceName,
      ),
    );

    image = ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppSizes.radS),
        bottomLeft: Radius.circular(AppSizes.radS),
      ),
      child: image,
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radS),
          border: Border.all(color: Color(0xFFCECECE), width: 0.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radS),
          onTap: onTap,
          child: SizedBox(
            height: AppSizes.imageHeigth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                image,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          article.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.title,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (subtitle.trim().isNotEmpty)
                        Text(
                          subtitle.trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.body,
                          strutStyle: const StrutStyle(
                            forceStrutHeight: true,
                            height: 1.3,
                          ),
                        ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6, right: 11),
                          child: Text(
                            _formatDate(article.publishedAt),
                            style: text.caption,
                          ),
                        ),
                      ),
                    ],
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

class _ArticleImage extends StatelessWidget {
  const _ArticleImage({required this.url, required this.sourceName});

  final String? url;
  final String sourceName;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _SourceLabelPlaceholder(sourceName: sourceName);
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (_, __) => _SourceLabelPlaceholder(sourceName: sourceName),
      errorWidget: (_, __, ___) =>
          _SourceLabelPlaceholder(sourceName: sourceName),
      fadeInDuration: const Duration(milliseconds: 180),
      fadeOutDuration: const Duration(milliseconds: 120),
    );
  }
}

class _SourceLabelPlaceholder extends StatelessWidget {
  const _SourceLabelPlaceholder({this.sourceName = ''});

  final String sourceName;

  String _label(String s) {
    final name = s.trim();
    if (name.isEmpty) return '•';
    if (name.length <= 3) return '•';
    final words = name
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (words.length >= 3) {
      final acronym = words.map((w) => w[0]).join().toUpperCase();
      return acronym;
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppText>() ?? AppText.satoshi();
    final bg = const Color(0xFFC1C1C1);
    final fg = Colors.white70;

    return Container(
      alignment: Alignment.center,
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        _label(sourceName),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: t.title.copyWith(color: fg),
      ),
    );
  }
}
