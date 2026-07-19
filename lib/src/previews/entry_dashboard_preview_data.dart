import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_theme.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';

class EntryPreviewFrame extends StatelessWidget {
  const EntryPreviewFrame({
    super.key,
    required this.child,
    this.brightness = Brightness.light,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.center = true,
  });

  final Widget child;
  final Brightness brightness;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme();
    final theme = brightness == Brightness.dark
        ? appTheme.darkTheme
        : appTheme.lightTheme;
    final preview = Padding(
      padding: padding,
      child: SizedBox(width: width, height: height, child: child),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(body: center ? Center(child: preview) : preview),
    );
  }
}

final class EntryPreviewCategory implements EntryCategory {
  const EntryPreviewCategory(this.name);

  @override
  final String name;
}

final class EntryPreviewBrief implements EntryBrief {
  EntryPreviewBrief({
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

const entryPreviewCategories = [
  EntryPreviewCategory('All'),
  EntryPreviewCategory('Personal'),
  EntryPreviewCategory('Work'),
  EntryPreviewCategory('Bills'),
  EntryPreviewCategory('Food'),
  EntryPreviewCategory('Travel'),
];

final entryPreviewEntries = [
  EntryPreviewBrief(
    id: 1,
    title: 'Team lunch',
    note: 'Split with design team at Nomi',
    amount: 48,
    category: 'Food',
    done: true,
  ),
  EntryPreviewBrief(
    id: 2,
    title: 'Finish quarterly report',
    note: 'Section 3 charts + exec summary draft',
    category: 'Work',
  ),
  EntryPreviewBrief(
    id: 3,
    title: 'Electric bill',
    note: 'Due Jul 15 - autopay off',
    amount: 126.40,
    category: 'Bills',
  ),
  EntryPreviewBrief(
    id: 4,
    title: 'Call plumber',
    note: 'Leaking tap in kitchen',
    category: 'Personal',
    done: true,
  ),
  EntryPreviewBrief(
    id: 5,
    title: 'Flight to Berlin',
    note: 'Confirm seat + 1 checked bag',
    amount: 312,
    category: 'Travel',
  ),
];
