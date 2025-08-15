import 'package:flutter/material.dart';
import 'package:news_app/app/theme/app_sizes.dart';
import 'package:news_app/app/theme/app_text.dart';
import 'package:news_app/domain/enums/news_category.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key, required this.value, this.onSelected});

  final NewsCategory? value;
  final ValueChanged<NewsCategory?>? onSelected;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<AppText>()!;
    final cats = NewsCategory.values;

    return SizedBox(
      height: AppSizes.chipsHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        clipBehavior: Clip.none,
        itemCount: cats.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppSizes.chipsSpacing),
        itemBuilder: (context, i) {
          final c = cats[i];
          final selected = value == c;
          final text = c.name[0].toUpperCase() + c.name.substring(1);

          return RawChip(
            showCheckmark: false,
            labelPadding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.chipsRadius),
            ),
            selected: selected,
            onSelected: (_) => onSelected?.call(selected ? null : c),
            label: SizedBox(
              width: AppSizes.chipsWidth,
              height: AppSizes.chipsHeight,
              child: Center(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    height: 0.1,
                  ),
                  style: style.caption.copyWith(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
