import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';

class CategoryChipRow extends StatelessWidget {
  const CategoryChipRow({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
    this.height = 36,
  });

  final List<EntryCategory> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelectCategory;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryFilter = _filterValueFor(category.name);
          final isSelected = categoryFilter == selectedCategory;

          return _CategoryChip(
            label: category.name,
            isSelected: isSelected,
            onTap: () => onSelectCategory(categoryFilter),
          );
        },
      ),
    );
  }

  String? _filterValueFor(String category) {
    final value = category.trim();
    if (value.toLowerCase() == 'all') return null;
    return value;
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
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
    final isDark = Theme.brightnessOf(context) == Brightness.dark;
    final selectedColor = isDark ? colors.primaryColor : colors.textColor;
    final unselectedColor = isDark ? colors.grey : colors.textColor;
    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      color: isSelected ? selectedColor : unselectedColor,
      height: 1,
      overflow: TextOverflow.visible,
    );

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
          constraints: const BoxConstraints(minWidth: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Icon(Icons.done, size: 16, color: selectedColor),
                  const SizedBox(width: 4),
                ],
                Text(label, style: textStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
