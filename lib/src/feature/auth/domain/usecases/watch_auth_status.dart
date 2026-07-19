import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';

final class WatchAuthStatus implements StreamUsecase<AuthStatus, NoParams> {
  const WatchAuthStatus(this._repo);

  final AuthRepo _repo;

  @override
  Stream<AuthStatus> call(NoParams params) {
    return _repo.watchAuthStatus();
  }
}
