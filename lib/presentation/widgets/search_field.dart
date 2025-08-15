import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/app/theme/app_text.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).extension<AppText>()!;
    return TextField(
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.center,
      cursorHeight: 32,
      textInputAction: TextInputAction.search,
      style: text.body,
      decoration: InputDecoration(
        prefixIcon: SvgPicture.asset(
          'assets/icons/search_icon.svg',
          width: 32,
          height: 32,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      cursorWidth: 1.5,

      enableSuggestions: false,

      inputFormatters: const <TextInputFormatter>[],
    );
  }
}
