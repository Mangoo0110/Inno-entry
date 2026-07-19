import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';

class EntryDetailMetaRow extends StatelessWidget {
  const EntryDetailMetaRow({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Wrap(
      spacing: 12,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _EntryDetailPill(
          label: entry.category,
          backgroundColor: colors.tileColor,
          foregroundColor: colors.textColor,
        ),
        Text(
          _formatDate(entry.createdAt),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (entry.done)
          _EntryDetailPill(
            label: entry.amount == null ? 'Done' : 'Paid',
            icon: Icons.check_rounded,
            backgroundColor: colors.softGrey,
            foregroundColor: colors.textColor,
          ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    final date = dateTime.toLocal();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _EntryDetailPill extends StatelessWidget {
  const _EntryDetailPill({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: colors.primaryColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
