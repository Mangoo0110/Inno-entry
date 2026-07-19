import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/entry/presentation/widgets/entry_delete_button.dart';

class EntryDetailAppBar extends StatelessWidget {
  const EntryDetailAppBar({
    super.key,
    required this.title,
    required this.onEditPressed,
    required this.onDeletePressed,
    this.onBackPressed,
    this.isDeleting = false,
  });

  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 10, 0),
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
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
            _EntryDetailIconButton(
              tooltip: 'Edit entry',
              icon: Icons.edit_rounded,
              onPressed: onEditPressed,
            ),
            EntryDeleteButton(
              onPressed: isDeleting ? null : onDeletePressed,
              color: colors.textColor,
              dimension: 42,
              iconSize: 24,
              isProcessing: isDeleting,
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryDetailIconButton extends StatelessWidget {
  const _EntryDetailIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return SizedBox.square(
      dimension: 42,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        color: colors.textColor,
        icon: Icon(icon, size: 24),
      ),
    );
  }
}
