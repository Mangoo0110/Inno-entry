// import 'package:flutter/material.dart';
// import 'package:flutter/widget_previews.dart';
// import 'package:inno_entry/src/core/theme/app_colors.dart';
// import 'package:inno_entry/src/feature/entry/presentation/widgets/legacy_photo_placeholder.dart';
// import 'package:inno_entry/src/feature/entry/presentation/widgets/photo_placeholder.dart';
// import 'package:inno_entry/src/previews/entry_dashboard_preview_data.dart';

// @Preview(name: 'Photo placeholder comparison', size: Size(360, 220))
// Widget photoPlaceholderComparisonPreview() {
//   return const EntryPreviewFrame(
//     width: 320,
//     child: _PhotoPlaceholderComparison(),
//   );
// }

// @Preview(
//   name: 'Photo placeholder comparison - dark',
//   brightness: Brightness.dark,
//   size: Size(360, 220),
// )
// Widget photoPlaceholderComparisonDarkPreview() {
//   return const EntryPreviewFrame(
//     brightness: Brightness.dark,
//     width: 320,
//     child: _PhotoPlaceholderComparison(),
//   );
// }

// class _PhotoPlaceholderComparison extends StatelessWidget {
//   const _PhotoPlaceholderComparison();

//   @override
//   Widget build(BuildContext context) {
//     final colors = AppColors.context(context);

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // _PlaceholderSample(
//         //   label: 'Legacy',
//         //   child: LegacyPhotoPlaceholder(colors: colors),
//         // ),
//         _PlaceholderSample(
//           label: 'Current',
//           child: PhotoPlaceholder(colors: colors, gap: 24),
//         ),
//       ],
//     );
//   }
// }

// class _PlaceholderSample extends StatelessWidget {
//   const _PlaceholderSample({required this.label, required this.child});

//   final String label;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     final colors = AppColors.context(context);

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.labelMedium?.copyWith(
//             color: colors.labelColor,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 8),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: SizedBox(width: 144, height: 112, child: child),
//         ),
//       ],
//     );
//   }
// }
