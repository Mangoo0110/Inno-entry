import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_amount_badge.dart';

class EntryHomeHeader extends StatelessWidget {
  const EntryHomeHeader({
    super.key,
    required this.accountName,
    required this.monthAmount,
    required this.syncLabel,
    this.isSyncing = false,
    this.lastSyncedAt,
    this.onThemePressed,
    this.onAccountPressed,
  });

  final String accountName;
  final double monthAmount;
  final String syncLabel;
  final bool isSyncing;
  final DateTime? lastSyncedAt;
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
                    _EntrySyncLabel(
                      label: syncLabel,
                      isSyncing: isSyncing,
                      lastSyncedAt: lastSyncedAt,
                    ),
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

class _EntrySyncLabel extends StatefulWidget {
  const _EntrySyncLabel({
    required this.label,
    required this.isSyncing,
    required this.lastSyncedAt,
  });

  final String label;
  final bool isSyncing;
  final DateTime? lastSyncedAt;

  @override
  State<_EntrySyncLabel> createState() => _EntrySyncLabelState();
}

class _EntrySyncLabelState extends State<_EntrySyncLabel> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void didUpdateWidget(covariant _EntrySyncLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lastSyncedAt != widget.lastSyncedAt) {
      _now = DateTime.now();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final label = _label;

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

  String get _label {
    if (widget.isSyncing) return 'syncing...';
    final lastSyncedAt = widget.lastSyncedAt;
    if (lastSyncedAt == null) return widget.label;

    final elapsed = _now.difference(lastSyncedAt);
    if (elapsed.inSeconds < 5) return 'synced just now';
    if (elapsed.inMinutes < 1) return 'synced ${elapsed.inSeconds}s ago';
    if (elapsed.inHours < 1) return 'synced ${elapsed.inMinutes}m ago';
    return 'synced ${elapsed.inHours}h ago';
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
