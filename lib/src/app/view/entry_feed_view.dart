import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/category/presentation/widgets/category_chip_row.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_empty_feed.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_feed_list.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_home_header.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_search_field.dart';

/// Preview purpose only
class EntryFeedView extends StatelessWidget {
  const EntryFeedView({
    super.key,
    required this.accountName,
    required this.monthAmount,
    required this.syncLabel,
    required this.categoriesFuture,
    required this.selectedCategory,
    required this.entries,
    required this.onCategorySelected,
    this.scrollController,
    this.isPageLoading = false,
    this.hasReachedMax = false,
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
  final Future<List<EntryCategory>> categoriesFuture;
  final String? selectedCategory;
  final List<EntryBrief> entries;
  final ValueChanged<String?> onCategorySelected;
  final ScrollController? scrollController;
  final bool isPageLoading;
  final bool hasReachedMax;
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
          controller: scrollController,
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
              child: _EntryCategoryFutureRow(
                categoriesFuture: categoriesFuture,
                selectedCategory: selectedCategory,
                onCategorySelected: onCategorySelected,
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
                isPageLoading: isPageLoading,
                hasReachedMax: hasReachedMax,
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

class _EntryCategoryFutureRow extends StatelessWidget {
  const _EntryCategoryFutureRow({
    required this.categoriesFuture,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final Future<List<EntryCategory>> categoriesFuture;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EntryCategory>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        final categories = snapshot.data ?? const <EntryCategory>[];
        if (categories.isEmpty) return const SizedBox(height: 36);

        return CategoryChipRow(
          categories: categories,
          selectedCategory: selectedCategory,
          onSelectCategory: onCategorySelected,
        );
      },
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
        child: const Icon(Icons.add_rounded, size: 24, weight: 2),
      ),
    );
  }
}
