
class NewEntryParams {
  /// Unique account signature e.g, account name, uid
  final String owner;
  final String title;
  final String note;
  final double amount;
  final String category;
  final bool done;
  final String? photoPath;

  NewEntryParams({
    required this.owner,
    required this.title,
    required this.note,
    required this.amount,
    required this.category,
    required this.done,
    required this.photoPath,
  });
}
