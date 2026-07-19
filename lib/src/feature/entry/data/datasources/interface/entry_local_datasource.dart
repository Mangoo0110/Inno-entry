import 'package:inno_entry/src/feature/entry/data/models/entry_brief_model.dart';
import 'package:inno_entry/src/feature/entry/data/models/entry_model.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_all_entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_entry_param.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entries_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_details_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/new_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/restore_deleted_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/update_entry_params.dart';

abstract interface class EntryLocalDatasource {
  Future<void> init();

  Future<void> dispose();

  Future<EntryModel> addNewEntry({required NewEntryParams params});

  Future<EntryModel> updateEntry({required UpdateEntryParams params});

  Future<void> deleteEntry({required DeleteEntryParam params});

  Future<EntryModel> restoreDeletedEntry({
    required RestoreDeletedEntryParams params,
  });

  Future<void> deleteAllEntry({required DeleteAllEntryParam params});

  Future<EntryModel> getEntryDetails({required GetEntryDetailsParams params});

  Future<List<EntryBriefModel>> getEntries({required GetEntriesParams params});
}
