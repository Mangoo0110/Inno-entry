import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_entry_param.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entries_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_details_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/restore_deleted_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/delete_entry.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/get_entries.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/get_entry_categories.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/get_entry_details.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/restore_deleted_entry.dart';

sealed class EntryFeedEvent {
  const EntryFeedEvent();
}

final class EntryFeedStarted extends EntryFeedEvent {
  const EntryFeedStarted();
}

final class EntryFeedCategorySelected extends EntryFeedEvent {
  const EntryFeedCategorySelected(this.category);

  final EntryCategory category;
}

final class EntryFeedSearchSubmitted extends EntryFeedEvent {
  const EntryFeedSearchSubmitted(this.search);

  final String search;
}

final class EntryFeedNextPageRequested extends EntryFeedEvent {
  const EntryFeedNextPageRequested();
}

final class EntryFeedEntryDeleted extends EntryFeedEvent {
  const EntryFeedEntryDeleted(this.entry);

  final EntryBrief entry;
}

final class EntryFeedEntryDeleteUndone extends EntryFeedEvent {
  const EntryFeedEntryDeleteUndone(this.entry);

  final Entry entry;
}

final class EntryFeedSaveConfirmed extends EntryFeedEvent {
  const EntryFeedSaveConfirmed();
}

final class EntryFeedEffectHandled extends EntryFeedEvent {
  const EntryFeedEffectHandled();
}

sealed class EntryFeedEffect {
  const EntryFeedEffect();
}

final class EntryFeedSavedEffect extends EntryFeedEffect {
  const EntryFeedSavedEffect();
}

final class EntryFeedDeletedEffect extends EntryFeedEffect {
  const EntryFeedDeletedEffect(this.entry);

  final Entry entry;
}

final class EntryFeedState {
  const EntryFeedState({
    required this.accountName,
    this.categories = const [],
    this.entries = const [],
    this.selectedCategory = 'All',
    this.search = '',
    this.isLoading = false,
    this.isFiltering = false,
    this.isPageLoading = false,
    this.hasReachedMax = false,
    this.nextPage = 0,
    this.pageSize = EntryFeedBloc.pageSize,
    this.lastSyncedAt,
    this.effect,
    this.errorMessage,
  });

  factory EntryFeedState.initial(String accountName) {
    return EntryFeedState(accountName: accountName, isLoading: true);
  }

  final String accountName;
  final List<EntryCategory> categories;
  final List<EntryBrief> entries;
  final String selectedCategory;
  final String search;
  final bool isLoading;
  final bool isFiltering;
  final bool isPageLoading;
  final bool hasReachedMax;
  final int nextPage;
  final int pageSize;
  final DateTime? lastSyncedAt;
  final EntryFeedEffect? effect;
  final String? errorMessage;

  double get monthAmount {
    return entries.fold<double>(0, (sum, entry) => sum + (entry.amount ?? 0));
  }

