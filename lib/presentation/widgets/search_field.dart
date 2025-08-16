import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/app/theme/app_icons.dart';
import 'package:news_app/app/theme/app_sizes.dart';
import 'package:news_app/app/theme/app_text.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.appText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: AppSizes.iconM,
          height: AppSizes.iconM,
          child: Center(
            child: SvgPicture.asset(
              AppIcons.search,
              width: AppSizes.iconM,
              height: AppSizes.iconM,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            onChanged: onChanged,
            textAlignVertical: TextAlignVertical.center,
            cursorHeight: AppSizes.iconM,
            textInputAction: TextInputAction.search,
            style: t.body,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: '',
            ),
            enableSuggestions: false,
            inputFormatters: const <TextInputFormatter>[],
          ),
        ),
      ],
    );
  }
}
