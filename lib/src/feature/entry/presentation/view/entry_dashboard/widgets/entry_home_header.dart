import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_amount_badge.dart';

class EntryHomeHeader extends StatelessWidget {
  const EntryHomeHeader({
    super.key,
    required this.accountName,
    required this.monthAmount,
    required this.syncLabel,
    this.onThemePressed,
    this.onAccountPressed,
  });

  final String accountName;
  final double monthAmount;
  final String syncLabel;
  final VoidCallback? onThemePressed;
  final VoidCallback? onAccountPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'InnoEntry',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  accountName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.grey,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    EntryAmountBadge(amount: monthAmount),
                    _EntrySyncLabel(label: syncLabel),
                  ],
                ),
              ],
            ),
          ),
          _EntryHeaderIconButton(
            tooltip: 'Toggle theme',
            icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            onPressed: onThemePressed,
          ),
          _EntryHeaderIconButton(
            tooltip: 'Account menu',
            icon: Icons.account_circle_outlined,
            onPressed: onAccountPressed,
          ),
        ],
      ),
    );
  }
}

class _EntrySyncLabel extends StatelessWidget {
  const _EntrySyncLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.sync_rounded, size: 12, color: colors.grey),
        const SizedBox(width: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.grey,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _EntryHeaderIconButton extends StatelessWidget {
  const _EntryHeaderIconButton({
    required this.tooltip,
    required this.icon,
    this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return SizedBox.square(
      dimension: 36,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        color: colors.iconColor,
        icon: Icon(icon, size: 22),
      ),
    );
  }
}
