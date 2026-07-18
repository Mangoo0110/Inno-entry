import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_details_params.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

final class GetEntryDetails
    implements AsyncUsecase<Entry, GetEntryDetailsParams> {
  const GetEntryDetails(this._repo);

  final EntryRepo _repo;

  @override
  AsyncRequest<Entry> call(GetEntryDetailsParams params) {
    return _repo.getEntryDetails(params: params);
  }
}
