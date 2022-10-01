import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/http_json_response.dart';
import 'package:frontend_flutter/service/auth_service.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:frontend_flutter/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const url = 'users/me';
  const body = '{"test": "test"}';
  const bodyObject = {'test': 'test'};

  late http.Client mockClient;
  late AuthService mockAuthService;
  late StorageService mockStorageService;
  late RequestService requestService;

  setUpAll(() async {
    getServices();
    mockClient = MockClient();
    mockAuthService = MockAuthService();
    await getIt.unregister<AuthService>();
    getIt.registerLazySingleton<AuthService>(() => mockAuthService);
    mockStorageService = MockStorageService();
    await getIt.unregister<StorageService>();
    getIt.registerLazySingleton<StorageService>(() => mockStorageService);
    requestService = RequestService(client: mockClient);
  });

  test('when calling GET request with needed auth and missing access token, then status 401 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);

    final response = await requestService.request(url);

    expect(response.status, HttpStatus.unauthorized);
    expect(response.json, null);
  });

  test('when calling GET request with not needed auth and missing access token, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);
    when(mockClient.get(Uri.parse('/$url'), headers: requestService.httpHeaders(null))).thenAnswer((_) async => http.Response(body, 200));

    final response = await requestService.request(url, needsAuth: false);

    expect(response.status, HttpStatus.ok);
    expect(response.json, {'test': 'test'});
  });

  test('when calling GET request with needed auth and existing access token, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => 'some_token');
    when(mockClient.get(Uri.parse('/$url'), headers: requestService.httpHeaders('some_token'))).thenAnswer((_) async => http.Response(body, 200));

    final response = await requestService.request(url);

    expect(response.status, HttpStatus.ok);
    expect(response.json, {'test': 'test'});
  });

  test('when calling GET request with needed auth and invalid access token and succeeding refresh, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => 'some_token');
    when(mockAuthService.refresh()).thenAnswer((_) async => 'new_token');
    when(mockClient.get(Uri.parse('/$url'), headers: requestService.httpHeaders('some_token'))).thenAnswer((_) async => http.Response(body, 401));
    when(mockClient.get(Uri.parse('/$url'), headers: requestService.httpHeaders('new_token'))).thenAnswer((_) async => http.Response(body, 200));

    HttpJsonResponse response = await requestService.request(url);

    expect(response.status, HttpStatus.ok);
    expect(response.json, {'test': 'test'});
  });

  test('when calling GET request with needed auth and missing access token and failing refresh, then status 401 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => 'some_token');
    when(mockAuthService.refresh()).thenAnswer((_) async => null);
    when(mockClient.get(Uri.parse('/$url'), headers: requestService.httpHeaders('some_token'))).thenAnswer((_) async => http.Response(body, 401));

    HttpJsonResponse response = await requestService.request(url);

    expect(response.status, HttpStatus.unauthorized);
    expect(response.json, null);
  });

  test('when calling GET request with failing request, then status 503 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => 'some_token');
    when(mockClient.get(Uri.parse('/$url'), headers: requestService.httpHeaders('some_token'))).thenThrow(Error());

    HttpJsonResponse response = await requestService.request(url);

    expect(response.status, HttpStatus.serviceUnavailable);
    expect(response.json, null);
  });

  test('when calling POST request, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);
    when(mockClient.post(Uri.parse('/$url'), body: bodyObject, headers: requestService.httpHeaders(null))).thenAnswer((_) async => http.Response(body, 200));

    final response = await requestService.request(url, method: HttpMethod.post, body: bodyObject, needsAuth: false);

    expect(response.status, HttpStatus.ok);
    expect(response.json, {'test': 'test'});
  });

  test('when calling PATCH request, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);
    when(mockClient.patch(Uri.parse('/$url'), body: bodyObject, headers: requestService.httpHeaders(null))).thenAnswer((_) async => http.Response(body, 200));

    final response = await requestService.request(url, method: HttpMethod.patch, body: bodyObject, needsAuth: false);

    expect(response.status, HttpStatus.ok);
    expect(response.json, {'test': 'test'});
  });

  test('when calling PUT request, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);
    when(mockClient.put(Uri.parse('/$url'), body: bodyObject, headers: requestService.httpHeaders(null))).thenAnswer((_) async => http.Response(body, 200));

    final response = await requestService.request(url, method: HttpMethod.put, body: bodyObject, needsAuth: false);

    expect(response.status, HttpStatus.ok);
    expect(response.json, {'test': 'test'});
  });

  test('when calling DELETE request, then status 200 is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);
    when(mockClient.delete(Uri.parse('/$url'), headers: requestService.httpHeaders(null))).thenAnswer((_) async => http.Response(body, 204));

    final response = await requestService.request(url, method: HttpMethod.delete, needsAuth: false);

    expect(response.status, HttpStatus.noContent);
    expect(response.json, {'test': 'test'});
  });
}