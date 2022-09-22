import 'package:frontend_flutter/model/credential.dart';
import 'package:frontend_flutter/service/auth/auth_interface.dart';
import 'package:frontend_flutter/service/storage_service.dart';

import '../di/service_locator.dart';

class AuthService {
  final _storageService = getIt.get<StorageService>();
  late Auth auth;

  AuthService({Auth? auth}) {
    this.auth = auth ?? Auth();
  }

  Future<bool> authenticate() async {
    Credential? credential = await auth.authenticate();
    await _storeTokenFromCredential(credential);
    return (credential != null);
  }

  Future<String?> refresh() async {
    final refreshToken = await _getStoredToken(TokenType.refreshToken);
    if (refreshToken == null) { return null; }
    Credential? credential = await auth.refresh(refreshToken);
    await _storeTokenFromCredential(credential);
    return credential?.accessToken;
  }

  Future<bool> isLoggedIn() async {
    final accessToken = await _getStoredToken(TokenType.accessToken);
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
