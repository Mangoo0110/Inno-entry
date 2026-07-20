class GetEntriesParams {
  // Unique accoount signature e.g, uId, account name
  final String owner;
  final Filters filters;

  GetEntriesParams({required this.owner, required this.filters});
}

class Filters {
  String? category;
  String search;
  int? page;
  int? limit;

  Filters({
    this.category,
    required this.search,
    required this.page,
    required this.limit,
  });
}
