import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class EntryCategoryIcon extends StatelessWidget {
  const EntryCategoryIcon({
    super.key,
    required this.category,
    this.size = 48,
    this.iconSize = 22,
  });

  final String category;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final icon = _EntryCategoryVisual.fromCategory(category).icon;

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.tileColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, color: colors.primaryColor, size: iconSize),
        ),
      ),
    );
  }
}

final class _EntryCategoryVisual {
  const _EntryCategoryVisual({required this.icon});

  final IconData icon;

  static _EntryCategoryVisual fromCategory(String value) {
    return switch (value.trim().toLowerCase()) {
      'personal' => const _EntryCategoryVisual(
        icon: Icons.person_outline_rounded,
      ),
      'work' => const _EntryCategoryVisual(icon: Icons.work_outline_rounded),
      'bill' ||
      'bills' => const _EntryCategoryVisual(icon: Icons.receipt_long_outlined),
      'food' => const _EntryCategoryVisual(icon: Icons.restaurant_menu_rounded),
      'travel' => const _EntryCategoryVisual(
        icon: Icons.flight_takeoff_rounded,
      ),
      _ => const _EntryCategoryVisual(icon: Icons.edit_note_rounded),
    };
  }
}
