import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/account.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
abstract class AccountModel extends Account with _$AccountModel {
  const AccountModel._() : super();

  const factory AccountModel({required String uniqueName, String? token}) =
      _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}
