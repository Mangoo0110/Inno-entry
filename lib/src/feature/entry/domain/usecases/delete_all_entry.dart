import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_all_entry.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

final class DeleteAllEntry implements AsyncUsecase<void, DeleteAllEntryParam> {
  const DeleteAllEntry(this._repo);

  final EntryRepo _repo;

  @override
  AsyncRequest<void> call(DeleteAllEntryParam params) {
    return _repo.deleteAllEntry(params: params);
  }
}
