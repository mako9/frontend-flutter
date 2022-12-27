import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/config.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/auth_service.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:frontend_flutter/service/storage_service.dart';
import 'package:frontend_flutter/util/http_helper.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const path = 'user/me';
  const json = {'test': 'test'};

  late HttpHelper mockHttpHelper;
  late AuthService mockAuthService;
  late StorageService mockStorageService;
  late RequestService requestService;
  late Uri url;

  setUpAll(() async {
    getServices();
    mockHttpHelper = MockHttpHelper();
    mockAuthService = MockAuthService();
    await getIt.unregister<AuthService>();
    getIt.registerLazySingleton<AuthService>(() => mockAuthService);
    mockStorageService = MockStorageService();
    await getIt.unregister<StorageService>();
    getIt.registerLazySingleton<StorageService>(() => mockStorageService);
    requestService = RequestService(httpHelper: mockHttpHelper);
    final config = getIt.get<Config>();
    url = Uri(scheme: config.backendScheme, host: config.backendHost, port: config.backendPort, path: '${config.backendBasePath}/$path');
  });

  test('when calling GET request with needed auth and missing access token, then status 401 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);

    final response = await requestService.request(path);

    expect(response.status, HttpStatus.unauthorized);
    expect(response.json, null);
  });

  test('when calling GET request with not needed auth and missing access token, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);
    when(mockHttpHelper.request(url)).thenAnswer((_) async => const HttpJsonResponse(status: HttpStatus.ok, json: json));

    final response = await requestService.request(path, needsAuth: false);

    expect(response.status, HttpStatus.ok);
    expect(response.json, json);
  });

  test('when calling GET request with needed auth and existing access token, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => 'some_token');
    when(mockHttpHelper.request(url, accessToken: 'some_token')).thenAnswer((_) async => const HttpJsonResponse(status: HttpStatus.ok, json: json));

    final response = await requestService.request(path);

    expect(response.status, HttpStatus.ok);
    expect(response.json, {'test': 'test'});
  });

  test('when calling GET request with needed auth and invalid access token and succeeding refresh, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => 'some_token');
    when(mockAuthService.refresh()).thenAnswer((_) async => 'new_token');
    when(mockHttpHelper.request(url, accessToken: 'some_token')).thenAnswer((_) async => const HttpJsonResponse(status: HttpStatus.unauthorized, json: null));
    when(mockHttpHelper.request(url, accessToken: 'new_token')).thenAnswer((_) async => const HttpJsonResponse(status: HttpStatus.ok, json: json));

    HttpJsonResponse response = await requestService.request(path);

    expect(response.status, HttpStatus.ok);
    expect(response.json, json);
  });

  test('when calling GET request with needed auth and missing access token and failing refresh, then status 401 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => 'some_token');
    when(mockAuthService.refresh()).thenAnswer((_) async => null);
    when(mockHttpHelper.request(url, accessToken: 'some_token')).thenAnswer((_) async => const HttpJsonResponse(status: HttpStatus.unauthorized, json: null));

    HttpJsonResponse response = await requestService.request(path);

    expect(response.status, HttpStatus.unauthorized);
    expect(response.json, null);
  });
}