import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_all_entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_entry_param.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entries_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_details_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/new_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/restore_deleted_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/update_entry_params.dart';

import '../entities/entry_brief.dart';

abstract interface class EntryRepo {
  AsyncRequest<Entry> addNewEntry({required NewEntryParams params});

  AsyncRequest<Entry> updateEntry({required UpdateEntryParams params});

  AsyncRequest<void> deleteEntry({required DeleteEntryParam params});

  AsyncRequest<Entry> restoreDeletedEntry({
    required RestoreDeletedEntryParams params,
  });

  AsyncRequest<void> deleteAllEntry({required DeleteAllEntryParam params});

  AsyncRequest<Entry> getEntryDetails({required GetEntryDetailsParams params});

  AsyncRequest<List<EntryBrief>> getEntries({required GetEntriesParams params});
}
