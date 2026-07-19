import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';

class GetEntryDetailsParams {
  final EntryUid id;
  final String owner;

  GetEntryDetailsParams({required this.id, required this.owner});
}