import 'package:flutter/material.dart';
import 'package:news_app/app/theme/app_text.dart';
import 'package:news_app/domain/enums/news_category.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key, required this.values, this.onToggle});

  final Set<NewsCategory> values;
  final void Function(NewsCategory cat, bool selected)? onToggle;

  static const _chipWidth = 114.0;
  static const _chipHeight = 44.0;
  static const _chipRadius = 22.0;
  static const _chipSpacing = 7.0;

  @override
  Widget build(BuildContext context) {
    final t = context.appText;
    final cats = NewsCategory.values;

    return SizedBox(
      height: _chipHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        clipBehavior: Clip.none,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: _chipSpacing),
        itemBuilder: (context, i) {
          final c = cats[i];
          final selected = values.contains(c);
          final text = c.name[0].toUpperCase() + c.name.substring(1);

          return SizedBox(
            width: _chipWidth,
            height: _chipHeight,
            child: RawChip(
              showCheckmark: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              side: BorderSide.none,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_chipRadius),
              ),
              selected: selected,
              onSelected: (sel) => onToggle?.call(c, sel),

              label: Center(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: t.caption.copyWith(color: Colors.white, height: 1.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
