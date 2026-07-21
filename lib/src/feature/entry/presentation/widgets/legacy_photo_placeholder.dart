import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class LegacyPhotoPlaceholder extends StatelessWidget {
  const LegacyPhotoPlaceholder({
    super.key,
    required this.colors,
    this.gap = 24,
    this.child,
  });

  final AppColors colors;
  final double gap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LegacyPhotoPlaceholderPainter(
        backgroundColor: colors.tileColor,
        stripeColor: colors.backgroundColor.withAlpha(110),
        gap: gap,
      ),
      child: child,
    );
  }
}

class _LegacyPhotoPlaceholderPainter extends CustomPainter {
  const _LegacyPhotoPlaceholderPainter({
    required this.backgroundColor,
    required this.stripeColor,
    required this.gap,
  });

  final Color backgroundColor;
  final Color stripeColor;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = backgroundColor);

    final paint = Paint()
      ..color = stripeColor
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    for (var x = -size.height; x < size.width; x += gap) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LegacyPhotoPlaceholderPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.stripeColor != stripeColor ||
        oldDelegate.gap != gap;
  }
}
