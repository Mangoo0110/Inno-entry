import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';

abstract class EntryBrief {
  EntryUid get uId;
  String get title;
  String get note;
  double? get amount;
  String get category;
  bool get done;
  String? get photoPath;
  DateTime get updatedAt;
}
