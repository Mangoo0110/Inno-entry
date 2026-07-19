import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/sections/all_entries_view_section.dart';
import 'package:inno_entry/src/previews/entry_dashboard_preview_data.dart';

@Preview(name: 'All entries section', size: Size(393, 852))
Widget allEntriesViewSectionPreview() {
  return EntryPreviewFrame(
    width: 393,
    height: 852,
    center: false,
    child: SafeArea(
      child: AllEntriesViewSection(
        accountName: 'Rahul Sharma',
        monthAmount: 1247.80,
        syncLabel: 'synced 3s ago',
        categories: entryPreviewCategories,
        selectedCategory: 'All',
        entries: entryPreviewEntries,
        onCategorySelected: (_) {},
        onSearchChanged: (_) {},
        onSearchSubmitted: (_) {},
        onThemePressed: () {},
        onAccountPressed: () {},
        onEntryPressed: (_) {},
        onDeleteEntry: (_) {},
        onAddEntry: () {},
      ),
    ),
  );
}

@Preview(
  name: 'All entries section - dark',
  brightness: Brightness.dark,
  size: Size(393, 852),
)
Widget allEntriesViewSectionDarkPreview() {
  return EntryPreviewFrame(
    brightness: Brightness.dark,
    width: 393,
    height: 852,
    center: false,
    child: SafeArea(
      child: AllEntriesViewSection(
        accountName: 'Rahul Sharma',
        monthAmount: 1247.80,
        syncLabel: 'synced 3s ago',
        categories: entryPreviewCategories,
        selectedCategory: 'All',
        entries: entryPreviewEntries,
        onCategorySelected: (_) {},
        onSearchChanged: (_) {},
        onSearchSubmitted: (_) {},
        onThemePressed: () {},
        onAccountPressed: () {},
        onEntryPressed: (_) {},
        onDeleteEntry: (_) {},
        onAddEntry: () {},
      ),
    ),
  );
}

@Preview(name: 'All entries section - empty', size: Size(393, 852))
Widget allEntriesViewSectionEmptyPreview() {
  return EntryPreviewFrame(
    width: 393,
    height: 852,
    center: false,
    child: SafeArea(
      child: AllEntriesViewSection(
        accountName: 'Rahul Sharma',
        monthAmount: 0,
        syncLabel: 'synced 3s ago',
        categories: entryPreviewCategories,
        selectedCategory: 'All',
        entries: const [],
        onCategorySelected: (_) {},
        onAddEntry: () {},
      ),
    ),
  );
}
