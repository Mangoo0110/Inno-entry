import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/account.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';

final class GetAccounts implements AsyncUsecase<List<Account>, NoParams> {
  const GetAccounts(this._repo);

  final AuthRepo _repo;

  @override
  AsyncRequest<List<Account>> call(NoParams params) {
    return _repo.accounts();
  }
}
