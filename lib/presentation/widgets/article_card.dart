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
    this.trailing,
  });

  final Article article;
  final VoidCallback? onTap;
  final Object? heroTag;
  final Widget? trailing;

  static const _cardBorder = BorderSide(color: Color(0xFFCECECE), width: 0.5);
  static const _cardRadius = BorderRadius.all(AppSizes.radS);

  static const double _imageHeigth = 112.0;
  static const double _imageWidth = 123.0;
  static const _imageClipRadius = BorderRadius.only(
    topLeft: AppSizes.radS,
    bottomLeft: AppSizes.radS,
  );

  static const _gapBwImageAndTitle = SizedBox(width: 12);

  static const _starPadding = EdgeInsets.only(top: 5, right: 11);
  static const _datePadding = EdgeInsets.only(bottom: 6, right: 11);

  String _formatDate(DateTime? dt) =>
      dt == null ? '' : DateFormat('MM.dd.yyyy').format(dt);

  String _subtitleOf(Article a) {
    final desc = a.description?.trim() ?? '';
    if (desc.isNotEmpty) return desc;
    return a.sourceName.trim();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appText;
    final subtitle = _subtitleOf(article);
    final dateText = _formatDate(article.publishedAt);

    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: _cardRadius,
          border: const Border.fromBorderSide(_cardBorder),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: _cardRadius,
          child: SizedBox(
            height: _imageHeigth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CardImage(
                  imageHeigth: _imageHeigth,
                  imageWidth: _imageWidth,
                  url: article.urlToImage,
                  sourceName: article.sourceName,
                  heroTag: heroTag,
                ),
                _gapBwImageAndTitle,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: _starPadding,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                article.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.title,
                              ),
                            ),
                            if (trailing != null) trailing!,
                          ],
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.body,
                        ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: _datePadding,
                          child: Text(dateText, style: t.caption),
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

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.url,
    required this.sourceName,
    this.heroTag,
    required this.imageWidth,
    required this.imageHeigth,
  });

  final String? url;
  final String sourceName;
  final Object? heroTag;

  final double imageWidth;
  final double imageHeigth;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: imageWidth,
      height: imageHeigth,
      child: _ArticleImage(url: url, sourceName: sourceName),
    );

    child = ClipRRect(borderRadius: ArticleCard._imageClipRadius, child: child);
    if (heroTag != null) child = Hero(tag: heroTag!, child: child);

    return child;
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

  String _label(String raw) {
    final name = raw.trim();
    if (name.isEmpty || name.length <= 3) return '•';
    final words = name
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (words.length >= 3) {
      return words.map((w) => w[0]).join().toUpperCase();
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appText;
    const bg = Color(0xFFC1C1C1);
    const fg = Colors.white70;

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
