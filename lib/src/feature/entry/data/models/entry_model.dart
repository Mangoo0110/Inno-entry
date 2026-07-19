import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';

part 'entry_model.freezed.dart';
part 'entry_model.g.dart';

@freezed
abstract class EntryModel extends Entry with _$EntryModel {
  EntryModel._() : super();

  factory EntryModel({
    @JsonKey(
      name: EntryModelFields.id,
      fromJson: EntryModel._entryUidFromJson,
      toJson: EntryModel._entryUidToJson,
    )
    required EntryUid uId,
    required String owner,
    required String title,
    required String note,
    required double? amount,
    required String category,
    required bool done,
    String? photoPath,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EntryModel;

  factory EntryModel.fromJson(Map<String, dynamic> json) =>
      _$EntryModelFromJson(json);

  factory EntryModel.fromDb(Map<String, Object?> map) {
    return EntryModel(
      uId: EntryUid(uId: map[EntryModelFields.id] as int),
      owner: map[EntryModelFields.owner] as String,
      title: map[EntryModelFields.title] as String,
      note: map[EntryModelFields.note] as String? ?? '',
      amount: (map[EntryModelFields.amount] as num?)?.toDouble(),
      category: map[EntryModelFields.category] as String,
      done: (map[EntryModelFields.done] as int) == 1,
      photoPath: map[EntryModelFields.photoPath] as String?,
      createdAt: DateTime.parse(map[EntryModelFields.createdAt] as String),
      updatedAt: DateTime.parse(map[EntryModelFields.updatedAt] as String),
    );
  }

  Map<String, Object?> toDb() {
    return {
      EntryModelFields.id: uId.uId,
      EntryModelFields.owner: owner,
      EntryModelFields.title: title,
      EntryModelFields.note: note,
      EntryModelFields.amount: amount,
      EntryModelFields.category: category,
      EntryModelFields.done: done ? 1 : 0,
      EntryModelFields.photoPath: photoPath,
      EntryModelFields.createdAt: createdAt.toIso8601String(),
      EntryModelFields.updatedAt: updatedAt.toIso8601String(),
    };
  }

  static EntryUid _entryUidFromJson(Object json) {
    if (json is int) {
      return EntryUid(uId: json);
    }
    if (json is String) {
      return EntryUid(uId: int.parse(json));
    }
    throw FormatException('Invalid entry id: $json');
  }

  static int _entryUidToJson(EntryUid uId) => uId.uId;
}

abstract final class EntryModelFields {
  static const tableName = 'entries';

  static const id = 'id';
  static const owner = 'owner';
  static const title = 'title';
  static const note = 'note';
  static const amount = 'amount';
  static const category = 'category';
  static const done = 'done';
  static const photoPath = 'photoPath';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}
