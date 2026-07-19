import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:inno_entry/src/core/theme/app_theme.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_feed_tile.dart';

@Preview(name: 'Paid food entry', size: Size(360, 110))
Widget entryFeedTilePaidPreview() {
  return _EntryTilePreviewFrame(
    child: EntryFeedTile(
      entry: _PreviewEntryBrief(
        id: 1,
        title: 'Team lunch',
        note: 'Split with design team at Nomi',
        amount: 48,
        category: 'Food',
        done: true,
      ),
    ),
  );
}

@Preview(name: 'Draft work entry', size: Size(360, 110))
Widget entryFeedTileDraftPreview() {
  return _EntryTilePreviewFrame(
    child: EntryFeedTile(
      entry: _PreviewEntryBrief(
        id: 2,
        title: 'Finish quarterly report',
        note: 'Section 3 charts + exec summary draft',
        category: 'Work',
      ),
    ),
  );
}

@Preview(name: 'Travel amount entry', size: Size(360, 110))
Widget entryFeedTileTravelPreview() {
  return _EntryTilePreviewFrame(
    child: EntryFeedTile(
      entry: _PreviewEntryBrief(
        id: 3,
        title: 'Flight to Berlin',
        note: 'Confirm seat + 1 checked bag',
        amount: 312,
        category: 'Travel',
      ),
    ),
  );
}

@Preview(
  name: 'Paid food entry - dark',
  brightness: Brightness.dark,
  size: Size(360, 110),
)
Widget entryFeedTilePaidDarkPreview() {
  return _EntryTilePreviewFrame(
    brightness: Brightness.dark,
    child: EntryFeedTile(
      entry: _PreviewEntryBrief(
        id: 4,
        title: 'Team lunch',
        note: 'Split with design team at Nomi',
        amount: 48,
        category: 'Food',
        done: true,
      ),
    ),
  );
}

class _EntryTilePreviewFrame extends StatelessWidget {
  const _EntryTilePreviewFrame({
    required this.child,
    this.brightness = Brightness.light,
  });

  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme();
    final theme = brightness == Brightness.dark
        ? appTheme.darkTheme
        : appTheme.lightTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: Center(child: SizedBox(width: 360, child: child)),
      ),
    );
  }
}

final class _PreviewEntryBrief implements EntryBrief {
  _PreviewEntryBrief({
    required int id,
    required this.title,
    required this.note,
    required this.category,
    this.amount,
    this.done = false,
    DateTime? updatedAt,
  }) : uId = EntryUid(uId: id),
       updatedAt = updatedAt ?? DateTime.utc(2026, 7, 19);

  @override
  final EntryUid uId;

  @override
  final String title;

  @override
  final String note;

  @override
  final double? amount;

  @override
  final String category;

  @override
  final bool done;

  @override
  String? get photoPath => null;

  @override
  final DateTime updatedAt;
}
