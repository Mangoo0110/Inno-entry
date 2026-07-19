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
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_detail_bloc.dart';
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_feed_bloc.dart';
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_form_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> configureDependencies({
  AuthStorage? authStorage,
  EntryStorage? entryStorage,
  bool reset = false,
}) async {
  if (reset) await serviceLocator.reset(dispose: true);

  if (!serviceLocator.isRegistered<AuthLocalDatasource>()) {
    final resolvedAuthStorage = authStorage ?? AuthStorage();
    await resolvedAuthStorage.init();
    serviceLocator.registerSingleton<AuthLocalDatasource>(resolvedAuthStorage);
  }

  if (!serviceLocator.isRegistered<EntryLocalDatasource>()) {
    final resolvedEntryStorage = entryStorage ?? EntryStorage();
    await resolvedEntryStorage.init();
    serviceLocator.registerSingleton<EntryLocalDatasource>(
      resolvedEntryStorage,
    );
  }

  if (!serviceLocator.isRegistered<AuthRepo>()) {
    serviceLocator.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(authLocalDatasource: serviceLocator()),
    );
  }
  if (!serviceLocator.isRegistered<EntryRepo>()) {
    serviceLocator.registerLazySingleton<EntryRepo>(
      () => EntryRepoImpl(entryLocalDatasource: serviceLocator()),
    );
  }

  _registerFactoryIfAbsent<WatchAuthStatus>(
    () => WatchAuthStatus(serviceLocator()),
  );
  _registerFactoryIfAbsent<GetAccounts>(() => GetAccounts(serviceLocator()));
  _registerFactoryIfAbsent<IsAccountNameAvailable>(
    () => IsAccountNameAvailable(serviceLocator()),
  );
  _registerFactoryIfAbsent<CreateAccount>(
    () => CreateAccount(serviceLocator()),
  );
  _registerFactoryIfAbsent<UnlockAccount>(
    () => UnlockAccount(serviceLocator()),
  );
  _registerFactoryIfAbsent<Logout>(() => Logout(serviceLocator()));
  _registerFactoryIfAbsent<DeleteCurrentAccount>(
    () => DeleteCurrentAccount(serviceLocator()),
  );
  _registerFactoryIfAbsent<LoginWithExistingAccount>(
    () => LoginWithExistingAccount(serviceLocator()),
  );

  _registerFactoryIfAbsent<GetEntries>(() => GetEntries(serviceLocator()));
  _registerFactoryIfAbsent<GetEntryCategories>(
    () => GetEntryCategories(serviceLocator()),
  );
  _registerFactoryIfAbsent<AddNewEntry>(() => AddNewEntry(serviceLocator()));
  _registerFactoryIfAbsent<DeleteEntry>(() => DeleteEntry(serviceLocator()));
  _registerFactoryIfAbsent<DeleteAllEntry>(
    () => DeleteAllEntry(serviceLocator()),
  );
  _registerFactoryIfAbsent<GetEntryDetails>(
    () => GetEntryDetails(serviceLocator()),
  );
  _registerFactoryIfAbsent<MarkEntryDone>(
    () => MarkEntryDone(serviceLocator()),
  );
  _registerFactoryIfAbsent<UpdateEntry>(() => UpdateEntry(serviceLocator()));
  _registerFactoryIfAbsent<RestoreDeletedEntry>(
    () => RestoreDeletedEntry(serviceLocator()),
  );

  _registerFactoryIfAbsent<AppAuthUiController>(
    () => AppAuthUiController(
      watchAuthStatus: serviceLocator(),
      logout: serviceLocator(),
      deleteCurrentAccount: serviceLocator(),
      deleteAllEntry: serviceLocator(),
    ),
  );
  _registerFactoryIfAbsent<AuthBloc>(
    () => AuthBloc(
      watchAuthStatus: serviceLocator(),
      getAccounts: serviceLocator(),
      isAccountNameAvailable: serviceLocator(),
      createAccount: serviceLocator(),
      unlockAccount: serviceLocator(),
      logout: serviceLocator(),
    ),
  );
  if (!serviceLocator.isRegistered<EntryFeedBloc>()) {
    serviceLocator.registerFactoryParam<EntryFeedBloc, String, void>(
      (accountName, _) => EntryFeedBloc(
        accountName: accountName,
        getEntries: serviceLocator(),
        getEntryCategories: serviceLocator(),
        getEntryDetails: serviceLocator(),
        deleteEntry: serviceLocator(),
        restoreDeletedEntry: serviceLocator(),
      )..add(const EntryFeedStarted()),
    );
  }
  if (!serviceLocator.isRegistered<EntryFormBloc>()) {
    serviceLocator
        .registerFactoryParam<EntryFormBloc, EntryFormBlocParams, void>(
          (params, _) => EntryFormBloc(
            params: params,
            getEntryCategories: serviceLocator(),
            getEntries: serviceLocator(),
            getEntryDetails: serviceLocator(),
            addNewEntry: serviceLocator(),
            updateEntry: serviceLocator(),
          )..add(const EntryFormStarted()),
        );
  }
  if (!serviceLocator.isRegistered<EntryDetailBloc>()) {
    serviceLocator
        .registerFactoryParam<EntryDetailBloc, EntryDetailBlocParams, void>(
          (params, _) => EntryDetailBloc(
            params: params,
            getEntryDetails: serviceLocator(),
            deleteEntry: serviceLocator(),
          )..add(const EntryDetailStarted()),
        );
  }
}

void _registerFactoryIfAbsent<T extends Object>(T Function() factoryFunc) {
  if (serviceLocator.isRegistered<T>()) return;
  serviceLocator.registerFactory<T>(factoryFunc);
}
