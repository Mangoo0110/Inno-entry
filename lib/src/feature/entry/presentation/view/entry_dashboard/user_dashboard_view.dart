import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_feed_bloc.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_category_chip_row.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_empty_feed.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_feed_list.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_filtering_bar.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_home_header.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_search_field.dart';
import 'package:inno_entry/src/feature/entry/presentation/widgets/entry_delete_button.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_detail/entry_detail_result.dart';

typedef _HeaderSelection = ({
  String accountName,
  double monthAmount,
  bool isSyncing,
  DateTime? lastSyncedAt,
});
typedef _CategorySelection = ({
  List<EntryCategory> categories,
  String selectedCategory,
});
typedef _FeedSelection = ({
  List<EntryBrief> entries,
  String? errorMessage,
  bool hasReachedMax,
  bool isFiltering,
  bool isLoading,
  bool isPageLoading,
});

class UserDashboardView extends StatelessWidget {
  const UserDashboardView({
    super.key,
    required this.accountName,
    required this.createBloc,
    required this.onLogoutPressed,
    required this.onDeleteAccountPressed,
    required this.onThemePressed,
    required this.onAddEntryPressed,
    required this.onEntryPressed,
  });

  final String accountName;
  final EntryFeedBloc Function(String accountName) createBloc;
  final Future<void> Function() onLogoutPressed;
  final Future<bool> Function() onDeleteAccountPressed;
  final VoidCallback onThemePressed;
  final Future<bool?> Function() onAddEntryPressed;
  final Future<EntryDetailResult?> Function(EntryBrief entry) onEntryPressed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(accountName),
      create: (_) => createBloc(accountName),
      child: _UserDashboardContent(
        accountName: accountName,
        onLogoutPressed: onLogoutPressed,
        onDeleteAccountPressed: onDeleteAccountPressed,
        onThemePressed: onThemePressed,
        onAddEntryPressed: onAddEntryPressed,
        onEntryPressed: onEntryPressed,
      ),
    );
  }
}

class _UserDashboardContent extends StatefulWidget {
  const _UserDashboardContent({
    required this.accountName,
    required this.onLogoutPressed,
    required this.onDeleteAccountPressed,
    required this.onThemePressed,
    required this.onAddEntryPressed,
    required this.onEntryPressed,
  });

  final String accountName;
  final Future<void> Function() onLogoutPressed;
  final Future<bool> Function() onDeleteAccountPressed;
  final VoidCallback onThemePressed;
  final Future<bool?> Function() onAddEntryPressed;
  final Future<EntryDetailResult?> Function(EntryBrief entry) onEntryPressed;

  @override
  State<_UserDashboardContent> createState() => _UserDashboardContentState();
}

