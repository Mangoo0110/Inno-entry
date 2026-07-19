import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_amount_badge.dart';
import 'package:inno_entry/src/previews/entry_dashboard_preview_data.dart';

@Preview(name: 'Amount badge', size: Size(180, 72))
Widget entryAmountBadgePreview() {
  return const EntryPreviewFrame(child: EntryAmountBadge(amount: 1247.80));
}

@Preview(
  name: 'Amount badge - dark',
  brightness: Brightness.dark,
  size: Size(180, 72),
)
Widget entryAmountBadgeDarkPreview() {
  return const EntryPreviewFrame(
    brightness: Brightness.dark,
    child: EntryAmountBadge(amount: 1247.80),
  );
}
