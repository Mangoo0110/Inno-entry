import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/async_handlers/response.dart';
import 'package:inno_entry/src/core/error_handler/error_handler.dart';
import 'package:inno_entry/src/feature/category/data/model/entry_category_model.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_all_entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_entry_param.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entries_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_details_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/new_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/update_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

import '../datasources/interface/entry_datasources.dart';

base class EntryRepoImpl with ErrorHandler implements EntryRepo {
  const EntryRepoImpl({required this.entryLocalDatasource});

  final EntryLocalDatasource entryLocalDatasource;

  static const _entryCategories = [
    EntryCategoryModel(name: 'All'),
    EntryCategoryModel(name: 'Personal'),
    EntryCategoryModel(name: 'Work'),
    EntryCategoryModel(name: 'Bills'),
    EntryCategoryModel(name: 'Food'),
    EntryCategoryModel(name: 'Travel'),
  ];

  @override
  AsyncRequest<Entry> addNewEntry({required NewEntryParams params}) {
    return asyncTryCatch(
      tryFunc: () async {
        final entry = await entryLocalDatasource.addNewEntry(params: params);
        return SuccessRepoCall(data: entry);
      },
    );
  }

  @override
  AsyncRequest<void> deleteAllEntry({required DeleteAllEntryParam params}) {
    return asyncTryCatch(
      tryFunc: () async {
        await entryLocalDatasource.deleteAllEntry(params: params);
        return const SuccessRepoCall(data: null);
      },
    );
  }

  @override
  AsyncRequest<void> deleteEntry({required DeleteEntryParam params}) {
    return asyncTryCatch(
      tryFunc: () async {
        await entryLocalDatasource.deleteEntry(params: params);
        return const SuccessRepoCall(data: null);
      },
    );
  }

  @override
  AsyncRequest<List<EntryBrief>> getEntries({
    required GetEntriesParams params,
  }) {
    return asyncTryCatch(
      tryFunc: () async {
        final entries = await entryLocalDatasource.getEntries(params: params);
        return SuccessRepoCall(data: entries);
      },
    );
  }

  @override
  AsyncRequest<List<EntryCategory>> getEntryCategories() {
    return asyncTryCatch(
      tryFunc: () async {
        return const SuccessRepoCall(data: _entryCategories);
      },
    );
  }

  @override
  AsyncRequest<Entry> getEntryDetails({required GetEntryDetailsParams params}) {
    return asyncTryCatch(
      tryFunc: () async {
        final entry = await entryLocalDatasource.getEntryDetails(
          params: params,
        );
        return SuccessRepoCall(data: entry);
      },
    );
  }

  @override
  AsyncRequest<Entry> updateEntry({required UpdateEntryParams params}) {
    return asyncTryCatch(
      tryFunc: () async {
        final entry = await entryLocalDatasource.updateEntry(params: params);
        return SuccessRepoCall(data: entry);
      },
    );
  }
}
