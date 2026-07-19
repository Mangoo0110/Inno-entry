import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';

final class EntryCategoryModel implements EntryCategory {
  const EntryCategoryModel({required this.name});

  @override
  final String name;
}
