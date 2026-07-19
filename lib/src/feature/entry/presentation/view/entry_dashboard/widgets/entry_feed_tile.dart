import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_category_icon.dart';

class EntryFeedTile extends StatelessWidget {
  const EntryFeedTile({
    super.key,
    required this.entry,
    this.onTap,
    this.onDelete,
  });

  final EntryBrief entry;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        //borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _EntryFeedTileLeading(entry: entry),
              const SizedBox(width: 12),
              Expanded(
                child: _EntryFeedTileBody(
                  title: entry.title,
                  note: entry.note,
                  tagLabel: _tagLabel,
                ),
              ),
              const SizedBox(width: 12),
              _EntryFeedTileAction(
                amount: entry.amount,
                onDelete: onDelete,
                foregroundColor: colors.textColor,
                mutedColor: colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _tagLabel {
    if (entry.done) return entry.amount == null ? 'Done' : 'Paid';
    return entry.category;
  }
}

class _EntryFeedTileLeading extends StatelessWidget {
  const _EntryFeedTileLeading({required this.entry});

  final EntryBrief entry;

  @override
  Widget build(BuildContext context) {
    final photoPath = entry.photoPath;
    if (photoPath == null || photoPath.isEmpty) {
      return EntryCategoryIcon(category: entry.category);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: SizedBox.square(
        dimension: 44,
        child: Image.file(
          File(photoPath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return EntryCategoryIcon(category: entry.category);
          },
        ),
      ),
    );
  }
}

class _EntryFeedTileBody extends StatelessWidget {
  const _EntryFeedTileBody({
    required this.title,
    required this.note,
    required this.tagLabel,
  });

  final String title;
  final String note;
  final String tagLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final theme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 3,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        if(note.isNotEmpty)Text(
          note,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.bodySmall?.copyWith(color: colors.grey, height: 1.2),
        ),
        _EntryStatusPill(label: tagLabel),
      ],
    );
  }
}

class _EntryStatusPill extends StatelessWidget {
  const _EntryStatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.tileColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.primaryColor,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _EntryFeedTileAction extends StatelessWidget {
  const _EntryFeedTileAction({
    required this.amount,
    required this.onDelete,
    required this.foregroundColor,
    required this.mutedColor,
  });

  final double? amount;
  final VoidCallback? onDelete;
  final Color foregroundColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final value = amount;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (value != null && value > 0)
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 56),
            child: Text(
              '\$${value.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        IconButton(
          tooltip: 'Delete entry',
          visualDensity: VisualDensity.compact,
          onPressed: onDelete,
          color: mutedColor,
          icon: const Icon(Icons.delete_outline_rounded, size: 20),
        ),
      ],
    );
  }
}