  EntryFeedState copyWith({
    List<EntryCategory>? categories,
    List<EntryBrief>? entries,
    String? selectedCategory,
    String? search,
    bool? isLoading,
    bool? isFiltering,
    bool? isPageLoading,
    bool? hasReachedMax,
    int? nextPage,
    int? pageSize,
    DateTime? lastSyncedAt,
    Object? effect = _unchanged,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EntryFeedState(
      accountName: accountName,
      categories: categories ?? this.categories,
      entries: entries ?? this.entries,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      isFiltering: isFiltering ?? this.isFiltering,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      nextPage: nextPage ?? this.nextPage,
      pageSize: pageSize ?? this.pageSize,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      effect: effect == _unchanged ? this.effect : effect as EntryFeedEffect?,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

const Object _unchanged = Object();

final class EntryFeedBloc extends Bloc<EntryFeedEvent, EntryFeedState> {
  EntryFeedBloc({
    required String accountName,
    required GetEntries getEntries,
    required GetEntryCategories getEntryCategories,
    required GetEntryDetails getEntryDetails,
    required DeleteEntry deleteEntry,
    required RestoreDeletedEntry restoreDeletedEntry,
  }) : _getEntries = getEntries,
       _getEntryCategories = getEntryCategories,
       _getEntryDetails = getEntryDetails,
       _deleteEntry = deleteEntry,
       _restoreDeletedEntry = restoreDeletedEntry,
       super(EntryFeedState.initial(accountName)) {
    on<EntryFeedStarted>(_onStarted);
    on<EntryFeedCategorySelected>(_onCategorySelected);
    on<EntryFeedSearchSubmitted>(_onSearchSubmitted);
    on<EntryFeedNextPageRequested>(_onNextPageRequested);
    on<EntryFeedEntryDeleted>(_onEntryDeleted);
    on<EntryFeedEntryDeleteUndone>(_onEntryDeleteUndone);
    on<EntryFeedSaveConfirmed>(_onSaveConfirmed);
    on<EntryFeedEffectHandled>(_onEffectHandled);
  }

  static const int pageSize = 20;

  final GetEntries _getEntries;
  final GetEntryCategories _getEntryCategories;
  final GetEntryDetails _getEntryDetails;
  final DeleteEntry _deleteEntry;
  final RestoreDeletedEntry _restoreDeletedEntry;
  int _requestId = 0;

  Future<void> _onStarted(
    EntryFeedStarted event,
    Emitter<EntryFeedState> emit,
  ) async {
    final requestId = ++_requestId;
    emit(
      state.copyWith(
        entries: const [],
        isLoading: true,
        isFiltering: false,
        isPageLoading: false,
        hasReachedMax: false,
        nextPage: 0,
        effect: null,
        clearError: true,
      ),
    );

    final categoriesResponse = await _getEntryCategories(const NoParams());
    if (requestId != _requestId) return;

    if (!categoriesResponse.success || categoriesResponse.data == null) {
      emit(
        state.copyWith(
          isLoading: false,
          isFiltering: false,
          isPageLoading: false,
          errorMessage: categoriesResponse.message,
        ),
      );
      return;
    }

    emit(
      state.copyWith(categories: List.unmodifiable(categoriesResponse.data!)),
    );
    await _loadEntries(emit, requestId: requestId, append: false);
  }

  Future<void> _onCategorySelected(
    EntryFeedCategorySelected event,
    Emitter<EntryFeedState> emit,
  ) async {
    if (state.selectedCategory == event.category.name) return;
    final requestId = ++_requestId;
    emit(
      state.copyWith(
        selectedCategory: event.category.name,
        isLoading: state.entries.isEmpty,
        isFiltering: state.entries.isNotEmpty,
        isPageLoading: false,
        hasReachedMax: false,
        nextPage: 0,
        clearError: true,
      ),
    );
    await _loadEntries(emit, requestId: requestId, append: false);
  }

  Future<void> _onSearchSubmitted(
    EntryFeedSearchSubmitted event,
    Emitter<EntryFeedState> emit,
  ) async {
    final requestId = ++_requestId;
    emit(
      state.copyWith(
        search: event.search,
        isLoading: state.entries.isEmpty,
        isFiltering: state.entries.isNotEmpty,
        isPageLoading: false,
        hasReachedMax: false,
        nextPage: 0,
        clearError: true,
      ),
    );
    await _loadEntries(emit, requestId: requestId, append: false);
  }

  Future<void> _onNextPageRequested(
    EntryFeedNextPageRequested event,
    Emitter<EntryFeedState> emit,
  ) async {
    if (state.isLoading || state.isPageLoading || state.hasReachedMax) return;

    emit(state.copyWith(isPageLoading: true, clearError: true));
    await _loadEntries(emit, requestId: _requestId, append: true);
  }

  Future<void> _onEntryDeleted(
    EntryFeedEntryDeleted event,
    Emitter<EntryFeedState> emit,
  ) async {
    final detailsResponse = await _getEntryDetails(
      GetEntryDetailsParams(id: event.entry.uId, owner: state.accountName),
    );

    if (!detailsResponse.success || detailsResponse.data == null) {
      emit(state.copyWith(errorMessage: detailsResponse.message));
      return;
    }

    final response = await _deleteEntry(
      DeleteEntryParam(id: event.entry.uId, owner: state.accountName),
    );

    if (!response.success) {
      emit(state.copyWith(errorMessage: response.message));
      return;
    }

    final entries = state.entries
        .where((entry) => entry.uId.uId != event.entry.uId.uId)
        .toList(growable: false);

    emit(
      state.copyWith(
        entries: List<EntryBrief>.unmodifiable(entries),
        effect: EntryFeedDeletedEffect(detailsResponse.data!),
        clearError: true,
      ),
    );
  }

  Future<void> _onEntryDeleteUndone(
    EntryFeedEntryDeleteUndone event,
    Emitter<EntryFeedState> emit,
  ) async {
    final response = await _restoreDeletedEntry(
      RestoreDeletedEntryParams(entry: event.entry),
    );

    if (!response.success) {
      emit(state.copyWith(errorMessage: response.message));
      return;
    }

    final requestId = ++_requestId;
    emit(
      state.copyWith(
        isLoading: state.entries.isEmpty,
        isFiltering: state.entries.isNotEmpty,
        isPageLoading: false,
        hasReachedMax: false,
        nextPage: 0,
        clearError: true,
      ),
    );
    await _loadEntries(emit, requestId: requestId, append: false);
  }

  void _onSaveConfirmed(
    EntryFeedSaveConfirmed event,
    Emitter<EntryFeedState> emit,
  ) {
    emit(state.copyWith(effect: const EntryFeedSavedEffect()));
  }

  void _onEffectHandled(
    EntryFeedEffectHandled event,
    Emitter<EntryFeedState> emit,
  ) {
    emit(state.copyWith(effect: null));
  }

  Future<void> _loadEntries(
    Emitter<EntryFeedState> emit, {
    required int requestId,
    required bool append,
  }) async {
    final page = state.nextPage;
    final pageSize = state.pageSize;
    final entriesResponse = await _getEntries(
      GetEntriesParams(
        owner: state.accountName,
        filters: Filters(
          category: state.selectedCategory,
          search: state.search,
          page: page,
          limit: pageSize,
        ),
      ),
    );
    if (requestId != _requestId) return;

    if (!entriesResponse.success || entriesResponse.data == null) {
      emit(
        state.copyWith(
          isLoading: false,
          isFiltering: false,
          isPageLoading: false,
          errorMessage: entriesResponse.message,
        ),
      );
      return;
    }

    final fetchedEntries = entriesResponse.data!;
    final updatedEntries = append
        ? <EntryBrief>[...state.entries, ...fetchedEntries]
        : fetchedEntries;

    emit(
      state.copyWith(
        entries: List.unmodifiable(updatedEntries),
        isLoading: false,
        isFiltering: false,
        isPageLoading: false,
        hasReachedMax: fetchedEntries.length < pageSize,
        nextPage: page + 1,
        lastSyncedAt: DateTime.now(),
        clearError: true,
      ),
    );
  }
}