class _UserDashboardContentState extends State<_UserDashboardContent> {
  late final TextEditingController _searchController;
  Timer? _searchDebounce;
  bool _isAccountMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EntryFeedBloc, EntryFeedState>(
      listenWhen: (previous, current) {
        final hasNewError =
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null &&
            current.entries.isNotEmpty;
        final hasNewEffect =
            previous.effect != current.effect && current.effect != null;
        return hasNewError || hasNewEffect;
      },
      listener: (context, state) {
        final effect = state.effect;
        if (effect is EntryFeedSavedEffect) {
          _showEntrySnackBar(context, message: 'Saved');
          context.read<EntryFeedBloc>().add(const EntryFeedEffectHandled());
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
            },
          );
          context.read<EntryFeedBloc>().add(const EntryFeedEffectHandled());
          return;
        }
        final errorMessage = state.errorMessage;
        if (errorMessage == null) return;
        _showEntrySnackBar(context, message: errorMessage, isError: true);
      },
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
                      _searchDebounce?.cancel();
                      _submitSearch(search);
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  const _DashboardCategories(),
                  const _DashboardFilteringBar(),
                  _DashboardFeed(onEntryPressed: _openEntry),
                ],
              ),
              _DashboardAddButton(onPressed: _openAddEntry),
              if (_isAccountMenuOpen) ...[
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
                  child: _DashboardAccountMenu(
                    onLogoutPressed: _handleLogoutPressed,
                    onDeleteAccountPressed: _handleDeleteAccountPressed,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAddEntry() async {
    _closeAccountMenu();
    final saved = await widget.onAddEntryPressed();
    if (!mounted || saved != true) return;
    context.read<EntryFeedBloc>()
      ..add(const EntryFeedStarted())
      ..add(const EntryFeedSaveConfirmed());
  }

  Future<void> _openEntry(EntryBrief entry) async {
    _closeAccountMenu();
    final result = await widget.onEntryPressed(entry);
    if (!mounted || result == null) return;

    final bloc = context.read<EntryFeedBloc>()..add(const EntryFeedStarted());
    if (result is EntryDetailSaved) {
      bloc.add(const EntryFeedSaveConfirmed());
    } else if (result is EntryDetailDeleted) {
      showEntryDeletedSnackBar(
        context,
        actionLabel: 'UNDO',
        onActionPressed: () {
          context.read<EntryFeedBloc>().add(
            EntryFeedEntryDeleteUndone(result.entry),
          );
        },
      );
    }
  }

  void _scheduleSearch(String search) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _submitSearch(search);
    });
  }

  void _submitSearch(String search) {
    context.read<EntryFeedBloc>().add(EntryFeedSearchSubmitted(search.trim()));
  }

  void _toggleAccountMenu() {
    setState(() => _isAccountMenuOpen = !_isAccountMenuOpen);
  }

  void _handleThemePressed() {
    _closeAccountMenu();
    widget.onThemePressed();
  }

  void _closeAccountMenu() {
    if (!_isAccountMenuOpen || !mounted) return;
    setState(() => _isAccountMenuOpen = false);
  }

  Future<void> _handleLogoutPressed() async {
    _closeAccountMenu();
    await widget.onLogoutPressed();
  }

  Future<void> _handleDeleteAccountPressed() async {
    _closeAccountMenu();
    final deleted = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0x990E1919),
      builder: (context) {
        return _DeleteAccountDialog(
          accountName: widget.accountName,
          onDeletePressed: widget.onDeleteAccountPressed,
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
    return BlocSelector<EntryFeedBloc, EntryFeedState, _HeaderSelection>(
      selector: (state) {
        return (
          accountName: state.accountName,
          monthAmount: state.monthAmount,
          isSyncing:
              state.isLoading || state.isFiltering || state.isPageLoading,
          lastSyncedAt: state.lastSyncedAt,
        );
      },
      builder: (context, state) {
        return SliverToBoxAdapter(
          child: EntryHomeHeader(
            accountName: state.accountName,
            monthAmount: state.monthAmount,
            syncLabel: state.isSyncing ? 'syncing...' : 'synced just now',
            isSyncing: state.isSyncing,
            lastSyncedAt: state.lastSyncedAt,
            onThemePressed: onThemePressed,
            onAccountPressed: onAccountPressed,
          ),
        );
      },
    );
  }
}

class _DashboardAccountMenu extends StatelessWidget {
  const _DashboardAccountMenu({
    required this.onLogoutPressed,
    required this.onDeleteAccountPressed,
  });

  final VoidCallback onLogoutPressed;
  final VoidCallback onDeleteAccountPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Material(
      color: colors.popupBackgroundColor,
      elevation: 14,
      shadowColor: Colors.black.withAlpha(45),
      borderRadius: BorderRadius.circular(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DashboardAccountMenuItem(
                icon: Icons.logout_rounded,
                label: 'Log out',
                color: colors.textColor,
                onPressed: onLogoutPressed,
              ),
              const SizedBox(height: 4),
              _DashboardAccountMenuItem(
                icon: Icons.delete_outline_rounded,
                label: 'Delete account',
                color: colors.errorColor,
                onPressed: onDeleteAccountPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardAccountMenuItem extends StatelessWidget {
  const _DashboardAccountMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 46,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
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

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({
    required this.accountName,
    required this.onDeletePressed,
  });

  final String accountName;
  final Future<bool> Function() onDeletePressed;

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 332),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.popupBackgroundColor,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 28, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete account?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colors.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'This permanently removes "${widget.accountName}" and all '
                  'of its entries, photos, and settings from this device. '
                  'Other accounts are not affected.',
                  maxLines: 6,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.textColor.withAlpha(220),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isDeleting
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.primaryColor,
                        textStyle: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isDeleting ? null : _deleteAccount,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(92, 40),
                        backgroundColor: const Color(0xFFC81E1E),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: colors.errorColor.withAlpha(
                          150,
                        ),
                        disabledForegroundColor: Colors.white,
                        textStyle: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      child: _isDeleting
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    setState(() => _isDeleting = true);
    final deleted = await widget.onDeletePressed();
    if (!mounted) return;
    Navigator.of(context).pop(deleted);
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
    return BlocSelector<EntryFeedBloc, EntryFeedState, _CategorySelection>(
      selector: (state) {
        return (
          categories: state.categories,
          selectedCategory: state.selectedCategory,
        );
      },
      builder: (context, state) {
        return SliverToBoxAdapter(
          child: EntryCategoryChipRow(
            categories: state.categories,
            selectedCategory: state.selectedCategory,
            onSelected: (category) {
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

  final Future<void> Function(EntryBrief entry) onEntryPressed;

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
