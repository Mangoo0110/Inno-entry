import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class PinDots extends StatelessWidget {
  const PinDots({
    super.key,
    required this.pinLength,
    this.dotCount = 6,
    this.activeSize = 13,
    this.inactiveSize = 9,
    this.spacing = 6,
  });

  final int pinLength;
  final int dotCount;
  final double activeSize;
  final double inactiveSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        final isFilled = index < pinLength;
        final size = isFilled ? activeSize : inactiveSize;

        return AnimatedScale(
          scale: isFilled ? 1 : 0.92,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            width: size,
            height: size,
            margin: EdgeInsets.symmetric(horizontal: spacing),
            decoration: BoxDecoration(
              color: isFilled ? colors.primaryColor : colors.softGrey,
              shape: BoxShape.circle,
              border: isFilled
                  ? null
                  : Border.all(color: colors.enabledBorderColor, width: 1),
            ),
          ),
        );
      }),
    );
  }
}
