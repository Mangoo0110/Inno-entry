import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inno_entry/src/app/bloc/app_theme_cubit.dart';
import 'package:inno_entry/src/app/bloc/dashboard/dashboard_bloc.dart';
import 'package:inno_entry/src/app/view/widgets/delete_account_dialog.dart';
import 'package:inno_entry/src/app/view/widgets/user_dashboard_account_menu.dart';
import 'package:inno_entry/src/core/routing/app_routes.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/core/utils/utils.dart';
import 'package:inno_entry/src/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:inno_entry/src/feature/category/domain/usecases/category_usecases.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/entry_usecases.dart';
import 'package:inno_entry/src/feature/category/presentation/bloc/category_choose_bloc.dart';
import 'package:inno_entry/src/feature/category/presentation/widgets/category_choose_chip_row.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_feed_bloc.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_empty_feed.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_feed_list.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_filtering_bar.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_home_header.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_search_field.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_detail/entry_detail_result.dart';
import 'package:inno_entry/src/feature/entry/presentation/widgets/entry_delete_button.dart';

class UserDashboardView extends StatelessWidget {
  const UserDashboardView({super.key, required this.accountName});

  final String accountName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey(accountName),
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc(
            accountName: accountName,
            logout: context.read<Logout>(),
            deleteCurrentAccount: context.read<DeleteCurrentAccount>(),
            deleteAllEntry: context.read<DeleteAllEntry>(),
            getEntryTotalAmount: context.read<GetEntryTotalAmount>(),
          )..add(const DashboardStarted()),
        ),
        BlocProvider(
          create: (context) => EntryFeedBloc(
            accountName: accountName,
            getEntries: context.read<GetEntries>(),
            getEntryDetails: context.read<GetEntryDetails>(),
            getEntryTotalAmount: context.read<GetEntryTotalAmount>(),
            deleteEntry: context.read<DeleteEntry>(),
            restoreDeletedEntry: context.read<RestoreDeletedEntry>(),
          )..add(const EntryFeedStarted()),
        ),
        BlocProvider(
          create: (context) => CategoryChooseBloc(
            getEntryCategories: context.read<GetEntryCategories>(),
          )..add(const CategoryChooseStarted()),
        ),
      ],
      child: const _UserDashboardContent(),
    );
  }
}

class _UserDashboardContent extends StatefulWidget {
  const _UserDashboardContent();

  @override
  State<_UserDashboardContent> createState() => _UserDashboardContentState();
}

