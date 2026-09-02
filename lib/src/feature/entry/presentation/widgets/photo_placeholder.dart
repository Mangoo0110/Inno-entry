import 'package:flutter/material.dart';
import 'package:inno_entry/src/feature/entry/presentation/widgets/rectangle_stripe_painter.dart';

import '../../../../core/theme/app_colors.dart';

class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({
    super.key,
    required this.colors,
    this.gap = 24,
    this.child,
  });

  final double gap;
  final Widget? child;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RectangleStripePainter(
        gap: gap,
        backGroundColor: colors.tileColor,
        stripeColor: colors.backgroundColor.withAlpha(110),
      ),
      child: child,
    );
  }
}
