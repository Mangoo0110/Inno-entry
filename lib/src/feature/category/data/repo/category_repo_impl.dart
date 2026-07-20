import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/async_handlers/response.dart';
import 'package:inno_entry/src/core/error_handler/error_handler.dart';
import 'package:inno_entry/src/feature/category/data/model/entry_category_model.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/category/domain/repo/category_repo.dart';

base class CategoryRepoImpl with ErrorHandler implements CategoryRepo {
  const CategoryRepoImpl();

  static const _categories = [
    EntryCategoryModel(name: 'All'),
    EntryCategoryModel(name: 'Personal'),
    EntryCategoryModel(name: 'Work'),
    EntryCategoryModel(name: 'Bills'),
    EntryCategoryModel(name: 'Food'),
    EntryCategoryModel(name: 'Travel'),
  ];

  @override
  AsyncRequest<List<EntryCategory>> getCategories() {
    return asyncTryCatch(
      tryFunc: () async {
        return const SuccessRepoCall(data: _categories);
      },
    );
  }
}
