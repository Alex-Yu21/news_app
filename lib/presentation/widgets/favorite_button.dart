import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      buildWhen: (p, n) => p.ids != n.ids,
      builder: (context, state) {
        final isFav = state.ids.contains(article.url);
        return IconButton(
          onPressed: () => context.read<FavoritesCubit>().toggle(article),
          icon: SvgPicture.asset(
            isFav ? 'assets/icons/star_pressed.svg' : 'assets/icons/star.svg',
            width: width,
            height: height,
          ),
          splashRadius: (width > height ? width : height) / 2,
        );
      },
    );
  }
}
