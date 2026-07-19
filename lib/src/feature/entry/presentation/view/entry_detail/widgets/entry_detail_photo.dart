import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class EntryDetailPhoto extends StatelessWidget {
  const EntryDetailPhoto({super.key, this.photoPath});

  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final path = photoPath;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1.52,
        child: path == null || path.isEmpty
            ? _EntryDetailPhotoPlaceholder(colors: colors)
            : Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _EntryDetailPhotoPlaceholder(colors: colors);
                },
              ),
      ),
    );
  }
}

class _EntryDetailPhotoPlaceholder extends StatelessWidget {
  const _EntryDetailPhotoPlaceholder({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _EntryDetailPhotoPlaceholderPainter(
        backgroundColor: colors.tileColor,
        stripeColor: colors.backgroundColor.withAlpha(110),
      ),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.backgroundColor.withAlpha(230),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'photo',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.grey,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EntryDetailPhotoPlaceholderPainter extends CustomPainter {
  const _EntryDetailPhotoPlaceholderPainter({
    required this.backgroundColor,
    required this.stripeColor,
  });

  final Color backgroundColor;
  final Color stripeColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = backgroundColor);

    final paint = Paint()
      ..color = stripeColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    for (var x = -size.height; x < size.width; x += 24) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _EntryDetailPhotoPlaceholderPainter oldDelegate,
  ) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.stripeColor != stripeColor;
  }
}
