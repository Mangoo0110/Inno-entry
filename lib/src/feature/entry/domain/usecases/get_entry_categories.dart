import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

final class GetEntryCategories
    implements AsyncUsecase<List<EntryCategory>, NoParams> {
  const GetEntryCategories(this._repo);

  final EntryRepo _repo;

  @override
  AsyncRequest<List<EntryCategory>> call(NoParams params) {
    return _repo.getEntryCategories();
  }
}
