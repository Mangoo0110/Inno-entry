import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/interface/auth_datasources.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/interface/auth.dart';
import 'package:inno_entry/src/feature/auth/data/models/account_model.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_params.dart';

import '../../../../core/utils/debug/debug_service.dart';
import '../../domain/entities/auth_status.dart';
import 'interface/current_auth_ref_manager_interface.dart';

part 'auth_manager.dart';
part 'current_auth_ref_manager.dart';

// class _AuthStatusDecider {
//   static AuthStatus get(String accountName, String? token) {
//     if (auth == null) {
//       return Unauthenticated();
//     }
//     return Authenticated(AccountModel(uniqueName: accountName, token: token));
//   }
// }

base class AuthStorage implements AuthLocalDatasource {
  AuthStorage() {
    _authStreamController.add(LoadingAuthSignature());
    _authManager = _AuthManager(_authDebugger);
    _currentAuthUidManager = _CurrentAuthUidManager();
  }

  late final _AuthManager _authManager;
  late final _CurrentAuthUidManager _currentAuthUidManager;

  final Debugger _authDebugger = AuthDebugger();
  final StreamController<AuthStatus> _authStreamController =
      StreamController.broadcast();

  @override
  dispose() {
    _authStreamController.close();
    _currentAuthUidManager.dispose();
    _authManager.dispose();
  }

  /// Initializes auth storage listening, updates auth stream on change in secure storage
  @override
  init() async {
    _authDebugger.log("Initializing auth storage");

    // Work: Populate auth stream
    await _getCurrentAuth().then((currentAuth) async {
      final AuthStatus authStatus = _decideAuthStatus(currentAuth);
      _authStreamController.add(authStatus);
    });

    // Work: Triggered when current auth ref changes.
    void onCurrentAuthChange(String? currentAuthRef) async {
      _authDebugger.log("Current auth changed in AuthStorage...");
      if (currentAuthRef == null) {
        _authStreamController.add(UnAuthenticated());
        return;
      }

      final auth = await _getCurrentAuth();

      _authStreamController.add(_decideAuthStatus(auth));
    }

    // Work: Init
    _currentAuthUidManager.init();

    // Work: Watch
    _currentAuthUidManager.watchCurrentAuthRef().listen(onCurrentAuthChange);
  }

  AuthStatus _decideAuthStatus(Auth? auth) {
    if (auth == null) {
      return UnAuthenticated();
    }
    return Authenticated(AccountModel(uniqueName: auth.uniqueName));
  }

  @override
  Future<AuthStatus> currentAuthStatus() async {
    return await _getCurrentAuth().then((currentAuth) {
      return _decideAuthStatus(currentAuth);
    });
  }

  @override
  Future<List<AccountModel>> getAccounts() async =>
      (await _authManager.readAllAuth())
          .map((auth) => AccountModel(uniqueName: auth.uniqueName))
          .toList();

  Future<Auth?> _getCurrentAuth() async {
    // First read uid of the current auth
    final uidOfCurrentAuth = await _currentAuthUidManager.read();
    if (uidOfCurrentAuth == null) {
      return null;
    }
    // Read the auth with the uid
    return await _authManager.read(uId: uidOfCurrentAuth);
  }

  /// Saves auth as current auth
  @override
  Future<AuthStatus> saveNewAuth({required AuthParams params}) async {
    // >> Save user auth
    // ** Its important to save the auth first before saving the uid as current auth ref,
    // because any change with current-auth-ref will trigger the storage listener that listens with current-auth-ref's key.
    // If the auth is saved first, then only listeners will get the saved auth instance.
    await _authManager.write(
      uId: params.accountName,
      auth: Auth(uniqueName: params.accountName, pin: params.pin),
    );
    // Save as current auth. This will trigger the storage listener and will update the authstatus (as per the current implementation.)
    await _currentAuthUidManager.saveCurrentAuthRef(params.accountName);
    return await currentAuthStatus();
  }

  /// Updates current auth
  @override
  Future<AuthStatus> changePin({required AuthParams params}) async {
    // Check if current auth exists and given current user key is same as current user key
    // saved in secure storage(source of truth)
    final currentAuth = await _getCurrentAuth();
    final uidOfCurrentAuth = await _currentAuthUidManager.read();
    if (currentAuth == null || uidOfCurrentAuth == null) {
      throw Exception("Auth does not exist!");
    }
    // convert to auth object
    final auth = Auth(uniqueName: params.accountName, pin: params.pin);
    // Save the new auth instance.
    await _authManager.write(uId: uidOfCurrentAuth, auth: auth);
    return await currentAuthStatus();
  }

  @override
  Future<AuthStatus> deleteAllAccounts() async {
    _authDebugger.log("Deleting all auth records");
    await _authManager.deleteAll();

    _authDebugger.log("Deleting current auth ref");
    await _currentAuthUidManager.deleteCurrentAuthRef();
    return await currentAuthStatus();
  }

  @override
  Stream<AuthStatus> get authStream async* {
    yield await currentAuthStatus();
    yield* _authStreamController.stream;
  }

  @override
  Future<AuthStatus> switchAccount({required String accountName}) async {
    final auth = await _authManager.read(uId: accountName);
    if (auth == null) {
      throw Exception("Auth with uid $accountName does not exist.");
    }
    await _currentAuthUidManager.saveCurrentAuthRef(accountName);
    final currentAuth = await _getCurrentAuth();
    return _decideAuthStatus(currentAuth);
  }

  @override
  Future<AuthStatus> deleteCurrentAccount() async {
    return await _getCurrentAuth().then((auth) async {
      if (auth == null) {
        return UnAuthenticated();
      }
      await _authManager.delete(uId: auth.uniqueName);
      await _currentAuthUidManager.deleteCurrentAuthRef();
      return await currentAuthStatus();
    });
  }

  @override
  Future<AccountModel?> getCurrentAccount() async {
    return await _getCurrentAuth().then(
      (auth) => auth == null ? null : AccountModel(uniqueName: auth.uniqueName),
    );
  }

  @override
  Future<bool> isAccountNameAvailable(String accountName) async {
    final authList = await _authManager.readAllAuth();
    return authList.where((auth) => auth.uniqueName == accountName).isEmpty;
  }

  @override
  Future<AuthStatus> logout() async {
    await _currentAuthUidManager.deleteCurrentAuthRef();
    return await _getCurrentAuth().then((auth) => _decideAuthStatus(auth));
  }

  @override
  Future<AuthStatus> unlockAccount({required AuthParams params}) async {
    // Get auths
    final auths = await _authManager.readAllAuth();
    // Check if auth exists
    final auth = auths.firstWhere(
      (auth) => auth.uniqueName == params.accountName && auth.pin == params.pin,
    );
    await _currentAuthUidManager.saveCurrentAuthRef(auth.uniqueName);
    return await _getCurrentAuth().then(
      (currentAuth) => _decideAuthStatus(currentAuth),
    );
  }
}
