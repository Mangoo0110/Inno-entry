import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/category/domain/usecases/category_usecases.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_total_amount_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_details_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/new_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/update_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/entry_usecases.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/entry_form_view.dart';

final class EntryFormBlocParams {
  const EntryFormBlocParams({
    required this.accountName,
    required this.mode,
    this.entryId,
  });

  final String accountName;
  final EntryFormMode mode;
  final int? entryId;
}

sealed class EntryFormEvent {
  const EntryFormEvent();
}

final class EntryFormStarted extends EntryFormEvent {
  const EntryFormStarted();
}

final class EntryFormTitleChanged extends EntryFormEvent {
  const EntryFormTitleChanged(this.title);

  final String title;
}

final class EntryFormAmountChanged extends EntryFormEvent {
  const EntryFormAmountChanged(this.amount);

  final String amount;
}

final class EntryFormNoteChanged extends EntryFormEvent {
  const EntryFormNoteChanged(this.note);

  final String note;
}

final class EntryFormCategorySelected extends EntryFormEvent {
  const EntryFormCategorySelected(this.category);

  final EntryCategory category;
}

final class EntryFormPhotoRemoved extends EntryFormEvent {
  const EntryFormPhotoRemoved();
}

final class EntryFormPhotoUploadRequested extends EntryFormEvent {
  const EntryFormPhotoUploadRequested();
}

final class EntryFormPhotoSelected extends EntryFormEvent {
  const EntryFormPhotoSelected(this.photoPath);

  final String photoPath;
}

final class EntryFormSubmitted extends EntryFormEvent {
  const EntryFormSubmitted();
}

final class EntryFormSaveHandled extends EntryFormEvent {
  const EntryFormSaveHandled();
}

final class EntryFormState {
  const EntryFormState({
    required this.accountName,
    required this.mode,
    this.entryId,
    this.categories = const [],
    this.selectedCategory = 'Food',
    this.title = '',
    this.amount = '',
    this.note = '',
    this.photoPath,
    this.todayAmount = 0,
    this.monthAmount = 0,
    this.isLoading = true,
    this.isSubmitting = false,
    this.saved = false,
    this.errorMessage,
  });

  factory EntryFormState.initial(EntryFormBlocParams params) {
    return EntryFormState(
      accountName: params.accountName,
      mode: params.mode,
      entryId: params.entryId,
    );
  }

  final String accountName;
  final EntryFormMode mode;
  final int? entryId;
  final List<EntryCategory> categories;
  final String selectedCategory;
  final String title;
  final String amount;
  final String note;
  final String? photoPath;
  final double todayAmount;
  final double monthAmount;
  final bool isLoading;
  final bool isSubmitting;
  final bool saved;
  final String? errorMessage;

