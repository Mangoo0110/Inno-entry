import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class EntryDeleteButton extends StatelessWidget {
  const EntryDeleteButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'Delete entry',
    this.color,
    this.dimension,
    this.iconSize = 20,
    this.isProcessing = false,
  });

  final VoidCallback? onPressed;
  final String tooltip;
  final Color? color;
  final double? dimension;
  final double iconSize;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final button = IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onPressed: isProcessing ? null : onPressed,
      color: color ?? colors.grey,
      icon: isProcessing
          ? SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.primaryColor,
              ),
            )
          : Icon(Icons.delete_outline_rounded, size: iconSize),
    );

    final size = dimension;
    if (size == null) return button;

    return SizedBox.square(dimension: size, child: button);
  }
}

void showEntryDeletedSnackBar(
  BuildContext context, {
  String message = 'Entry deleted',
  String? actionLabel,
  VoidCallback? onActionPressed,
}) {
  final messenger = ScaffoldMessenger.of(context);

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        elevation: 0,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF263031),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(width: 12),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(44, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: const Color(0xFF4FD3D8),
                  textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  onActionPressed();
                },
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
}
