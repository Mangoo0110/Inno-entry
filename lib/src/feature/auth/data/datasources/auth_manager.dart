part of 'auth_storage.dart';

class _AuthManager {
  final Debugger _debugger;
  _AuthManager(this._debugger);

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  // Auths with uid as key
  //final Map<String, Auth> _auths = {};
  //Map<String, Auth> get auths => Map<String, Auth>.from(_auths);

  static get _keyPrefix => "auth_";

  /// "auth_$uid"
  static String userAuthKey({required String uid}) {
    return "$_keyPrefix$uid";
  }

  /// Saves the auth
  /// # note: If key already exists, value will be overwritten
  Future<void> write({required String uId, required Auth auth}) async {
    _debugger.log("Writing auth with uid: ${userAuthKey(uid: uId)}");
    await _secureStorage.write(
      key: userAuthKey(uid: uId),
      value: auth.encodedAuth(),
    );
    //_auths[uId] = auth;
  }

  Future<Auth?> read({required String uId}) async {
    final jsonString = await _secureStorage.read(key: userAuthKey(uid: uId));
    if (jsonString == null) {
      return null;
    }

    return Auth.decodedAuth(jsonString);
  }

  Future<List<Auth>> readAllAuth() async {
    _debugger.log("Getting auths");

    final response = await _secureStorage.readAll();
    List<Auth> auths = [];

    for (final encoded in response.entries) {
      if (!encoded.key.startsWith(_keyPrefix)) {
        continue;
      }

      try {
        final auth = Auth.decodedAuth(encoded.value);
        auths.add(auth);
      } catch (e) {
        _debugger.log("Skipping invalid auth payload for key: ${encoded.key}");
      }
    }
    return auths;
  }

  Future<void> delete({required String uId}) async {
    await _secureStorage.delete(key: userAuthKey(uid: uId));
    //_auths.remove(uId);
  }

  Future<void> deleteAll() async {
    final response = await _secureStorage.readAll();
    for (final encoded in response.entries) {
      if (encoded.key.startsWith(_keyPrefix)) {
        await _secureStorage.delete(key: encoded.key);
      }
    }
  }

  Future<void> dispose() async {
    _secureStorage.unregisterAllListeners();
  }
}