  EntryFormState copyWith({
    List<EntryCategory>? categories,
    String? selectedCategory,
    String? title,
    String? amount,
    String? note,
    Object? photoPath = _unchanged,
    double? todayAmount,
    double? monthAmount,
    bool? isLoading,
    bool? isSubmitting,
    bool? saved,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EntryFormState(
      accountName: accountName,
      mode: mode,
      entryId: entryId,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      photoPath: photoPath == _unchanged
          ? this.photoPath
          : photoPath as String?,
      todayAmount: todayAmount ?? this.todayAmount,
      monthAmount: monthAmount ?? this.monthAmount,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      saved: saved ?? this.saved,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

const Object _unchanged = Object();

final class EntryFormBloc extends Bloc<EntryFormEvent, EntryFormState> {
  EntryFormBloc({
    required EntryFormBlocParams params,
    required GetEntryCategories getEntryCategories,
    required GetEntryTotalAmount getEntryTotalAmount,
    required GetEntryDetails getEntryDetails,
    required AddNewEntry addNewEntry,
    required UpdateEntry updateEntry,
  }) : _getEntryCategories = getEntryCategories,
       _getEntryTotalAmount = getEntryTotalAmount,
       _getEntryDetails = getEntryDetails,
       _addNewEntry = addNewEntry,
       _updateEntry = updateEntry,
       super(EntryFormState.initial(params)) {
    on<EntryFormStarted>(_onStarted);
    on<EntryFormTitleChanged>(_onTitleChanged);
    on<EntryFormAmountChanged>(_onAmountChanged);
    on<EntryFormNoteChanged>(_onNoteChanged);
    on<EntryFormCategorySelected>(_onCategorySelected);
    on<EntryFormPhotoRemoved>(_onPhotoRemoved);
    on<EntryFormPhotoUploadRequested>(_onPhotoUploadRequested);
    on<EntryFormPhotoSelected>(_onPhotoSelected);
    on<EntryFormSubmitted>(_onSubmitted);
    on<EntryFormSaveHandled>(_onSaveHandled);
  }

  final GetEntryCategories _getEntryCategories;
  final GetEntryTotalAmount _getEntryTotalAmount;
  final GetEntryDetails _getEntryDetails;
  final AddNewEntry _addNewEntry;
  final UpdateEntry _updateEntry;

  Future<void> _onStarted(
    EntryFormStarted event,
    Emitter<EntryFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final categoriesResponse = await _getEntryCategories(const NoParams());
    if (!categoriesResponse.success || categoriesResponse.data == null) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: categoriesResponse.message,
        ),
      );
      return;
    }

    final summaries = await _getSummaries();
    if (summaries.errorMessage != null) {
      emit(
        state.copyWith(isLoading: false, errorMessage: summaries.errorMessage),
      );
      return;
    }
    final categories = List<EntryCategory>.unmodifiable(
      categoriesResponse.data!,
    );
    var nextState = state.copyWith(
      categories: categories,
      selectedCategory: _defaultCategory(categories),
      todayAmount: summaries.todayAmount,
      monthAmount: summaries.monthAmount,
    );

    if (state.mode == EntryFormMode.edit && state.entryId != null) {
      final entryResponse = await _getEntryDetails(
        GetEntryDetailsParams(
          id: EntryUid(uId: state.entryId!),
          owner: state.accountName,
        ),
      );
      if (!entryResponse.success || entryResponse.data == null) {
        emit(
          nextState.copyWith(
            isLoading: false,
            errorMessage: entryResponse.message,
          ),
        );
        return;
      }
      nextState = _stateFromEntry(nextState, entryResponse.data!);
    }

    emit(nextState.copyWith(isLoading: false, clearError: true));
  }

  void _onTitleChanged(
    EntryFormTitleChanged event,
    Emitter<EntryFormState> emit,
  ) {
    emit(state.copyWith(title: event.title, saved: false, clearError: true));
  }

  void _onAmountChanged(
    EntryFormAmountChanged event,
    Emitter<EntryFormState> emit,
  ) {
    emit(state.copyWith(amount: event.amount, saved: false, clearError: true));
  }

  void _onNoteChanged(
    EntryFormNoteChanged event,
    Emitter<EntryFormState> emit,
  ) {
    emit(state.copyWith(note: event.note, saved: false, clearError: true));
  }

  void _onCategorySelected(
    EntryFormCategorySelected event,
    Emitter<EntryFormState> emit,
  ) {
    emit(
      state.copyWith(
        selectedCategory: event.category.name,
        saved: false,
        clearError: true,
      ),
    );
  }

  void _onPhotoRemoved(
    EntryFormPhotoRemoved event,
    Emitter<EntryFormState> emit,
  ) {
    emit(state.copyWith(photoPath: null, saved: false, clearError: true));
  }

  void _onPhotoUploadRequested(
    EntryFormPhotoUploadRequested event,
    Emitter<EntryFormState> emit,
  ) {
    emit(state.copyWith(errorMessage: 'Could not select photo.'));
  }

  void _onPhotoSelected(
    EntryFormPhotoSelected event,
    Emitter<EntryFormState> emit,
  ) {
    emit(
      state.copyWith(
        photoPath: event.photoPath,
        saved: false,
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    EntryFormSubmitted event,
    Emitter<EntryFormState> emit,
  ) async {
    final title = state.title.trim();
    if (title.isEmpty) {
      emit(state.copyWith(errorMessage: 'Title is required.'));
      return;
    }

    final amount = _parseAmount(state.amount);
    if (amount == null && state.amount.trim().isNotEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a valid amount.'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));

    final response = switch (state.mode) {
      EntryFormMode.create => await _addNewEntry(
        NewEntryParams(
          owner: state.accountName,
          title: title,
          note: state.note.trim(),
          amount: amount ?? 0,
          category: state.selectedCategory,
          done: amount != null && amount > 0,
          photoPath: state.photoPath,
        ),
      ),
      EntryFormMode.edit => await _updateEntry(
        UpdateEntryParams(
          id: EntryUid(uId: state.entryId!),
          owner: state.accountName,
          title: title,
          note: state.note.trim(),
          amount: amount,
          category: state.selectedCategory,
          done: amount != null && amount > 0,
          photoPath: state.photoPath,
          clearPhotoPath: state.photoPath == null,
        ),
      ),
    };

    if (!response.success) {
      emit(state.copyWith(isSubmitting: false, errorMessage: response.message));
      return;
    }

    final summaries = await _getSummaries();
    emit(
      state.copyWith(
        todayAmount: summaries.todayAmount,
        monthAmount: summaries.monthAmount,
        isSubmitting: false,
        saved: true,
        clearError: true,
      ),
    );
  }

  void _onSaveHandled(
    EntryFormSaveHandled event,
    Emitter<EntryFormState> emit,
  ) {
    emit(state.copyWith(saved: false));
  }

  Future<({double todayAmount, double monthAmount, String? errorMessage})>
  _getSummaries() async {
    final totals = await Future.wait([
      _getEntryTotalAmount(
        GetEntryTotalAmountParams.today(owner: state.accountName),
      ),
      _getEntryTotalAmount(
        GetEntryTotalAmountParams.thisMonth(owner: state.accountName),
      ),
    ]);

    final todayResponse = totals[0];
    if (!todayResponse.success || todayResponse.data == null) {
      return (
        todayAmount: state.todayAmount,
        monthAmount: state.monthAmount,
        errorMessage: todayResponse.message,
      );
    }

    final monthResponse = totals[1];
    if (!monthResponse.success || monthResponse.data == null) {
      return (
        todayAmount: state.todayAmount,
        monthAmount: state.monthAmount,
        errorMessage: monthResponse.message,
      );
    }

    return (
      todayAmount: todayResponse.data!,
      monthAmount: monthResponse.data!,
      errorMessage: null,
    );
  }

  String _defaultCategory(List<EntryCategory> categories) {
    final current = state.selectedCategory;
    if (categories.any((category) => category.name == current)) return current;
    return categories
        .firstWhere(
          (category) => category.name.toLowerCase() != 'all',
          orElse: () => categories.first,
        )
        .name;
  }

  EntryFormState _stateFromEntry(EntryFormState current, Entry entry) {
    return current.copyWith(
      selectedCategory: entry.category,
      title: entry.title,
      amount: entry.amount == null ? '' : entry.amount!.toStringAsFixed(2),
      note: entry.note,
      photoPath: entry.photoPath,
    );
  }

  double? _parseAmount(String value) {
    final clean = value.trim();
    if (clean.isEmpty) return null;
    return double.tryParse(clean);
  }
}
