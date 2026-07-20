import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/category/domain/usecases/get_entry_categories.dart';

sealed class CategoryChooseEvent {
  const CategoryChooseEvent();
}

final class CategoryChooseStarted extends CategoryChooseEvent {
  const CategoryChooseStarted();
}

final class CategoryChooseRetryPressed extends CategoryChooseEvent {
  const CategoryChooseRetryPressed();
}

final class CategoryChooseState {
  const CategoryChooseState({
    this.categories = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<EntryCategory> categories;
  final bool isLoading;
  final String? errorMessage;

  CategoryChooseState copyWith({
    List<EntryCategory>? categories,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CategoryChooseState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final class CategoryChooseBloc
    extends Bloc<CategoryChooseEvent, CategoryChooseState> {
  CategoryChooseBloc({required GetEntryCategories getEntryCategories})
    : _getEntryCategories = getEntryCategories,
      super(const CategoryChooseState(isLoading: true)) {
    on<CategoryChooseStarted>(_onStarted);
    on<CategoryChooseRetryPressed>(_onRetryPressed);
  }

  final GetEntryCategories _getEntryCategories;

  Future<void> _onStarted(
    CategoryChooseStarted event,
    Emitter<CategoryChooseState> emit,
  ) async {
    await _loadCategories(emit);
  }

  Future<void> _onRetryPressed(
    CategoryChooseRetryPressed event,
    Emitter<CategoryChooseState> emit,
  ) async {
    await _loadCategories(emit);
  }

  Future<void> _loadCategories(Emitter<CategoryChooseState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final response = await _getEntryCategories(const NoParams());
    if (!response.success || response.data == null) {
      emit(state.copyWith(isLoading: false, errorMessage: response.message));
      return;
    }

    emit(
      state.copyWith(
        categories: List.unmodifiable(response.data!),
        isLoading: false,
        clearError: true,
      ),
    );
  }
}
