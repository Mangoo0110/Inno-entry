import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class EntryFormSaveBar extends StatelessWidget {
  const EntryFormSaveBar({
    super.key,
    required this.onPressed,
    this.isSaving = false,
  });

  final VoidCallback onPressed;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        border: Border(top: BorderSide(color: colors.dividerColor)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: isSaving ? null : onPressed,
            child: isSaving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ),
      ),
    );
  }
}
