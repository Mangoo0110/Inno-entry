import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inno_entry/src/core/routing/app_routes.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/entry_usecases.dart';
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_detail_bloc.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_detail/entry_detail_result.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_detail/entry_detail_view.dart';

class EntryDetailScreen extends StatefulWidget {
  const EntryDetailScreen({
    super.key,
    required this.accountName,
    required this.entryId,
  });

  final String accountName;
  final int entryId;

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  bool _hasChanges = false;
  bool _hasShownLoadedSnackBar = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EntryDetailBloc(
        params: EntryDetailBlocParams(
          accountName: widget.accountName,
          entryId: widget.entryId,
        ),
        getEntryDetails: context.read<GetEntryDetails>(),
        deleteEntry: context.read<DeleteEntry>(),
      )..add(const EntryDetailStarted()),
      child: BlocConsumer<EntryDetailBloc, EntryDetailState>(
        listenWhen: (previous, current) {
          final loaded = previous.entry == null && current.entry != null;
          final deleted =
              previous.deleted != current.deleted && current.deleted;
          final errorChanged =
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null;
          return loaded || deleted || errorChanged;
        },
        listener: _onStateChanged,
        builder: (context, state) {
          final entry = state.entry;

          if (entry == null && state.isLoading) {
            return const _EntryDetailLoadingView();
          }

          if (entry == null && state.errorMessage != null) {
            return _EntryDetailErrorView(
              message: state.errorMessage!,
              onBackPressed: _pop,
              onRetryPressed: () {
                context.read<EntryDetailBloc>().add(
                  const EntryDetailReloadRequested(),
                );
              },
            );
          }

          if (entry == null) {
            return _EntryDetailErrorView(
              message: 'Entry could not be loaded.',
              onBackPressed: _pop,
              onRetryPressed: () {
                context.read<EntryDetailBloc>().add(
                  const EntryDetailReloadRequested(),
                );
              },
            );
          }

          return EntryDetailView(
            entry: entry,
            isDeleting: state.isDeleting,
            onBackPressed: _pop,
            onEditPressed: () => _openEditForm(context),
            onDeletePressed: () {
              context.read<EntryDetailBloc>().add(
                const EntryDetailDeletePressed(),
              );
            },
          );
        },
      ),
    );
  }

  void _onStateChanged(BuildContext context, EntryDetailState state) {
    if (state.entry != null && !state.deleted && !_hasShownLoadedSnackBar) {
      _hasShownLoadedSnackBar = true;
      showEntryDetailSnackBar(context, 'Entry loaded');
    }

    final errorMessage = state.errorMessage;
    if (errorMessage != null) {
      showEntryDetailSnackBar(context, errorMessage);
      context.read<EntryDetailBloc>().add(const EntryDetailErrorHandled());
    }

    if (state.deleted) {
      final entry = state.entry;
      context.pop(entry == null ? null : EntryDetailDeleted(entry));
    }
  }

  Future<void> _openEditForm(BuildContext context) async {
    final saved = await context.push<bool>(
      '${AppRoutes.entryForm}?entryId=${widget.entryId}',
    );
    if (!mounted || saved != true) return;
    _hasChanges = true;
    if (!context.mounted) return;
    context.read<EntryDetailBloc>().add(const EntryDetailReloadRequested());
  }

  void _pop() {
    context.pop(_hasChanges ? const EntryDetailSaved() : null);
  }
}

class _EntryDetailLoadingView extends StatelessWidget {
  const _EntryDetailLoadingView();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: const SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }
}

class _EntryDetailErrorView extends StatelessWidget {
  const _EntryDetailErrorView({
    required this.message,
    required this.onBackPressed,
    required this.onRetryPressed,
  });

  final String message;
  final VoidCallback onBackPressed;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Back',
                  onPressed: onBackPressed,
                  color: colors.textColor,
                  icon: const Icon(Icons.arrow_back_rounded, size: 26),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 36,
                          color: colors.borderColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: onRetryPressed,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
