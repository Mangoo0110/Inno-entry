import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_feed_tile.dart';

class EntryFeedList extends StatelessWidget {
  const EntryFeedList({
    super.key,
    required this.entries,
    this.isPageLoading = false,
    this.hasReachedMax = false,
    this.onLoadMore,
    this.onEntryPressed,
    this.onDeleteEntry,
  });

  final List<EntryBrief> entries;
  final bool isPageLoading;
  final bool hasReachedMax;
  final VoidCallback? onLoadMore;
  final ValueChanged<EntryBrief>? onEntryPressed;
  final ValueChanged<EntryBrief>? onDeleteEntry;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final hasFooter = isPageLoading || hasReachedMax || onLoadMore != null;
    final childCount = entries.isEmpty
        ? 0
        : entries.length * 2 - 1 + (hasFooter ? 1 : 0);

    return SliverPadding(
      padding: const EdgeInsets.only(top: 8, bottom: 92),
      sliver: SliverList.builder(
        itemCount: childCount,
        itemBuilder: (context, index) {
          if (hasFooter && index == childCount - 1) {
            return _EntryFeedFooter(
              isPageLoading: isPageLoading,
              hasReachedMax: hasReachedMax,
              onLoadMore: onLoadMore,
            );
          }

          if (index.isOdd) {
            return Divider(
              height: 1,
              indent: 76,
              endIndent: 16,
              color: colors.dividerColor,
            );
          }

          final entry = entries[index ~/ 2];
          return EntryFeedTile(
            entry: entry,
            onTap: onEntryPressed == null ? null : () => onEntryPressed!(entry),
            onDelete: onDeleteEntry == null
                ? null
                : () => onDeleteEntry!(entry),
          );
        },
      ),
    );
  }
}

class _EntryFeedFooter extends StatelessWidget {
  const _EntryFeedFooter({
    required this.isPageLoading,
    required this.hasReachedMax,
    this.onLoadMore,
  });

  final bool isPageLoading;
  final bool hasReachedMax;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    if (isPageLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasReachedMax) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: Text(
            'All entries loaded',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.grey),
          ),
        ),
      );
    }

    onLoadMore?.call();
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
