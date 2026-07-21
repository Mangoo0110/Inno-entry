import 'package:get_it/get_it.dart';
import 'package:inno_entry/src/app/bloc/auth_guard/app_auth_guard_bloc.dart';
import 'package:inno_entry/src/app/bloc/dashboard/dashboard_bloc.dart';
import 'package:inno_entry/src/app/bloc/app_theme_cubit.dart';
import 'package:inno_entry/src/feature/category/data/repo/category_repo_impl.dart';
import 'package:inno_entry/src/feature/category/domain/repo/category_repo.dart';
import 'package:inno_entry/src/feature/category/domain/usecases/category_usecases.dart';
import 'package:inno_entry/src/feature/category/presentation/bloc/category_choose_bloc.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/auth_storage.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/interface/auth_datasources.dart';
import 'package:inno_entry/src/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';
import 'package:inno_entry/src/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/login/login_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/register/register_bloc.dart';
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
  if (!serviceLocator.isRegistered<CategoryRepo>()) {
    serviceLocator.registerLazySingleton<CategoryRepo>(CategoryRepoImpl.new);
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

  _registerFactoryIfAbsent<GetEntryCategories>(
    () => GetEntryCategories(serviceLocator()),
  );

  _registerFactoryIfAbsent<GetEntries>(() => GetEntries(serviceLocator()));
  _registerFactoryIfAbsent<AddNewEntry>(() => AddNewEntry(serviceLocator()));
  _registerFactoryIfAbsent<DeleteEntry>(() => DeleteEntry(serviceLocator()));
  _registerFactoryIfAbsent<DeleteAllEntry>(
    () => DeleteAllEntry(serviceLocator()),
  );
  _registerFactoryIfAbsent<GetEntryDetails>(
    () => GetEntryDetails(serviceLocator()),
  );
  _registerFactoryIfAbsent<GetEntryTotalAmount>(
    () => GetEntryTotalAmount(serviceLocator()),
  );
  _registerFactoryIfAbsent<MarkEntryDone>(
    () => MarkEntryDone(serviceLocator()),
  );
  _registerFactoryIfAbsent<UpdateEntry>(() => UpdateEntry(serviceLocator()));
  _registerFactoryIfAbsent<RestoreDeletedEntry>(
    () => RestoreDeletedEntry(serviceLocator()),
  );

  if (!serviceLocator.isRegistered<AppAuthGuardBloc>()) {
    serviceLocator.registerLazySingleton<AppAuthGuardBloc>(
      () =>
          AppAuthGuardBloc(watchAuthStatus: serviceLocator())
            ..add(const AppAuthGuardStarted()),
      dispose: (bloc) => bloc.close(),
    );
  }
  if (!serviceLocator.isRegistered<AppThemeCubit>()) {
    serviceLocator.registerLazySingleton<AppThemeCubit>(
      AppThemeCubit.new,
      dispose: (cubit) => cubit.close(),
    );
  }

  if (!serviceLocator.isRegistered<DashboardBloc>()) {
    serviceLocator.registerFactoryParam<DashboardBloc, String, void>(
      (accountName, _) => DashboardBloc(
        accountName: accountName,
        logout: serviceLocator(),
        deleteCurrentAccount: serviceLocator(),
        deleteAllEntry: serviceLocator(),
        getEntryTotalAmount: serviceLocator(),
      ),
    );
  }
  if (!serviceLocator.isRegistered<CategoryChooseBloc>()) {
    serviceLocator.registerFactory<CategoryChooseBloc>(
      () =>
          CategoryChooseBloc(getEntryCategories: serviceLocator())
            ..add(const CategoryChooseStarted()),
    );
  }

  _registerFactoryIfAbsent<LoginBloc>(
    () => LoginBloc(
      isAccountNameAvailable: serviceLocator(),
      unlockAccount: serviceLocator(),
    ),
  );
  _registerFactoryIfAbsent<RegisterBloc>(
    () => RegisterBloc(
      isAccountNameAvailable: serviceLocator(),
      createAccount: serviceLocator(),
    ),
  );
  if (!serviceLocator.isRegistered<EntryFeedBloc>()) {
    serviceLocator.registerFactoryParam<EntryFeedBloc, String, void>(
      (accountName, _) => EntryFeedBloc(
        accountName: accountName,
        getEntries: serviceLocator(),
        getEntryDetails: serviceLocator(),
        getEntryTotalAmount: serviceLocator(),
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
            getEntryTotalAmount: serviceLocator(),
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
