import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/app/bloc/app_theme_cubit.dart';
import 'package:inno_entry/src/app/bloc/auth_guard/app_auth_guard_bloc.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/auth_storage.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/interface/auth_datasources.dart';
import 'package:inno_entry/src/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';
import 'package:inno_entry/src/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:inno_entry/src/feature/category/data/repo/category_repo_impl.dart';
import 'package:inno_entry/src/feature/category/domain/repo/category_repo.dart';
import 'package:inno_entry/src/feature/category/domain/usecases/category_usecases.dart';
import 'package:inno_entry/src/feature/entry/data/datasources/entry_storage.dart';
import 'package:inno_entry/src/feature/entry/data/datasources/interface/entry_datasources.dart';
import 'package:inno_entry/src/feature/entry/data/repo/entry_repo_impl.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/entry_usecases.dart';

final class AppDependencies {
  const AppDependencies._({
    required this.authLocalDatasource,
    required this.entryLocalDatasource,
    required this.authRepo,
    required this.categoryRepo,
    required this.entryRepo,
    required this.watchAuthStatus,
    required this.getAccounts,
    required this.isAccountNameAvailable,
    required this.createAccount,
    required this.unlockAccount,
    required this.logout,
    required this.deleteCurrentAccount,
    required this.loginWithExistingAccount,
    required this.getEntryCategories,
    required this.getEntries,
    required this.addNewEntry,
    required this.deleteEntry,
    required this.deleteAllEntry,
    required this.getEntryDetails,
    required this.getEntryTotalAmount,
    required this.markEntryDone,
    required this.updateEntry,
    required this.restoreDeletedEntry,
    required this.authGuardBloc,
    required this.appThemeCubit,
  });

  final AuthLocalDatasource authLocalDatasource;
  final EntryLocalDatasource entryLocalDatasource;
  final AuthRepo authRepo;
  final CategoryRepo categoryRepo;
  final EntryRepo entryRepo;
  final WatchAuthStatus watchAuthStatus;
  final GetAccounts getAccounts;
  final IsAccountNameAvailable isAccountNameAvailable;
  final CreateAccount createAccount;
  final UnlockAccount unlockAccount;
  final Logout logout;
  final DeleteCurrentAccount deleteCurrentAccount;
  final LoginWithExistingAccount loginWithExistingAccount;
  final GetEntryCategories getEntryCategories;
  final GetEntries getEntries;
  final AddNewEntry addNewEntry;
  final DeleteEntry deleteEntry;
  final DeleteAllEntry deleteAllEntry;
  final GetEntryDetails getEntryDetails;
  final GetEntryTotalAmount getEntryTotalAmount;
  final MarkEntryDone markEntryDone;
  final UpdateEntry updateEntry;
  final RestoreDeletedEntry restoreDeletedEntry;
  final AppAuthGuardBloc authGuardBloc;
  final AppThemeCubit appThemeCubit;

  static Future<AppDependencies> create({
    AuthStorage? authStorage,
    EntryStorage? entryStorage,
  }) async {
    final resolvedAuthStorage = authStorage ?? AuthStorage();
    await resolvedAuthStorage.init();

    final resolvedEntryStorage = entryStorage ?? EntryStorage();
    await resolvedEntryStorage.init();

    final authRepo = AuthRepoImpl(authLocalDatasource: resolvedAuthStorage);
    final categoryRepo = CategoryRepoImpl();
    final entryRepo = EntryRepoImpl(entryLocalDatasource: resolvedEntryStorage);

    final watchAuthStatus = WatchAuthStatus(authRepo);
    final authGuardBloc = AppAuthGuardBloc(watchAuthStatus: watchAuthStatus)
      ..add(const AppAuthGuardStarted());

    return AppDependencies._(
      authLocalDatasource: resolvedAuthStorage,
      entryLocalDatasource: resolvedEntryStorage,
      authRepo: authRepo,
      categoryRepo: categoryRepo,
      entryRepo: entryRepo,
      watchAuthStatus: watchAuthStatus,
      getAccounts: GetAccounts(authRepo),
      isAccountNameAvailable: IsAccountNameAvailable(authRepo),
      createAccount: CreateAccount(authRepo),
      unlockAccount: UnlockAccount(authRepo),
      logout: Logout(authRepo),
      deleteCurrentAccount: DeleteCurrentAccount(authRepo),
      loginWithExistingAccount: LoginWithExistingAccount(authRepo),
      getEntryCategories: GetEntryCategories(categoryRepo),
      getEntries: GetEntries(entryRepo),
      addNewEntry: AddNewEntry(entryRepo),
      deleteEntry: DeleteEntry(entryRepo),
      deleteAllEntry: DeleteAllEntry(entryRepo),
      getEntryDetails: GetEntryDetails(entryRepo),
      getEntryTotalAmount: GetEntryTotalAmount(entryRepo),
      markEntryDone: MarkEntryDone(entryRepo),
      updateEntry: UpdateEntry(entryRepo),
      restoreDeletedEntry: RestoreDeletedEntry(entryRepo),
      authGuardBloc: authGuardBloc,
      appThemeCubit: AppThemeCubit(),
    );
  }

