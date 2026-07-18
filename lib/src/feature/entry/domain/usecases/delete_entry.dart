import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_entry_param.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

final class DeleteEntry implements AsyncUsecase<void, DeleteEntryParam> {
  const DeleteEntry(this._repo);

  final EntryRepo _repo;

  @override
  AsyncRequest<void> call(DeleteEntryParam params) {
    return _repo.deleteEntry(params: params);
  }
}
