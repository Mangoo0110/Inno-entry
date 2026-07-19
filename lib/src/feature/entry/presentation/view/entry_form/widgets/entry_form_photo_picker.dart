import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class EntryFormPhotoPicker extends StatelessWidget {
  const EntryFormPhotoPicker({
    super.key,
    this.photoPath,
    required this.onUploadPhotoPressed,
    this.onRemovePhotoPressed,
  });

  final String? photoPath;
  final VoidCallback onUploadPhotoPressed;
  final VoidCallback? onRemovePhotoPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _EntryUploadedPhotoPreview(photoPath: photoPath),
            if (photoPath != null)
              Positioned(
                right: -1,
                bottom: -1,
                child: SizedBox.square(
                  dimension: 20,
                  child: IconButton(
                    tooltip: 'Remove photo',
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onPressed: onRemovePhotoPressed,
                    color: colors.textColor,
                    icon: const Icon(Icons.close_rounded, size: 15),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        TextButton.icon(
          onPressed: onUploadPhotoPressed,
          icon: Icon(
            Icons.add_photo_alternate_outlined,
            size: 16,
            color: colors.primaryColor,
          ),
          label: Text(photoPath == null ? 'Upload photo' : 'Change photo'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _EntryUploadedPhotoPreview extends StatelessWidget {
  const _EntryUploadedPhotoPreview({required this.photoPath});

  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final path = photoPath;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.square(
        dimension: 56,
        child: path == null || !_isRealFilePath(path)
            ? CustomPaint(
                painter: _EntryPhotoPlaceholderPainter(
                  backgroundColor: colors.tileColor,
                  stripeColor: colors.backgroundColor.withAlpha(100),
                ),
              )
            : Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return CustomPaint(
                    painter: _EntryPhotoPlaceholderPainter(
                      backgroundColor: colors.tileColor,
                      stripeColor: colors.backgroundColor.withAlpha(100),
                    ),
                  );
                },
              ),
      ),
    );
  }

  bool _isRealFilePath(String path) {
    return path.contains(Platform.pathSeparator) ||
        path.startsWith('/') ||
        path.startsWith('file:');
  }
}

class _EntryPhotoPlaceholderPainter extends CustomPainter {
  const _EntryPhotoPlaceholderPainter({
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
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    for (var x = -size.height; x < size.width; x += 13) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EntryPhotoPlaceholderPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.stripeColor != stripeColor;
  }
}
