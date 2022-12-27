import 'dart:async';
import 'dart:html' as html;

import 'package:frontend_flutter/model/config.dart';
import 'package:frontend_flutter/service/auth/auth_interface.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import '../../di/service_locator.dart';
import '../../model/credential.dart';
import '../../util/http_helper.dart';

class AuthWeb implements Auth {
  final _config = getIt.get<Config>();
  final _httpHelper = HttpHelper();
  _WebAuthenticationSession? _authenticationSession;

  Uri get redirectUrl => Uri.parse('${_config.baseUrl}/callback.html');

  AuthWeb() {
    html.window.addEventListener('message', _eventListener);
  }

  void _eventListener(html.Event event) {
    _authenticationSession?.completeWithCode((event as html.MessageEvent).data);
  }

  @override
  Future<Credential?> authenticate() async {
    if (_authenticationSession != null) {
      return null;
    }

    Uri authorizationEndpoint =  Uri.parse(_config.authorizationEndpoint);
    Uri tokenEndpoint = Uri.parse(_config.tokenEndpoint);
    final grant = oauth2.AuthorizationCodeGrant(
      _config.clientId,
      authorizationEndpoint,
      tokenEndpoint,
      secret: _config.clientSecret,
    );

    var authorizationUrl = grant.getAuthorizationUrl(
      redirectUrl,
      scopes: _config.scopes,
    );

    final url =
        '${authorizationUrl.toString()}&access_type=offline&prompt=select_account+consent';
    _authenticationSession = _WebAuthenticationSession(url);
    final code = await _authenticationSession!.codeCompleter.future;

    if (code != null) {
      final client = await grant.handleAuthorizationResponse({'code': code});
      return Credential(
        accessToken: client.credentials.accessToken,
        refreshToken: client.credentials.refreshToken!,
        idToken: client.credentials.idToken!,
      );
    } else {
      return null;
    }
  }

  @override
  Future<void> logout({String? idToken, String? refreshToken}) async {
    final body = {
      'client_id': _config.clientId,
      'client_secret': _config.clientSecret,
      'refresh_token': refreshToken ?? '',
    };
    await _httpHelper.urlEncodedPostRequest(_config.endSessionEndpoint, body: body);
  }

  @override
  Future<Credential?> refresh(String refreshToken) async {
    final body = {
      'client_id': _config.clientId,
      'client_secret': _config.clientSecret,
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    };
    final response = await _httpHelper.urlEncodedPostRequest(_config.tokenEndpoint, body: body);
    final json = response.json;
    if (json != null) return Credential.fromJson(json);
    return null;
  }
}

class _WebAuthenticationSession {
  final codeCompleter = Completer<String?>();
  late final html.WindowBase _window;
  late final Timer _timer;

  bool get isClosed => codeCompleter.isCompleted;

  _WebAuthenticationSession(String url) {
    _window =
        html.window.open(url, '_blank', 'location=yes,width=550,height=600');
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_window.closed == true) {
        if (!isClosed) {
          codeCompleter.complete(null);
        }
        _timer.cancel();
      }
    });
  }

  void completeWithCode(String code) {
    if (!isClosed) {
      codeCompleter.complete(code);
    }
  }
}

Auth getAuth() => AuthWeb();