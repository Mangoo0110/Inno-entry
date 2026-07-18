import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_params.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';

final class UnlockAccount implements AsyncUsecase<AuthStatus, AuthParams> {
  const UnlockAccount(this._repo);

  final AuthRepo _repo;

  @override
  AsyncRequest<AuthStatus> call(AuthParams params) {
    return _repo.unlockAccount(params: params);
  }
}