class _UserDashboardContentState extends State<_UserDashboardContent> {
  late final TextEditingController _searchController;
  Debouncer _searchDebounce = Debouncer(inMilliseconds: 350);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchDebounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EntryFeedBloc, EntryFeedState>(
          listenWhen: (previous, current) {
            final hasNewError =
                previous.errorMessage != current.errorMessage &&
                current.errorMessage != null &&
                current.entries.isNotEmpty;
            final hasNewEffect =
                previous.effect != current.effect && current.effect != null;
            return hasNewError || hasNewEffect;
          },
          listener: _handleEntryFeedState,
        ),
        BlocListener<DashboardBloc, DashboardState>(
          listenWhen: (previous, current) {
            final hasNewError =
                previous.errorMessage != current.errorMessage &&
                current.errorMessage != null;
            final hasNewEffect =
                previous.effect != current.effect && current.effect != null;
            return hasNewError || hasNewEffect;
          },
          listener: _handleDashboardState,
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _DashboardHeader(
                    onThemePressed: _handleThemePressed,
                    onAccountPressed: _toggleAccountMenu,
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  _DashboardSearch(
                    searchController: _searchController,
                    onChanged: _scheduleSearch,
                    onSubmitted: (search) {
                      
                      _searchDebounce.run(()=> _submitSearch(search));
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  const _DashboardCategories(),
                  const _DashboardFilteringBar(),
                  _DashboardFeed(onEntryPressed: _openEntry),
                ],
              ),
              _DashboardAddButton(onPressed: _openAddEntry),
              Positioned.fill(
                child: BlocSelector<DashboardBloc, DashboardState, bool>(
                  selector: (state) => state.isAccountMenuOpen,
                  builder: (context, isOpen) {
                    if (!isOpen) return const SizedBox.shrink();
                    return Stack(
                      children: [
                        Positioned.fill(
                          top: 102,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _closeAccountMenu,
                            child: const ColoredBox(color: Color(0x330E1919)),
                          ),
                        ),
                        Positioned(
                          top: 108,
                          right: 16,
                          child: UserDashboardAccountMenu(
                            onLogoutPressed: _handleLogoutPressed,
                            onDeleteAccountPressed: _handleDeleteAccountPressed,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEntryFeedState(BuildContext context, EntryFeedState state) {
    final effect = state.effect;
    if (effect is EntryFeedSavedEffect) {
      _showEntrySnackBar(context, message: 'Saved');
      context.read<EntryFeedBloc>().add(const EntryFeedEffectHandled());
      context.read<DashboardBloc>().add(
        const DashboardTotalsRefreshRequested(),
      );
      return;
    }
    if (effect is EntryFeedDeletedEffect) {
      showEntryDeletedSnackBar(
        context,
        actionLabel: 'UNDO',
        onActionPressed: () {
          context.read<EntryFeedBloc>().add(
            EntryFeedEntryDeleteUndone(effect.entry),
          );
          context.read<DashboardBloc>().add(
            const DashboardTotalsRefreshRequested(),
          );
        },
      );
      context.read<EntryFeedBloc>().add(const EntryFeedEffectHandled());
      context.read<DashboardBloc>().add(
        const DashboardTotalsRefreshRequested(),
      );
      return;
    }
    final errorMessage = state.errorMessage;
    if (errorMessage == null) return;
    _showEntrySnackBar(context, message: errorMessage, isError: true);
  }

  void _handleDashboardState(BuildContext context, DashboardState state) {
    final effect = state.effect;
    if (effect is DashboardToggleThemeEffect) {
      context.read<AppThemeCubit>().toggle();
      context.read<DashboardBloc>().add(const DashboardEffectHandled());
      return;
    }
    if (effect is DashboardConfirmDeleteAccountEffect) {
      context.read<DashboardBloc>().add(const DashboardEffectHandled());
      _showDeleteAccountDialog();
      return;
    }

    final errorMessage = state.errorMessage;
    if (errorMessage == null) return;
    _showEntrySnackBar(context, message: errorMessage, isError: true);
  }

  void _handleEntryDetailResult(EntryDetailResult? result) {
    if (result == null) return;

    final entryFeedBloc = context.read<EntryFeedBloc>()
      ..add(const EntryFeedStarted());
    context.read<DashboardBloc>().add(const DashboardTotalsRefreshRequested());
    if (result is EntryDetailSaved) {
      entryFeedBloc.add(const EntryFeedSaveConfirmed());
      return;
    }

    if (result is EntryDetailDeleted) {
      showEntryDeletedSnackBar(
        context,
        actionLabel: 'UNDO',
        onActionPressed: () {
          context.read<EntryFeedBloc>().add(
            EntryFeedEntryDeleteUndone(result.entry),
          );
          context.read<DashboardBloc>().add(
            const DashboardTotalsRefreshRequested(),
          );
        },
      );
    }
  }

  Future<void> _openAddEntry() async {
    _closeAccountMenu();
    final saved = await context.push<bool>(AppRoutes.entryForm);
    if (!mounted || saved != true) return;
    context.read<EntryFeedBloc>()
      ..add(const EntryFeedStarted())
      ..add(const EntryFeedSaveConfirmed());
    context.read<DashboardBloc>().add(const DashboardTotalsRefreshRequested());
  }

  Future<void> _openEntry(EntryBrief entry) async {
    _closeAccountMenu();
    final result = await context.push<EntryDetailResult>(
      '${AppRoutes.entryDetail}?entryId=${entry.uId.uId}',
    );
    if (!mounted) return;
    _handleEntryDetailResult(result);
  }

  void _scheduleSearch(String search) {
     _searchDebounce.run(()=> _submitSearch(search));
  }

  void _submitSearch(String search) {
    context.read<EntryFeedBloc>().add(EntryFeedSearchSubmitted(search.trim()));
  }

  void _toggleAccountMenu() {
    context.read<DashboardBloc>().add(const DashboardAccountMenuToggled());
  }

  void _handleThemePressed() {
    context.read<DashboardBloc>().add(const DashboardThemePressed());
  }

  void _closeAccountMenu() {
    if (!mounted) return;
    context.read<DashboardBloc>().add(const DashboardAccountMenuClosed());
  }

  void _handleLogoutPressed() {
    context.read<DashboardBloc>().add(const DashboardLogoutPressed());
  }

  void _handleDeleteAccountPressed() {
    context.read<DashboardBloc>().add(const DashboardDeleteAccountPressed());
  }

  Future<void> _showDeleteAccountDialog() async {
    final accountName = context.read<DashboardBloc>().state.accountName;
    final deleted = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0x990E1919),
      builder: (context) {
        return DeleteAccountDialog(
          accountName: accountName,
          onDeletePressed: () {
            final result = Completer<bool>();
            this.context.read<DashboardBloc>().add(
              DashboardDeleteAccountConfirmed(result),
            );
            return result.future;
          },
        );
      },
    );

    if (!mounted || deleted != false) return;
    _showEntrySnackBar(
      context,
      message: 'Could not delete account',
      isError: true,
    );
  }

  void _showEntrySnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final colors = AppColors.context(context);
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          elevation: 0,
          duration: const Duration(seconds: 2),
          backgroundColor: isError
              ? colors.errorColor
              : const Color(0xFF263031),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          content: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (actionLabel != null && onActionPressed != null) ...[
                const SizedBox(width: 12),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(44, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: const Color(0xFF4FD3D8),
                    textStyle: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  onPressed: () {
                    messenger.hideCurrentSnackBar();
                    onActionPressed();
                  },
                  child: Text(actionLabel),
                ),
              ],
            ],
          ),
        ),
      );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.onThemePressed,
    required this.onAccountPressed,
  });

