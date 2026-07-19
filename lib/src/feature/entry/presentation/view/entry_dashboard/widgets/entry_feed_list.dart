import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_feed_tile.dart';

class EntryFeedList extends StatelessWidget {
  const EntryFeedList({
    super.key,
    required this.entries,
    this.onEntryPressed,
    this.onDeleteEntry,
  });

  final List<EntryBrief> entries;
  final ValueChanged<EntryBrief>? onEntryPressed;
  final ValueChanged<EntryBrief>? onDeleteEntry;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return SliverPadding(
      padding: const EdgeInsets.only(top: 8, bottom: 92),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
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
        }, childCount: entries.isEmpty ? 0 : entries.length * 2 - 1),
      ),
    );
  }
}
