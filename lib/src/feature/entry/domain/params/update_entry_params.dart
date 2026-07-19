import '../entities/entry_uid.dart';

class UpdateEntryParams {
  final EntryUid id;

  /// Unique account signature e.g, account name, uid
  final String owner;
  final String? title;
  final String? note;
  final double? amount;
  final String? category;
  final bool? done;
  final String? photoPath;
  final bool clearPhotoPath;

  UpdateEntryParams({
    required this.id,
    required this.owner,
    this.title,
    this.note,
    this.amount,
    this.category,
    this.done,
    this.photoPath,
    this.clearPhotoPath = false,
  });
}

class MarkDoneParam extends UpdateEntryParams {
  MarkDoneParam({required super.id, required super.owner}) : super(done: true);
}
