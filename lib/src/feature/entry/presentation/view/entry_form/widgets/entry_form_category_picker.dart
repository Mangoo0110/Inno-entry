import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';

class EntryFormCategoryPicker extends StatelessWidget {
  const EntryFormCategoryPicker({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<EntryCategory> categories;
  final String selectedCategory;
  final ValueChanged<EntryCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final visibleCategories = categories
        .where((category) => category.name.toLowerCase() != 'all')
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final category in visibleCategories)
              _EntryFormCategoryChip(
                label: category.name,
                isSelected: _isSameCategory(category.name, selectedCategory),
                onTap: () => onSelected(category),
              ),
          ],
        ),
      ],
    );
  }

  bool _isSameCategory(String left, String right) {
    return left.trim().toLowerCase() == right.trim().toLowerCase();
  }
}

class _EntryFormCategoryChip extends StatelessWidget {
  const _EntryFormCategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Material(
      color: isSelected ? colors.secondaryColor : colors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? colors.secondaryColor : colors.borderColor,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 58, minHeight: 34),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected) ...[
                  Icon(Icons.done_rounded, size: 15, color: colors.textColor),
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colors.textColor,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
