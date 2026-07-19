import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';

class EntryCategoryChipRow extends StatelessWidget {
  const EntryCategoryChipRow({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    this.height = 36,
  });

  final List<EntryCategory> categories;
  final String selectedCategory;
  final ValueChanged<EntryCategory> onSelected;
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
          final isSelected = _isSameCategory(category.name, selectedCategory);

          return _EntryCategoryChip(
            label: category.name,
            isSelected: isSelected,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }

  bool _isSameCategory(String left, String right) {
    return left.trim().toLowerCase() == right.trim().toLowerCase();
  }
}

class _EntryCategoryChip extends StatelessWidget {
  const _EntryCategoryChip({
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
    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      color: isSelected ? 
        (Theme.brightnessOf(context) == Brightness.dark ? colors.primaryColor : colors.textColor)
        : (Theme.brightnessOf(context) == Brightness.dark ? colors.grey : colors.textColor),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4,
              children: [
                if(isSelected) Icon(Icons.done, size: 16, color: Theme.brightnessOf(context) == Brightness.dark ? colors.primaryColor: colors.textColor,),
                Text(label, style: textStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
