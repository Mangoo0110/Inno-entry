import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:inno_entry/src/feature/category/presentation/widgets/category_chip_row.dart';
import 'package:inno_entry/src/previews/entry_dashboard_preview_data.dart';

@Preview(name: 'Category chip row', size: Size(360, 76))
Widget entryCategoryChipRowPreview() {
  return EntryPreviewFrame(
    child: CategoryChipRow(
      categories: entryPreviewCategories,
      selectedCategory: null,
      onSelectCategory: (_) {},
    ),
  );
}

@Preview(
  name: 'Category chip row - dark',
  brightness: Brightness.dark,
  size: Size(360, 76),
)
Widget entryCategoryChipRowDarkPreview() {
  return EntryPreviewFrame(
    brightness: Brightness.dark,
    child: CategoryChipRow(
      categories: entryPreviewCategories,
      selectedCategory: null,
      onSelectCategory: (_) {},
    ),
  );
}
