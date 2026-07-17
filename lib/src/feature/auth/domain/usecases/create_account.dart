import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/signup_params.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';

final class CreateAccount implements AsyncUsecase<AuthStatus, SignUpParams> {
  const CreateAccount(this._repo);

  final AuthRepo _repo;

  @override
  AsyncRequest<AuthStatus> call(SignUpParams params) {
    return _repo.createAccount(params: params);
  }
}
