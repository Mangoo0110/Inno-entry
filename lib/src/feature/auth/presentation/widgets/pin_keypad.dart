import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.isLocked,
    required this.onDigitPressed,
  });

  final bool isLocked;
  final ValueChanged<String> onDigitPressed;

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 292.0;
        final keypadWidth = maxWidth.clamp(156.0, 292.0);
        final spacing = (keypadWidth * 0.06).clamp(12.0, 18.0);
        final keyWidth = (keypadWidth - (spacing * 2)) / 3;
        final keyHeight = (keyWidth * 0.78).clamp(44.0, 50.0);

        return SizedBox(
          width: keypadWidth,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: spacing,
            runSpacing: (keyHeight * 0.32).clamp(12.0, 16.0),
            children: [
              for (final key in keys)
                _PinKey(
                  value: key,
                  width: keyWidth,
                  height: keyHeight,
                  isLocked: isLocked,
                  onTap: () => onDigitPressed(key),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({
    required this.value,
    required this.width,
    required this.height,
    required this.isLocked,
    required this.onTap,
  });

  final String value;
  final double width;
  final double height;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Material(
      color: isLocked ? colors.softGrey.withAlpha(130) : colors.softGrey,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: isLocked ? colors.grey : colors.textColor,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
