abstract interface class CurrentAuthUidManagerInterface {
  void init();
  Future<void> dispose();

  /// watch current auth ref; returns current auth ref(string or null)
  Stream<String?> watchCurrentAuthRef();

  Future<String?> read();
  Future<void> saveCurrentAuthRef(String uniqueRef);
  Future<void> deleteCurrentAuthRef();
}
