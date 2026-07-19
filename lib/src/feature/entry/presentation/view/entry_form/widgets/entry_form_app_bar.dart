import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class EntryFormAppBar extends StatelessWidget {
  const EntryFormAppBar({super.key, required this.title, this.onBackPressed});

  final String title;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 20, 0),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Back',
              onPressed:
                  onBackPressed ?? () => Navigator.of(context).maybePop(),
              color: colors.textColor,
              icon: const Icon(Icons.arrow_back_rounded, size: 26),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
