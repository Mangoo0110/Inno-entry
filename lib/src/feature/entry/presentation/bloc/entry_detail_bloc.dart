import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_entry_param.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_details_params.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/delete_entry.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/get_entry_details.dart';

final class EntryDetailBlocParams {
  const EntryDetailBlocParams({
    required this.accountName,
    required this.entryId,
  });

  final String accountName;
  final int entryId;
}

sealed class EntryDetailEvent {
  const EntryDetailEvent();
}

final class EntryDetailStarted extends EntryDetailEvent {
  const EntryDetailStarted();
}

final class EntryDetailReloadRequested extends EntryDetailEvent {
  const EntryDetailReloadRequested();
}

final class EntryDetailDeletePressed extends EntryDetailEvent {
  const EntryDetailDeletePressed();
}

final class EntryDetailErrorHandled extends EntryDetailEvent {
  const EntryDetailErrorHandled();
}

final class EntryDetailState {
  const EntryDetailState({
    required this.accountName,
    required this.entryId,
    this.entry,
    this.isLoading = false,
    this.isDeleting = false,
    this.deleted = false,
    this.errorMessage,
  });

  factory EntryDetailState.initial(EntryDetailBlocParams params) {
    return EntryDetailState(
      accountName: params.accountName,
      entryId: params.entryId,
      isLoading: true,
    );
  }

  final String accountName;
  final int entryId;
  final Entry? entry;
  final bool isLoading;
  final bool isDeleting;
  final bool deleted;
  final String? errorMessage;

  EntryDetailState copyWith({
    Entry? entry,
    bool? isLoading,
    bool? isDeleting,
    bool? deleted,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EntryDetailState(
      accountName: accountName,
      entryId: entryId,
      entry: entry ?? this.entry,
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      deleted: deleted ?? this.deleted,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final class EntryDetailBloc extends Bloc<EntryDetailEvent, EntryDetailState> {
  EntryDetailBloc({
    required EntryDetailBlocParams params,
    required GetEntryDetails getEntryDetails,
    required DeleteEntry deleteEntry,
  }) : _getEntryDetails = getEntryDetails,
       _deleteEntry = deleteEntry,
       super(EntryDetailState.initial(params)) {
    on<EntryDetailStarted>(_onStarted);
    on<EntryDetailReloadRequested>(_onStarted);
    on<EntryDetailDeletePressed>(_onDeletePressed);
    on<EntryDetailErrorHandled>(_onErrorHandled);
  }

  final GetEntryDetails _getEntryDetails;
  final DeleteEntry _deleteEntry;

  Future<void> _onStarted(
    EntryDetailEvent event,
    Emitter<EntryDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, deleted: false, clearError: true));

    final response = await _getEntryDetails(
      GetEntryDetailsParams(
        id: EntryUid(uId: state.entryId),
        owner: state.accountName,
      ),
    );

    if (!response.success || response.data == null) {
      emit(state.copyWith(isLoading: false, errorMessage: response.message));
      return;
    }

    emit(
      state.copyWith(entry: response.data, isLoading: false, clearError: true),
    );
  }

  Future<void> _onDeletePressed(
    EntryDetailDeletePressed event,
    Emitter<EntryDetailState> emit,
  ) async {
    if (state.isDeleting) return;

    emit(state.copyWith(isDeleting: true, clearError: true));
    final response = await _deleteEntry(
      DeleteEntryParam(
        id: EntryUid(uId: state.entryId),
        owner: state.accountName,
      ),
    );

    if (!response.success) {
      emit(state.copyWith(isDeleting: false, errorMessage: response.message));
      return;
    }

    emit(state.copyWith(isDeleting: false, deleted: true, clearError: true));
  }

  void _onErrorHandled(
    EntryDetailErrorHandled event,
    Emitter<EntryDetailState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}
