import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class EntrySearchField extends StatelessWidget {
  const EntrySearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search entries',
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 44,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 20,
              color: colors.grey,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 38,
              minHeight: 40,
            ),
          ),
        ),
      ),
    );
  }
}