  final VoidCallback onThemePressed;
  final VoidCallback onAccountPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DashboardBloc, DashboardState, DashboardState>(
      selector: (state) => state,
      builder: (context, state) {
        return SliverToBoxAdapter(
          child: EntryHomeHeader(
            accountName: state.accountName,
            monthAmount: state.monthAmount,
            syncLabel: state.isSyncingTotals ? 'syncing...' : 'synced just now',
            isSyncing: state.isSyncingTotals,
            lastSyncedAt: state.lastSyncedAt,
            onThemePressed: onThemePressed,
            onAccountPressed: onAccountPressed,
          ),
        );
      },
    );
  }
}

class _DashboardSearch extends StatelessWidget {
  const _DashboardSearch({
    required this.searchController,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: EntrySearchField(
        controller: searchController,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _DashboardCategories extends StatelessWidget {
  const _DashboardCategories();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EntryFeedBloc, EntryFeedState, String?>(
      selector: (state) => state.selectedCategory,
      builder: (context, selectedCategory) {
        return SliverToBoxAdapter(
          child: CategoryChooseChipRow(
            selectedCategory: selectedCategory,
            onSelectCategory: (category) {
              context.read<EntryFeedBloc>().add(
                EntryFeedCategorySelected(category),
              );
            },
          ),
        );
      },
    );
  }
}

class _DashboardFilteringBar extends StatelessWidget {
  const _DashboardFilteringBar();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EntryFeedBloc, EntryFeedState, bool>(
      selector: (state) => state.isFiltering,
      builder: (context, isFiltering) {
        return SliverToBoxAdapter(
          child: EntryFilteringBar(isVisible: isFiltering),
        );
      },
    );
  }
}

class _DashboardFeed extends StatelessWidget {
  const _DashboardFeed({required this.onEntryPressed});

  final ValueChanged<EntryBrief> onEntryPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EntryFeedBloc, EntryFeedState, _FeedSelection>(
      selector: (state) {
        return (
          entries: state.entries,
          errorMessage: state.errorMessage,
          hasReachedMax: state.hasReachedMax,
          isFiltering: state.isFiltering,
          isLoading: state.isLoading,
          isPageLoading: state.isPageLoading,
        );
      },
      builder: (context, state) {
        if (state.isLoading && state.entries.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null && state.entries.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text(state.errorMessage!)),
          );
        }

        if (state.entries.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EntryEmptyFeed(),
          );
        }

        return EntryFeedList(
          entries: state.entries,
          isPageLoading: state.isPageLoading,
          hasReachedMax: state.hasReachedMax,
          onEntryPressed: onEntryPressed,
          onDeleteEntry: (entry) {
            context.read<EntryFeedBloc>().add(EntryFeedEntryDeleted(entry));
          },
          onLoadMore: state.isFiltering
              ? null
              : () {
                  context.read<EntryFeedBloc>().add(
                    const EntryFeedNextPageRequested(),
                  );
                },
        );
      },
    );
  }
}

typedef _FeedSelection = ({
  List<EntryBrief> entries,
  String? errorMessage,
  bool hasReachedMax,
  bool isFiltering,
  bool isLoading,
  bool isPageLoading,
});

class _DashboardAddButton extends StatelessWidget {
  const _DashboardAddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Positioned(
      right: 16,
      bottom: 20,
      child: SizedBox.square(
        dimension: 60,
        child: FloatingActionButton.large(
          tooltip: 'New entry',
          elevation: 6,
          backgroundColor: colors.primaryColor,
          foregroundColor: colors.activeButtonContentColor,
          onPressed: onPressed,
          child: const Icon(Icons.add_rounded, size: 24, weight: 2),
        ),
      ),
    );
  }
}
