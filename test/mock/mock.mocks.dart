// Mocks generated by Mockito 5.3.1 from annotations
// in frontend_flutter/test/mock/mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:convert' as _i7;
import 'dart:typed_data' as _i8;

import 'package:frontend_flutter/model/credential.dart' as _i11;
import 'package:frontend_flutter/model/http_json_response.dart' as _i4;
import 'package:frontend_flutter/service/auth/auth_interface.dart' as _i3;
import 'package:frontend_flutter/service/auth_service.dart' as _i9;
import 'package:frontend_flutter/service/request_service.dart' as _i10;
import 'package:frontend_flutter/service/storage_service.dart' as _i5;
import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeResponse_0 extends _i1.SmartFake implements _i2.Response {
  _FakeResponse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamedResponse_1 extends _i1.SmartFake
    implements _i2.StreamedResponse {
  _FakeStreamedResponse_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAuth_2 extends _i1.SmartFake implements _i3.Auth {
  _FakeAuth_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClient_3 extends _i1.SmartFake implements _i2.Client {
  _FakeClient_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeHttpJsonResponse_4 extends _i1.SmartFake
    implements _i4.HttpJsonResponse {
  _FakeHttpJsonResponse_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [StorageService].
///
/// See the documentation for Mockito's code generation for more information.
class MockStorageService extends _i1.Mock implements _i5.StorageService {
  @override
  _i6.Future<void> storeToken(
    _i5.TokenType? tokenType,
    String? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #storeToken,
          [
            tokenType,
            value,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<String?> readToken(_i5.TokenType? tokenType) =>
      (super.noSuchMethod(
        Invocation.method(
          #readToken,
          [tokenType],
        ),
        returnValue: _i6.Future<String?>.value(),
        returnValueForMissingStub: _i6.Future<String?>.value(),
      ) as _i6.Future<String?>);
  @override
  _i6.Future<void> deleteToken(_i5.TokenType? tokenType) => (super.noSuchMethod(
        Invocation.method(
          #deleteToken,
          [tokenType],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteAllSecureData() => (super.noSuchMethod(
        Invocation.method(
          #deleteAllSecureData,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<bool> tokenExists(_i5.TokenType? tokenType) => (super.noSuchMethod(
        Invocation.method(
          #tokenExists,
          [tokenType],
        ),
        returnValue: _i6.Future<bool>.value(false),
        returnValueForMissingStub: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockClient extends _i1.Mock implements _i2.Client {
  @override
  _i6.Future<_i2.Response> head(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #head,
          [url],
          {#headers: headers},
        ),
        returnValue: _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #head,
            [url],
            {#headers: headers},
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #head,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i6.Future<_i2.Response>);
  @override
  _i6.Future<_i2.Response> get(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [url],
          {#headers: headers},
        ),
        returnValue: _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #get,
            [url],
            {#headers: headers},
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #get,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i6.Future<_i2.Response>);
  @override
  _i6.Future<_i2.Response> post(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i7.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #post,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #post,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i6.Future<_i2.Response>);
  @override
  _i6.Future<_i2.Response> put(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i7.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #put,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #put,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i6.Future<_i2.Response>);
  @override
  _i6.Future<_i2.Response> patch(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i7.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #patch,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #patch,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #patch,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i6.Future<_i2.Response>);
  @override
  _i6.Future<_i2.Response> delete(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i7.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #delete,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #delete,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i6.Future<_i2.Response>);
  @override
  _i6.Future<String> read(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #read,
          [url],
          {#headers: headers},
        ),
        returnValue: _i6.Future<String>.value(''),
        returnValueForMissingStub: _i6.Future<String>.value(''),
      ) as _i6.Future<String>);
  @override
  _i6.Future<_i8.Uint8List> readBytes(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #readBytes,
          [url],
          {#headers: headers},
        ),
        returnValue: _i6.Future<_i8.Uint8List>.value(_i8.Uint8List(0)),
        returnValueForMissingStub:
            _i6.Future<_i8.Uint8List>.value(_i8.Uint8List(0)),
      ) as _i6.Future<_i8.Uint8List>);
  @override
  _i6.Future<_i2.StreamedResponse> send(_i2.BaseRequest? request) =>
      (super.noSuchMethod(
        Invocation.method(
          #send,
          [request],
        ),
        returnValue:
            _i6.Future<_i2.StreamedResponse>.value(_FakeStreamedResponse_1(
          this,
          Invocation.method(
            #send,
            [request],
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i2.StreamedResponse>.value(_FakeStreamedResponse_1(
          this,
          Invocation.method(
            #send,
            [request],
          ),
        )),
      ) as _i6.Future<_i2.StreamedResponse>);
  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i9.AuthService {
  @override
  _i3.Auth get auth => (super.noSuchMethod(
        Invocation.getter(#auth),
        returnValue: _FakeAuth_2(
          this,
          Invocation.getter(#auth),
        ),
        returnValueForMissingStub: _FakeAuth_2(
          this,
          Invocation.getter(#auth),
        ),
      ) as _i3.Auth);
  @override
  set auth(_i3.Auth? _auth) => super.noSuchMethod(
        Invocation.setter(
          #auth,
          _auth,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<bool> authenticate() => (super.noSuchMethod(
        Invocation.method(
          #authenticate,
          [],
        ),
        returnValue: _i6.Future<bool>.value(false),
        returnValueForMissingStub: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<String?> refresh() => (super.noSuchMethod(
        Invocation.method(
          #refresh,
          [],
        ),
        returnValue: _i6.Future<String?>.value(),
        returnValueForMissingStub: _i6.Future<String?>.value(),
      ) as _i6.Future<String?>);
  @override
  _i6.Future<bool> isLoggedIn() => (super.noSuchMethod(
        Invocation.method(
          #isLoggedIn,
          [],
        ),
        returnValue: _i6.Future<bool>.value(false),
        returnValueForMissingStub: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<void> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [RequestService].
///
/// See the documentation for Mockito's code generation for more information.
class MockRequestService extends _i1.Mock implements _i10.RequestService {
  @override
  _i2.Client get client => (super.noSuchMethod(
        Invocation.getter(#client),
        returnValue: _FakeClient_3(
          this,
          Invocation.getter(#client),
        ),
        returnValueForMissingStub: _FakeClient_3(
          this,
          Invocation.getter(#client),
        ),
      ) as _i2.Client);
  @override
  set client(_i2.Client? _client) => super.noSuchMethod(
        Invocation.setter(
          #client,
          _client,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<_i4.HttpJsonResponse> request(
    String? path, {
    _i10.HttpMethod? method = _i10.HttpMethod.get,
    Object? body,
    bool? needsAuth = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #request,
          [path],
          {
            #method: method,
            #body: body,
            #needsAuth: needsAuth,
          },
        ),
        returnValue:
            _i6.Future<_i4.HttpJsonResponse>.value(_FakeHttpJsonResponse_4(
          this,
          Invocation.method(
            #request,
            [path],
            {
              #method: method,
              #body: body,
              #needsAuth: needsAuth,
            },
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i4.HttpJsonResponse>.value(_FakeHttpJsonResponse_4(
          this,
          Invocation.method(
            #request,
            [path],
            {
              #method: method,
              #body: body,
              #needsAuth: needsAuth,
            },
          ),
        )),
      ) as _i6.Future<_i4.HttpJsonResponse>);
  @override
  Map<String, String> httpHeaders(String? accessToken) => (super.noSuchMethod(
        Invocation.method(
          #httpHeaders,
          [accessToken],
        ),
        returnValue: <String, String>{},
        returnValueForMissingStub: <String, String>{},
      ) as Map<String, String>);
}

/// A class which mocks [Auth].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuth extends _i1.Mock implements _i3.Auth {
  @override
  _i6.Future<_i11.Credential?> authenticate() => (super.noSuchMethod(
        Invocation.method(
          #authenticate,
          [],
        ),
        returnValue: _i6.Future<_i11.Credential?>.value(),
        returnValueForMissingStub: _i6.Future<_i11.Credential?>.value(),
      ) as _i6.Future<_i11.Credential?>);
  @override
  _i6.Future<_i11.Credential?> refresh(String? refreshToken) =>
      (super.noSuchMethod(
        Invocation.method(
          #refresh,
          [refreshToken],
        ),
        returnValue: _i6.Future<_i11.Credential?>.value(),
        returnValueForMissingStub: _i6.Future<_i11.Credential?>.value(),
      ) as _i6.Future<_i11.Credential?>);
  @override
  _i6.Future<void> logout(String? idToken) => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [idToken],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}
