import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum TokenType {
  accessToken,
  refreshToken,
  idToken
}

class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> storeToken(TokenType tokenType, String value) async {
    debugPrint("Writing new ${tokenType.name}: $value");
    await _secureStorage.write(
        key: tokenType.name, value: value, aOptions: _getAndroidOptions());
  }

  Future<String?> readToken(TokenType tokenType) async {
    debugPrint("Reading token of type:  ${tokenType.name}");
    var readData =
        await _secureStorage.read(key: tokenType.name, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<void> deleteToken(TokenType tokenType) async {
    debugPrint("Deleting token of type: ${tokenType.name}");
    await _secureStorage.delete(key: tokenType.name, aOptions: _getAndroidOptions());
  }

  Future<void> deleteAllSecureData() async {
    debugPrint("Deleting all secured data");
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  Future<bool> tokenExists(TokenType tokenType) async {
    debugPrint("Checking existence of token: ${tokenType.name}");
    var containsKey = await _secureStorage.containsKey(
        key: tokenType.name, aOptions: _getAndroidOptions());
    return containsKey;
  }
}
