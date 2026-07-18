import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entries_params.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

final class GetEntries implements AsyncUsecase<List<Entry>, GetEntriesParams> {
  const GetEntries(this._repo);

  final EntryRepo _repo;

  @override
  AsyncRequest<List<Entry>> call(GetEntriesParams params) {
    return _repo.getEntries(params: params);
  }
}
