import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_category_chip_row.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_empty_feed.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_feed_list.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_home_header.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_search_field.dart';

class EntryFeedView extends StatelessWidget {
  const EntryFeedView({
    super.key,
    required this.accountName,
    required this.monthAmount,
    required this.syncLabel,
    required this.categories,
    required this.selectedCategory,
    required this.entries,
    required this.onCategorySelected,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onThemePressed,
    this.onAccountPressed,
    this.onEntryPressed,
    this.onDeleteEntry,
    this.onAddEntry,
  });

  final String accountName;
  final double monthAmount;
  final String syncLabel;
  final List<EntryCategory> categories;
  final String selectedCategory;
  final List<EntryBrief> entries;
  final ValueChanged<EntryCategory> onCategorySelected;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onThemePressed;
  final VoidCallback? onAccountPressed;
  final ValueChanged<EntryBrief>? onEntryPressed;
  final ValueChanged<EntryBrief>? onDeleteEntry;
  final VoidCallback? onAddEntry;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: EntryHomeHeader(
                accountName: accountName,
                monthAmount: monthAmount,
                syncLabel: syncLabel,
                onThemePressed: onThemePressed,
                onAccountPressed: onAccountPressed,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: EntrySearchField(
                controller: searchController,
                onChanged: onSearchChanged,
                onSubmitted: onSearchSubmitted,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: EntryCategoryChipRow(
                categories: categories,
                selectedCategory: selectedCategory,
                onSelected: onCategorySelected,
              ),
            ),
            if (entries.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: EntryEmptyFeed(),
              )
            else
              EntryFeedList(
                entries: entries,
                onEntryPressed: onEntryPressed,
                onDeleteEntry: onDeleteEntry,
              ),
          ],
        ),
        if (onAddEntry != null)
          Positioned(
            right: 16,
            bottom: 20,
            child: _EntryAddButton(onPressed: onAddEntry!),
          ),
      ],
    );
  }
}

class _EntryAddButton extends StatelessWidget {
  const _EntryAddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return SizedBox.square(
      dimension: 60,
      child: FloatingActionButton.large(
        tooltip: 'New entry',
        elevation: 6,
        backgroundColor: colors.primaryColor,
        foregroundColor: colors.activeButtonContentColor,
        onPressed: onPressed,
        child: const Icon(Icons.add_rounded, size: 24, weight: 2,),
      ),
    );
  }
}
