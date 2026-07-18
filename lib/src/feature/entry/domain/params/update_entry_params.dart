import '../entities/entry_uid.dart';

class UpdateEntryParams {
  final EntryUid uId;
  /// Unique account signature e.g, account name, uid
  final String owner;
  final String? title;
  final String? note;
  final double? amount;
  final String? category;
  final bool? done;
  final String? photoPath;

  UpdateEntryParams({
    required this.uId,
    required this.owner,
    this.title,
    this.note,
    this.amount,
    this.category,
    this.done,
    this.photoPath,
  });
}

class MarkDoneParam extends UpdateEntryParams {
  MarkDoneParam({required super.uId, required super.owner}): super(done: true);
}


