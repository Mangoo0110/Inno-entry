import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';

final class DeleteCurrentAccount implements AsyncUsecase<AuthStatus, NoParams> {
  const DeleteCurrentAccount(this._repo);

  final AuthRepo _repo;

  @override
  AsyncRequest<AuthStatus> call(NoParams params) {
    return _repo.deleteCurrentAccount();
  }
}
