import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';

abstract class Entry {
  EntryUid get uId;
  /// Unique Account signature
  String get owner;
  String get title;
  String get note;
  double? get amount;
  String get category;
  bool get done;
  String? get photoPath;
  DateTime get createdAt;
  DateTime get updatedAt;
}
