import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_total_amount_params.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';

final class GetEntryTotalAmount
    implements AsyncUsecase<double, GetEntryTotalAmountParams> {
  const GetEntryTotalAmount(this._repo);

  final EntryRepo _repo;

  @override
  AsyncRequest<double> call(GetEntryTotalAmountParams params) {
    return _repo.getEntryTotalAmount(params: params);
  }
}
