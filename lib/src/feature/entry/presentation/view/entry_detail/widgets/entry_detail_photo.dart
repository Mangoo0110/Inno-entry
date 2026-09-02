import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

import '../../../widgets/photo_placeholder.dart';

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
            ? _placeHolder(colors, context)
            : Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _placeHolder(colors, context);
                },
              ),
      ),
    );
  }

  Widget _placeHolder(AppColors colors, BuildContext context) {
    return PhotoPlaceholder(
        colors: colors,
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

