import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';

class DeleteEntryParam {
  final EntryUid id;
  final String owner;

  DeleteEntryParam({required this.id, required this.owner});
}