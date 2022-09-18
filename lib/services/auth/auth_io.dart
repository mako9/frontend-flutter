import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import '../../models/config.dart';
import 'package:frontend_flutter/services/auth/auth_interface.dart';

import '../../models/credential.dart';

class AuthIo implements Auth {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  late final AuthorizationResponse authorizationResponse;

  @override
  Future<Credential?> authenticate() async {
    try {
      // show that we can also explicitly specify the endpoints rather than getting from the details from the discovery document
      AuthorizationTokenResponse? response = await _appAuth
          .authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Config().clientId,
          Config().redirectUrl,
          clientSecret: Config().clientSecret,
          serviceConfiguration: _getAuthorizationServiceConfiguration(),
          scopes: Config().scopes,
          preferEphemeralSession: false,
        ),
      );

      // this code block demonstrates passing in values for the prompt parameter. in this case it prompts the user login even if they have already signed in. the list of supported values depends on the identity provider
      // final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
      //   AuthorizationTokenRequest(_clientId, _redirectUrl,
      //       serviceConfiguration: _serviceConfiguration,
      //       scopes: _scopes,
      //       promptValues: ['login']),
      // );

      return _getCredentialFromResponse(response);
    } catch (exception) {
      if (kDebugMode) {
        print(exception.toString());
      }
      return null;
    }
  }

  @override
  Future<Credential?> refresh(String refreshToken) async {
    final TokenResponse? response = await _appAuth.token(TokenRequest(
        Config().clientId, Config().redirectUrl,
        refreshToken: refreshToken,
        issuer: Config().issuer,
        scopes: Config().scopes));
    return _getCredentialFromResponse(response);
  }

  AuthorizationServiceConfiguration _getAuthorizationServiceConfiguration() {
    return AuthorizationServiceConfiguration(
      authorizationEndpoint: Config().authorizationEndpoint,
      tokenEndpoint: Config().tokenEndpoint,
      endSessionEndpoint: Config().endSessionEndpoint,
    );
  }

  Credential? _getCredentialFromResponse(TokenResponse? response) {
    String? accessToken = response?.accessToken;
    String? refreshToken = response?.refreshToken;
    String? idToken = response?.idToken;
    if (accessToken != null && refreshToken != null && idToken != null) {
      return Credential(accessToken: accessToken,
          refreshToken: refreshToken,
          idToken: idToken);
    }
    return null;
  }

  @override
  Future<void> logout(String idToken) async {
    await _appAuth.endSession(EndSessionRequest(
        idTokenHint: idToken,
        postLogoutRedirectUrl: Config().postLogoutRedirectUrl,
        serviceConfiguration: _getAuthorizationServiceConfiguration()));
  }
}

Auth getAuth() => AuthIo();