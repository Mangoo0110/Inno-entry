import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';

final class IsAccountNameAvailable implements AsyncUsecase<bool, String> {
  const IsAccountNameAvailable(this._repo);

  final AuthRepo _repo;

  @override
  AsyncRequest<bool> call(String params) {
    return _repo.isAccountNameAvailable(params);
  }
}
