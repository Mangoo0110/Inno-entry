import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';

abstract interface class CategoryRepo {
  AsyncRequest<List<EntryCategory>> getCategories();
}
