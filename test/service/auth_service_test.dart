
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/credential.dart';
import 'package:frontend_flutter/service/auth/auth_interface.dart';
import 'package:frontend_flutter/service/auth_service.dart';
import 'package:frontend_flutter/service/storage_service.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService mockStorageService;
  late Auth mockAuth;
  late AuthService authService;

  setUpAll(() async {
    getServices();
    mockStorageService = MockStorageService();
    await getIt.unregister<StorageService>();
    getIt.registerLazySingleton<StorageService>(() => mockStorageService);
    mockAuth = MockAuth();
    authService = AuthService(auth: mockAuth);
  });

  test('when authenticate successfully, then true is returned', () async {
    when(mockAuth.authenticate()).thenAnswer((_) async => const Credential(accessToken: 'access', refreshToken: 'refresh', idToken: 'id'));
    final success = await authService.authenticate();

    expect(success, true);
  });

  test('when authenticate unsuccessfully, then false is returned', () async {
    when(mockAuth.authenticate()).thenAnswer((_) async => null);
    final success = await authService.authenticate();

    expect(success, false);
  });

  test('when refresh successfully, then access token is returned', () async {
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => 'refresh_token');
    when(mockAuth.refresh('refresh_token')).thenAnswer((_) async => const Credential(accessToken: 'access', refreshToken: 'refresh', idToken: 'id'));
    final token = await authService.refresh();

    expect(token, 'access');
  });

  test('when refresh unsuccessfully, then null is returned', () async {
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => 'refresh_token');
    when(mockAuth.refresh('refresh_token')).thenAnswer((_) async => null);
    final token = await authService.refresh();

    expect(token, null);
  });

  test('when refresh without refresh token, then null is returned', () async {
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => null);
    final token = await authService.refresh();

    expect(token,null);
  });

  test('when calling isLoggedIn with existing access token, true is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => 'access_token');
    final isLoggedIn = await authService.isLoggedIn();

    expect(isLoggedIn, true);
  });

  test('when authenticate unsuccessfully, then false is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);
    final isLoggedIn = await authService.isLoggedIn();

    expect(isLoggedIn, false);
  });

  test('when calling logout with existing id token, then auth.logout is called', () async {
    when(mockStorageService.readToken(TokenType.idToken)).thenAnswer((_) async => 'id_token');
    await authService.logout();

    verify(mockAuth.logout('id_token')).called(1);
    verify(mockStorageService.deleteAllSecureData()).called(1);
  });

  test('when calling logout with existing id token, then auth.logout is not called', () async {
    when(mockStorageService.readToken(TokenType.idToken)).thenAnswer((_) async => null);
    await authService.logout();

    verifyNever(mockAuth.logout('id_token')).called(0);
    verify(mockStorageService.deleteAllSecureData()).called(1);
  });
}