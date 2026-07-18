import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/new_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

final class AddNewEntry implements AsyncUsecase<Entry, NewEntryParams> {
  const AddNewEntry(this._repo);

  final EntryRepo _repo;

  @override
  AsyncRequest<Entry> call(NewEntryParams params) {
    return _repo.addNewEntry(params: params);
  }
}
