import 'dart:convert';
import 'dart:math';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:frontend_flutter/services/storage_service.dart';

import '../models/config.dart';

class AuthService {
  final StorageService _storageService = StorageService();
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  String? _codeVerifier;
  String? _nonce;
  String? _authorizationCode;

  Future<String?> _getStoredToken(TokenType tokenType) async {
    return _storageService.readToken(tokenType);
  }

  Future<bool> isLoggedIn() async {
    var accessToken = await _getStoredToken(TokenType.accessToken);
    return accessToken != null;
  }

  Future<void> logout() async {
    await _endSession();
    await _clearSessionInfo();
  }

  Future<void> _endSession() async {
    var idToken = await _getStoredToken(TokenType.idToken);
    if (idToken == null)  { return; }
    await _appAuth.endSession(EndSessionRequest(
        idTokenHint: idToken,
        postLogoutRedirectUrl: Config().postLogoutRedirectUrl,
        serviceConfiguration: _getAuthorizationServiceConfiguration()));
  }

  Future<void> _clearSessionInfo() async {
    _codeVerifier = null;
    _nonce = null;
    _authorizationCode = null;
    await _storageService.deleteAllSecureData();
  }

  Future<void> _refresh() async {
    var refreshToken = await _getStoredToken(TokenType.refreshToken);
    final TokenResponse? result = await _appAuth.token(TokenRequest(
        Config().clientId, Config().redirectUrl,
        refreshToken: refreshToken,
        issuer: Config().issuer,
        scopes: Config().scopes));
    _storeToken(result?.accessToken, result?.refreshToken, null);
  }

  Future<void> _exchangeCode() async {
    final TokenResponse? result = await _appAuth.token(TokenRequest(
        Config().clientId, Config().redirectUrl,
        authorizationCode: _authorizationCode,
        discoveryUrl: Config().discoveryUrl,
        codeVerifier: _codeVerifier,
        nonce: _nonce,
        scopes: Config().scopes));
    _storeToken(result?.accessToken, result?.refreshToken, null);
  }

  Future<void> signInWithNoCodeExchange() async {
    try {
      // use the discovery endpoint to find the configuration
      final AuthorizationResponse? result = await _appAuth.authorize(
        AuthorizationRequest(Config().clientId, Config().redirectUrl,
            discoveryUrl: Config().discoveryUrl,
            scopes: Config().scopes,
            loginHint: 'bob'),
      );

      // or just use the issuer
      // var result = await _appAuth.authorize(
      //   AuthorizationRequest(
      //     _clientId,
      //     _redirectUrl,
      //     issuer: _issuer,
      //     scopes: _scopes,
      //   ),
      // );
      if (result != null) {
        _processAuthResponse(result);
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<void> signInWithNoCodeExchangeAndGeneratedNonce() async {
    try {
      final Random random = Random.secure();
      final String nonce =
          base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
      // use the discovery endpoint to find the configuration
      final AuthorizationResponse? result = await _appAuth.authorize(
        AuthorizationRequest(Config().clientId, Config().redirectUrl,
            discoveryUrl: Config().discoveryUrl,
            scopes: Config().scopes,
            loginHint: 'bob',
            nonce: nonce),
      );

      if (result != null) {
        _processAuthResponse(result);
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<bool> signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}
      ) async {
    try {
      // show that we can also explicitly specify the endpoints rather than getting from the details from the discovery document
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Config().clientId,
          Config().redirectUrl,
          clientSecret: Config().clientSecret,
          serviceConfiguration: _getAuthorizationServiceConfiguration(),
          scopes: Config().scopes,
          preferEphemeralSession: preferEphemeralSession,
        ),
      );

      // this code block demonstrates passing in values for the prompt parameter. in this case it prompts the user login even if they have already signed in. the list of supported values depends on the identity provider
      // final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
      //   AuthorizationTokenRequest(_clientId, _redirectUrl,
      //       serviceConfiguration: _serviceConfiguration,
      //       scopes: _scopes,
      //       promptValues: ['login']),
      // );

      if (result != null) {
        await _storeToken(result.accessToken, result.refreshToken, result.idToken);
        return true;
      }
      return false;
    } catch (exception) {
      print(exception.toString());
      return false;
    }
  }

  void _processAuthResponse(AuthorizationResponse response) {
    // save the code verifier and nonce as it must be used when exchanging the token
    _codeVerifier = response.codeVerifier;
    _nonce = response.nonce;
    _authorizationCode = response.authorizationCode!;
  }

  Future<void> _storeToken(String? accessToken, String? refreshToken, String? idToken) async {
    if (accessToken != null) {
      await _storageService.storeToken(TokenType.accessToken, accessToken);
    }
    if (refreshToken != null) {
      await _storageService.storeToken(TokenType.refreshToken, refreshToken);
    }
    if (idToken != null) {
      await _storageService.storeToken(TokenType.idToken, idToken);
    }
  }

  AuthorizationServiceConfiguration _getAuthorizationServiceConfiguration() {
    return AuthorizationServiceConfiguration(
      authorizationEndpoint: Config().authorizationEndpoint,
      tokenEndpoint: Config().tokenEndpoint,
      endSessionEndpoint: Config().endSessionEndpoint,
    );
  }
}
