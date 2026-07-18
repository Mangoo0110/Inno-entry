import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';

class DeleteEntryParam {
  final EntryUid uId;
  final String owner;

  DeleteEntryParam({required this.uId, required this.owner});
}