  Future<void> dispose() async {
    await authGuardBloc.close();
    await appThemeCubit.close();
    authLocalDatasource.dispose();
    await entryLocalDatasource.dispose();
  }
}

class AppDependencyScope extends StatelessWidget {
  const AppDependencyScope({
    super.key,
    required this.dependencies,
    required this.child,
  });

  final AppDependencies dependencies;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDependencies>.value(value: dependencies),
        RepositoryProvider<AuthLocalDatasource>.value(
          value: dependencies.authLocalDatasource,
        ),
        RepositoryProvider<EntryLocalDatasource>.value(
          value: dependencies.entryLocalDatasource,
        ),
        RepositoryProvider<AuthRepo>.value(value: dependencies.authRepo),
        RepositoryProvider<CategoryRepo>.value(
          value: dependencies.categoryRepo,
        ),
        RepositoryProvider<EntryRepo>.value(value: dependencies.entryRepo),
        RepositoryProvider<WatchAuthStatus>.value(
          value: dependencies.watchAuthStatus,
        ),
        RepositoryProvider<GetAccounts>.value(value: dependencies.getAccounts),
        RepositoryProvider<IsAccountNameAvailable>.value(
          value: dependencies.isAccountNameAvailable,
        ),
        RepositoryProvider<CreateAccount>.value(
          value: dependencies.createAccount,
        ),
        RepositoryProvider<UnlockAccount>.value(
          value: dependencies.unlockAccount,
        ),
        RepositoryProvider<Logout>.value(value: dependencies.logout),
        RepositoryProvider<DeleteCurrentAccount>.value(
          value: dependencies.deleteCurrentAccount,
        ),
        RepositoryProvider<LoginWithExistingAccount>.value(
          value: dependencies.loginWithExistingAccount,
        ),
        RepositoryProvider<GetEntryCategories>.value(
          value: dependencies.getEntryCategories,
        ),
        RepositoryProvider<GetEntries>.value(value: dependencies.getEntries),
        RepositoryProvider<AddNewEntry>.value(value: dependencies.addNewEntry),
        RepositoryProvider<DeleteEntry>.value(value: dependencies.deleteEntry),
        RepositoryProvider<DeleteAllEntry>.value(
          value: dependencies.deleteAllEntry,
        ),
        RepositoryProvider<GetEntryDetails>.value(
          value: dependencies.getEntryDetails,
        ),
        RepositoryProvider<GetEntryTotalAmount>.value(
          value: dependencies.getEntryTotalAmount,
        ),
        RepositoryProvider<MarkEntryDone>.value(
          value: dependencies.markEntryDone,
        ),
        RepositoryProvider<UpdateEntry>.value(value: dependencies.updateEntry),
        RepositoryProvider<RestoreDeletedEntry>.value(
          value: dependencies.restoreDeletedEntry,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppAuthGuardBloc>.value(
            value: dependencies.authGuardBloc,
          ),
          BlocProvider<AppThemeCubit>.value(value: dependencies.appThemeCubit),
        ],
        child: child,
      ),
    );
  }
}
