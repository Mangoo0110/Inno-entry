import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class EntryEmptyFeed extends StatelessWidget {
  const EntryEmptyFeed({super.key, this.message = 'No entries yet'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 34,
              color: colors.borderColor,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.grey,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
