import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';

sealed class EntryDetailResult {
  const EntryDetailResult();
}

final class EntryDetailSaved extends EntryDetailResult {
  const EntryDetailSaved();
}

final class EntryDetailDeleted extends EntryDetailResult {
  const EntryDetailDeleted(this.entry);

  final Entry entry;
}
