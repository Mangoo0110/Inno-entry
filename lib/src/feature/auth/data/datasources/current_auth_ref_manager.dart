part of 'auth_storage.dart';

/// Manages(read, write, delete) uid of current auth
class _CurrentAuthUidManager implements CurrentAuthUidManagerInterface {
  _CurrentAuthUidManager();

  final String currentAuthKey = "current_auth";
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  final StreamController<String?> _streamController =
      StreamController.broadcast();

  @override
  void init() {
    _secureStorage.registerListener(
      key: currentAuthKey,
      listener: (value) {
        _streamController.add(value);
      },
    );
  }

  /// Returns uid of current auth
  @override
  Future<String?> read() async {
    return await _secureStorage.read(key: currentAuthKey);
  }

  /// Saves uid of current auth
  @override
  Future<void> saveCurrentAuthRef(String uid) async {
    return await _secureStorage.write(key: currentAuthKey, value: uid);
  }

  /// Delete current auth uid
  @override
  Future<void> deleteCurrentAuthRef() async {
    return await _secureStorage.delete(key: currentAuthKey);
  }

  @override
  Future<void> dispose() async {
    _streamController.close();
    _secureStorage.unregisterAllListeners();
  }

  @override
  Stream<String?> watchCurrentAuthRef() => _streamController.stream;
}
