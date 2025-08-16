import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/app/theme/app_icons.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/cubit/favorites_cubit.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.article,
    required this.width,
    required this.height,
  });

  final Article article;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoritesCubit, FavoritesState, bool>(
      selector: (s) => s.ids.contains(article.url),
      builder: (context, isFav) {
        return SizedBox(
          width: width,
          height: height,
          child: IconButton(
            onPressed: () => context.read<FavoritesCubit>().toggle(article),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: (width > height ? width : height) / 2,
            icon: SvgPicture.asset(
              isFav ? AppIcons.starPr : AppIcons.star,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
