import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';

import 'entry_model.dart';

final class EntryBriefModel implements EntryBrief {
  const EntryBriefModel({
    required this.uId,
    required this.title,
    required this.note,
    required this.amount,
    required this.category,
    required this.done,
    required this.photoPath,
    required this.updatedAt,
  });

  factory EntryBriefModel.fromEntry(Entry entry) {
    return EntryBriefModel(
      uId: entry.uId,
      title: entry.title,
      note: entry.note,
      amount: entry.amount,
      category: entry.category,
      done: entry.done,
      photoPath: entry.photoPath,
      updatedAt: entry.updatedAt,
    );
  }

  factory EntryBriefModel.fromDb(Map<String, Object?> map) {
    return EntryBriefModel(
      uId: EntryUid(uId: map[EntryModelFields.id] as int),
      title: map[EntryModelFields.title] as String,
      note: map[EntryModelFields.note] as String? ?? '',
      amount: (map[EntryModelFields.amount] as num?)?.toDouble(),
      category: map[EntryModelFields.category] as String,
      done: (map[EntryModelFields.done] as int) == 1,
      photoPath: map[EntryModelFields.photoPath] as String?,
      updatedAt: DateTime.parse(map[EntryModelFields.updatedAt] as String),
    );
  }

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
  final String? photoPath;

  @override
  final DateTime updatedAt;
}
