import 'package:flutter/material.dart';
import 'package:news_app/domain/enums/news_category.dart';

class CategoryChips extends StatelessWidget {
  final NewsCategory? value;
  final ValueChanged<NewsCategory?>? onSelected;

  const CategoryChips({super.key, required this.value, this.onSelected});

  @override
  Widget build(BuildContext context) {
    final cats = NewsCategory.values;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: cats.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (i == 0) {
            final selected = value == null;
            return ChoiceChip(
              label: const Text('All'),
              selected: selected,
              onSelected: (_) => onSelected?.call(null),
            );
          }
          final c = cats[i - 1];
          final selected = value == c;
          final text = c.name[0].toUpperCase() + c.name.substring(1);
          return ChoiceChip(
            label: Text(text),
            selected: selected,
            onSelected: (_) => onSelected?.call(c),
          );
        },
      ),
    );
  }
}
