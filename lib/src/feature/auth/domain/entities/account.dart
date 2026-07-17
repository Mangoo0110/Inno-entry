abstract class Account {
  String get uniqueName;

  /// [optional]
  /// If data layer decides to cross-check authenticity of the account information send by the UI layer,
  /// this field can be used.
  String? get token;
}
