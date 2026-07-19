import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/restore_deleted_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

final class RestoreDeletedEntry
    implements AsyncUsecase<Entry, RestoreDeletedEntryParams> {
  const RestoreDeletedEntry(this._repo);

  final EntryRepo _repo;

  @override
  AsyncRequest<Entry> call(RestoreDeletedEntryParams params) {
    return _repo.restoreDeletedEntry(params: params);
  }
}
