import 'package:get_it/get_it.dart';
import 'package:inno_entry/src/app/bloc/app_auth_ui_controller.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/auth_storage.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/interface/auth_datasources.dart';
import 'package:inno_entry/src/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';
import 'package:inno_entry/src/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inno_entry/src/feature/entry/data/datasources/entry_storage.dart';
import 'package:inno_entry/src/feature/entry/data/datasources/interface/entry_datasources.dart';
import 'package:inno_entry/src/feature/entry/data/repo/entry_repo_impl.dart';
import 'package:inno_entry/src/feature/entry/domain/repo/entry_repo.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/entry_usecases.dart';
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_feed_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> configureDependencies({
  AuthStorage? authStorage,
  EntryStorage? entryStorage,
  bool reset = false,
}) async {
  if (reset) await serviceLocator.reset(dispose: true);
  if (serviceLocator.isRegistered<AuthLocalDatasource>()) return;

  final resolvedAuthStorage = authStorage ?? AuthStorage();
  await resolvedAuthStorage.init();

  final resolvedEntryStorage = entryStorage ?? EntryStorage();
  await resolvedEntryStorage.init();

  serviceLocator.registerSingleton<AuthLocalDatasource>(resolvedAuthStorage);
  serviceLocator.registerSingleton<EntryLocalDatasource>(resolvedEntryStorage);

  serviceLocator.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(authLocalDatasource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<EntryRepo>(
    () => EntryRepoImpl(entryLocalDatasource: serviceLocator()),
  );

  serviceLocator.registerFactory(() => WatchAuthStatus(serviceLocator()));
  serviceLocator.registerFactory(() => GetAccounts(serviceLocator()));
  serviceLocator.registerFactory(
    () => IsAccountNameAvailable(serviceLocator()),
  );
  serviceLocator.registerFactory(() => CreateAccount(serviceLocator()));
  serviceLocator.registerFactory(() => UnlockAccount(serviceLocator()));
  serviceLocator.registerFactory(() => Logout(serviceLocator()));
  serviceLocator.registerFactory(() => DeleteCurrentAccount(serviceLocator()));
  serviceLocator.registerFactory(
    () => LoginWithExistingAccount(serviceLocator()),
  );

  serviceLocator.registerFactory(() => GetEntries(serviceLocator()));
  serviceLocator.registerFactory(() => GetEntryCategories(serviceLocator()));
  serviceLocator.registerFactory(() => AddNewEntry(serviceLocator()));
  serviceLocator.registerFactory(() => DeleteEntry(serviceLocator()));
  serviceLocator.registerFactory(() => DeleteAllEntry(serviceLocator()));
  serviceLocator.registerFactory(() => GetEntryDetails(serviceLocator()));
  serviceLocator.registerFactory(() => MarkEntryDone(serviceLocator()));
  serviceLocator.registerFactory(() => UpdateEntry(serviceLocator()));

  serviceLocator.registerFactory(
    () => AppAuthUiController(
      watchAuthStatus: serviceLocator(),
      logout: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => AuthBloc(
      watchAuthStatus: serviceLocator(),
      getAccounts: serviceLocator(),
      isAccountNameAvailable: serviceLocator(),
      createAccount: serviceLocator(),
      unlockAccount: serviceLocator(),
      logout: serviceLocator(),
    ),
  );
  serviceLocator.registerFactoryParam<EntryFeedBloc, String, void>(
    (accountName, _) => EntryFeedBloc(
      accountName: accountName,
      getEntries: serviceLocator(),
      getEntryCategories: serviceLocator(),
    )..add(const EntryFeedStarted()),
  );
}
