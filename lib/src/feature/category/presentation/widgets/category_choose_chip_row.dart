import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/feature/category/presentation/bloc/category_choose_bloc.dart';
import 'package:inno_entry/src/feature/category/presentation/widgets/category_chip_row.dart';

class CategoryChooseChipRow extends StatelessWidget {
  const CategoryChooseChipRow({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  final String? selectedCategory;
  final ValueChanged<String?> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryChooseBloc, CategoryChooseState>(
      buildWhen: (previous, current) {
        return previous.categories != current.categories ||
            previous.isLoading != current.isLoading ||
            previous.errorMessage != current.errorMessage;
      },
      builder: (context, state) {
        if (state.categories.isEmpty) {
          return const SizedBox(height: 36);
        }

        return CategoryChipRow(
          categories: state.categories,
          selectedCategory: selectedCategory,
          onSelectCategory: onSelectCategory,
        );
      },
    );
  }
}
