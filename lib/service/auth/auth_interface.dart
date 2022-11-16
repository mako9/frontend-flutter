// auth_interface.dart
import 'package:frontend_flutter/model/credential.dart';

import 'auth.dart'
// ignore: uri_does_not_exist
if (dart.library.io) 'package:frontend_flutter/service/auth/auth_io.dart'
// ignore: uri_does_not_exist
if (dart.library.html) 'package:frontend_flutter/service/auth/auth_web.dart';

abstract class Auth {
  factory Auth() => getAuth();

  Future<Credential?> authenticate();

  Future<Credential?> refresh(String refreshToken);

  Future<void> logout({String? idToken, String? refreshToken});
}