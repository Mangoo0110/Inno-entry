import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_category_chip_row.dart';
import 'package:inno_entry/src/previews/entry_dashboard_preview_data.dart';

@Preview(name: 'Category chip row', size: Size(360, 76))
Widget entryCategoryChipRowPreview() {
  return EntryPreviewFrame(
    child: EntryCategoryChipRow(
      categories: entryPreviewCategories,
      selectedCategory: 'All',
      onSelected: (_) {},
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
    child: EntryCategoryChipRow(
      categories: entryPreviewCategories,
      selectedCategory: 'All',
      onSelected: (_) {},
    ),
  );
}
