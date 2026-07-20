final class GetEntryTotalAmountParams {
  GetEntryTotalAmountParams({
    required this.owner,
    required DateTime dateFrom,
    required DateTime dateTo,
  }) : dateFrom = dateFrom.toUtc(),
       dateTo = dateTo.toUtc() {
    if (!this.dateFrom.isBefore(this.dateTo)) {
      throw ArgumentError.value(
        dateTo,
        'dateTo',
        'dateTo must be after dateFrom.',
      );
    }
  }

  factory GetEntryTotalAmountParams.today({
    required String owner,
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    return GetEntryTotalAmountParams(
      owner: owner,
      dateFrom: startOfToday,
      dateTo: startOfToday.add(const Duration(days: 1)),
    );
  }

  factory GetEntryTotalAmountParams.thisMonth({
    required String owner,
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();
    final startOfMonth = DateTime(today.year, today.month);
    final startOfNextMonth = DateTime(today.year, today.month + 1);
    return GetEntryTotalAmountParams(
      owner: owner,
      dateFrom: startOfMonth,
      dateTo: startOfNextMonth,
    );
  }

  final String owner;
  final DateTime dateFrom;
  final DateTime dateTo;
}
