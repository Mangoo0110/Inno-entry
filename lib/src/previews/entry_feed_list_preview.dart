import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_feed_list.dart';
import 'package:inno_entry/src/previews/entry_dashboard_preview_data.dart';

@Preview(name: 'Entry feed list', size: Size(360, 430))
Widget entryFeedListPreview() {
  return EntryPreviewFrame(
    width: 360,
    height: 430,
    child: CustomScrollView(
      slivers: [
        EntryFeedList(
          entries: entryPreviewEntries,
          onEntryPressed: (_) {},
          onDeleteEntry: (_) {},
        ),
      ],
    ),
  );
}

@Preview(
  name: 'Entry feed list - dark',
  brightness: Brightness.dark,
  size: Size(360, 430),
)
Widget entryFeedListDarkPreview() {
  return EntryPreviewFrame(
    brightness: Brightness.dark,
    width: 360,
    height: 430,
    child: CustomScrollView(
      slivers: [
        EntryFeedList(
          entries: entryPreviewEntries,
          onEntryPressed: (_) {},
          onDeleteEntry: (_) {},
        ),
      ],
    ),
  );
}
