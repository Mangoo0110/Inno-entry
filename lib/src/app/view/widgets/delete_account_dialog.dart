import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    super.key,
    required this.accountName,
    required this.onDeletePressed,
  });

  final String accountName;
  final Future<bool> Function() onDeletePressed;

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 332),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.popupBackgroundColor,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 28, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete account?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colors.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'This permanently removes "${widget.accountName}" and all '
                  'of its entries, photos, and settings from this device. '
                  'Other accounts are not affected.',
                  maxLines: 6,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.textColor.withAlpha(220),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isDeleting
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.primaryColor,
                        textStyle: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isDeleting ? null : _deleteAccount,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(92, 40),
                        backgroundColor: const Color(0xFFC81E1E),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: colors.errorColor.withAlpha(
                          150,
                        ),
                        disabledForegroundColor: Colors.white,
                        textStyle: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      child: _isDeleting
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    setState(() => _isDeleting = true);
    final deleted = await widget.onDeletePressed();
    if (!mounted) return;
    Navigator.of(context).pop(deleted);
  }
}
