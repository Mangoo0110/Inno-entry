import 'dart:convert';

class AuthDecodeException implements Exception {
  final String message;
  AuthDecodeException({required this.message});
}

class Auth {
  final String uniqueName;
  final String pin;

  Auth({required this.uniqueName, required this.pin}) {
    assert(uniqueName.isNotEmpty);
    assert(pin.isNotEmpty);
  }

  String encodedAuth() {
    return jsonEncode({"uniqueName": uniqueName, "pin": pin});
  }

  factory Auth.decodedAuth(String encodedAuth) {
    try {
      final decoded = jsonDecode(encodedAuth);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException("Auth payload is not a JSON object.");
      }

      final uniqueName = decoded["uniqueName"];
      final pin = decoded["pin"];
      if (uniqueName is! String || pin is! String) {
        throw const FormatException("Auth payload has invalid fields.");
      }

      return Auth(uniqueName: uniqueName, pin: pin);
    } catch (error) {
      throw AuthDecodeException(message: "Invalid auth: $error");
    }
  }
}
