import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/update_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

final class UpdateEntry implements AsyncUsecase<Entry, UpdateEntryParams> {
  const UpdateEntry(this._repo);

  final EntryRepo _repo;

  @override
  AsyncRequest<Entry> call(UpdateEntryParams params) {
    return _repo.updateEntry(params: params);
  }
}
