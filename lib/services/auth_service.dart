import 'package:frontend_flutter/models/credential.dart';
import 'package:frontend_flutter/services/auth/auth_interface.dart';
import 'package:frontend_flutter/services/storage_service.dart';

class AuthService {
  final StorageService _storageService = StorageService();
  final auth = Auth();

  Future<bool> authenticate() async {
    Credential? credential = await auth.authenticate();
    await _storeTokenFromCredential(credential);
    return (credential != null);
  }

  Future<bool> isLoggedIn() async {
    var accessToken = await _getStoredToken(TokenType.accessToken);
    return accessToken != null;
  }

  Future<void> logout() async {
    String? idToken = await _getStoredToken(TokenType.idToken);
    if (idToken != null) {
      await auth.logout(idToken);
    }
    await _clearSessionInfo();
  }

  Future<String?> _getStoredToken(TokenType tokenType) async {
    return _storageService.readToken(tokenType);
  }

  Future<void> _clearSessionInfo() async {
    await _storageService.deleteAllSecureData();
  }

  Future<void> _storeTokenFromCredential(Credential? credential) async {
    if (credential == null) { return; }
    await _storageService.storeToken(TokenType.accessToken, credential.accessToken);
    await _storageService.storeToken(TokenType.refreshToken, credential.refreshToken);
    await _storageService.storeToken(TokenType.idToken, credential.idToken);
  }
}
