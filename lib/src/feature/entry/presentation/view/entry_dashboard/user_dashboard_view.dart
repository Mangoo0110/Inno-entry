import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_brief.dart';
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_feed_bloc.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_category_chip_row.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_empty_feed.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_feed_list.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_home_header.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/widgets/entry_search_field.dart';

typedef _HeaderSelection = ({
  String accountName,
  double monthAmount,
  String syncLabel,
});
typedef _CategorySelection = ({
  List<EntryCategory> categories,
  String selectedCategory,
});
typedef _FeedSelection = ({
  List<EntryBrief> entries,
  String? errorMessage,
  bool hasReachedMax,
  bool isLoading,
  bool isPageLoading,
});

class UserDashboardView extends StatelessWidget {
  const UserDashboardView({
    super.key,
    required this.accountName,
    required this.createBloc,
    required this.onAccountPressed,
    required this.onAddEntryPressed,
    required this.onEntryPressed,
  });

  final String accountName;
  final EntryFeedBloc Function(String accountName) createBloc;
  final VoidCallback onAccountPressed;
  final Future<bool?> Function() onAddEntryPressed;
  final Future<bool?> Function(EntryBrief entry) onEntryPressed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(accountName),
      create: (_) => createBloc(accountName),
      child: _UserDashboardContent(
        onAccountPressed: onAccountPressed,
        onAddEntryPressed: onAddEntryPressed,
        onEntryPressed: onEntryPressed,
      ),
    );
  }
}

class _UserDashboardContent extends StatefulWidget {
  const _UserDashboardContent({
    required this.onAccountPressed,
    required this.onAddEntryPressed,
    required this.onEntryPressed,
  });

  final VoidCallback onAccountPressed;
  final Future<bool?> Function() onAddEntryPressed;
  final Future<bool?> Function(EntryBrief entry) onEntryPressed;

  @override
  State<_UserDashboardContent> createState() => _UserDashboardContentState();
}

class _UserDashboardContentState extends State<_UserDashboardContent> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EntryFeedBloc, EntryFeedState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage &&
            current.errorMessage != null &&
            current.entries.isNotEmpty;
      },
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _DashboardHeader(onAccountPressed: widget.onAccountPressed),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  _DashboardSearch(searchController: _searchController),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  const _DashboardCategories(),
                  _DashboardFeed(onEntryPressed: _openEntry),
                ],
              ),
              _DashboardAddButton(onPressed: _openAddEntry),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAddEntry() async {
    final saved = await widget.onAddEntryPressed();
    if (!mounted || saved != true) return;
    context.read<EntryFeedBloc>().add(const EntryFeedStarted());
  }

  Future<void> _openEntry(EntryBrief entry) async {
    final saved = await widget.onEntryPressed(entry);
    if (!mounted || saved != true) return;
    context.read<EntryFeedBloc>().add(const EntryFeedStarted());
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.onAccountPressed});

  final VoidCallback onAccountPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EntryFeedBloc, EntryFeedState, _HeaderSelection>(
      selector: (state) {
        return (
          accountName: state.accountName,
          monthAmount: state.monthAmount,
          syncLabel: state.isLoading || state.isPageLoading
              ? 'syncing...'
              : 'synced just now',
        );
      },
      builder: (context, state) {
        return SliverToBoxAdapter(
          child: EntryHomeHeader(
            accountName: state.accountName,
            monthAmount: state.monthAmount,
            syncLabel: state.syncLabel,
            onAccountPressed: onAccountPressed,
          ),
        );
      },
    );
  }
}

class _DashboardSearch extends StatelessWidget {
  const _DashboardSearch({required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: EntrySearchField(
        controller: searchController,
        onSubmitted: (search) {
          context.read<EntryFeedBloc>().add(
            EntryFeedSearchSubmitted(search.trim()),
          );
        },
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
          onLoadMore: () {
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
