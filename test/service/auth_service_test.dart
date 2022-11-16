
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

  const expiredAccessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJjZklBRE5feHhDSm1Wa1d5Ti1QTlhFRXZNVVdzMnI2OEN4dG1oRUROelhVIn0.eyJleHAiOjE2NjYwMTEyMzIsImlhdCI6MTY2NjAwOTQzMiwiYXV0aF90aW1lIjoxNjY2MDA5NDMyLCJqdGkiOiIyMzYzY2U2Ni04YTUzLTQ3MWUtOWRjNS1jNmQ5ZWFlYzg0NDUiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgxODAvcmVhbG1zL3F1YXJrdXMiLCJzdWIiOiJlYjQxMjNhMy1iNzIyLTQ3OTgtOWFmNS04OTU3ZjgyMzY1N2EiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJiYWNrZW5kLXNlcnZpY2UiLCJzZXNzaW9uX3N0YXRlIjoiODAxMzlhMjMtM2JhYS00Mzk3LThlOTMtMDY3ZTE1ZTBjNzUzIiwiYWxsb3dlZC1vcmlnaW5zIjpbIioiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInVzZXIiXX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIHByb2ZpbGUiLCJzaWQiOiI4MDEzOWEyMy0zYmFhLTQzOTctOGU5My0wNjdlMTVlMGM3NTMiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsIm5hbWUiOiJhbGljZSBhbGljZSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsaWNlIiwiZ2l2ZW5fbmFtZSI6ImFsaWNlIiwiZmFtaWx5X25hbWUiOiJhbGljZSIsImVtYWlsIjoiYWxpY2VAdGVzdC50bGQifQ.eIuxeanuPTU-AZQdRXmNVq4rDMnPd8PBhUAqbOuyA29EDjwP3brhAfR9woHc4L_WllRTtyKY41HAuVFlCPiyyZ6PwYBvEHc-xwrf7nzcSEelnuvXX11GzikoVohExnEHoAp7ngiEDb9RetFRPdQ8_CTi6jjpf314q8PhmPLo4QQVHJKnkb5MM751Bqvyvs0aCxecgwNWXEbE8DDqHZkhHSdhs-5UUMaZ_mqr-OmNO42tS6qjiWpFSnIwu0JgMVA_s1WqEjF6ZDN8I5VJPVXgTF37Gs28LKa9XNLjJebJqfs8JXpJlZB8IuDKwugMI-dW2rU7xAX8W4ghVYjuyYvpLQ';
  const nonExpiredAccessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImUzZjdiODZlNTNiN2Q2ZTVhYjhjN2ViYmQ0MmUyMzEyIn0.eyJleHAiOjExNjY2MDExMjMyLCJpYXQiOjE2NjYwMDk0MzIsImF1dGhfdGltZSI6MTY2NjAwOTQzMiwianRpIjoiMjM2M2NlNjYtOGE1My00NzFlLTlkYzUtYzZkOWVhZWM4NDQ1IiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MTgwL3JlYWxtcy9xdWFya3VzIiwic3ViIjoiZWI0MTIzYTMtYjcyMi00Nzk4LTlhZjUtODk1N2Y4MjM2NTdhIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiYmFja2VuZC1zZXJ2aWNlIiwic2Vzc2lvbl9zdGF0ZSI6IjgwMTM5YTIzLTNiYWEtNDM5Ny04ZTkzLTA2N2UxNWUwYzc1MyIsImFsbG93ZWQtb3JpZ2lucyI6WyIqIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJ1c2VyIl19LCJzY29wZSI6Im9wZW5pZCBlbWFpbCBwcm9maWxlIiwic2lkIjoiODAxMzlhMjMtM2JhYS00Mzk3LThlOTMtMDY3ZTE1ZTBjNzUzIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiYWxpY2UgYWxpY2UiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhbGljZSIsImdpdmVuX25hbWUiOiJhbGljZSIsImZhbWlseV9uYW1lIjoiYWxpY2UiLCJlbWFpbCI6ImFsaWNlQHRlc3QudGxkIn0.i5T9ijokPv3hB0rbJysnvXPuzs_w77fU5jFe3uEPMQHn9OTgHDZWTw6955167XmxV0wrRgXu4V_wDfPn1Qq6Boj02cKSdb1uWfWVUnP0kNu_9Wmpe4rRmJbTZoz67YLB5MWinAaSpJiJ50Sx3bdrA5AvHtAd10lXCXIGqvIOXPtlbcjmsopT78E4NHgucf3mfbdd-eAxxF66vrPZ14e2KZFLLVeK39rRxqm4aF0ZxrWohARkKQk-hxjU1Aj7hsfgV3rpQIlW9XtDNmHjs0bUUjRPwRineBcxHNFeN504XqOT2csxNoDLD2O6dA4ROxONi-mgQwpwvFVF8x9m4sVq3-fpBJlBjkUcYnb35uRNWnELstpW0vvQFMY_LmJ6gxrY91Kda5MAR3GpE__-CV_1MJm80_h3UbkmX6WJreGVCB9J6x8slCxJ0QpWDd9L9y-FXpJgEmVOCRNko4UGBSRkokQ8OVfkAAdOtqFggJkPlYcxY-pF0YFjWk_tv17ZY7HM';
  const expiredRefreshToken = 'eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI5NmFmZDAwZS04NWNmLTRkMzUtYjE4ZS0wNjFkMzgxM2Q4YjIifQ.eyJleHAiOjE2NjYwMTEyMzIsImlhdCI6MTY2NjAwOTQzMiwianRpIjoiNTA4YTUxNzMtMjlkZC00OGIwLWFhMmQtN2I4ZjA5MzgyY2RhIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MTgwL3JlYWxtcy9xdWFya3VzIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo4MTgwL3JlYWxtcy9xdWFya3VzIiwic3ViIjoiZWI0MTIzYTMtYjcyMi00Nzk4LTlhZjUtODk1N2Y4MjM2NTdhIiwidHlwIjoiUmVmcmVzaCIsImF6cCI6ImJhY2tlbmQtc2VydmljZSIsInNlc3Npb25fc3RhdGUiOiI4MDEzOWEyMy0zYmFhLTQzOTctOGU5My0wNjdlMTVlMGM3NTMiLCJzY29wZSI6Im9wZW5pZCBlbWFpbCBwcm9maWxlIiwic2lkIjoiODAxMzlhMjMtM2JhYS00Mzk3LThlOTMtMDY3ZTE1ZTBjNzUzIn0.lCEskfqvEbcJmeA-JTRySBjIC2rEvBKL8PARicJ9S2c';
  const nonExpiredRefreshToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImY2ZDdkYWViNGFiYTdmY2ZiNDBlNGNhNTM4YTdhNWQyIn0.eyJleHAiOjExNjY2MDExMjMyLCJpYXQiOjExNjY2MDA5NDMyLCJqdGkiOiI1MDhhNTE3My0yOWRkLTQ4YjAtYWEyZC03YjhmMDkzODJjZGEiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgxODAvcmVhbG1zL3F1YXJrdXMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjgxODAvcmVhbG1zL3F1YXJrdXMiLCJzdWIiOiJlYjQxMjNhMy1iNzIyLTQ3OTgtOWFmNS04OTU3ZjgyMzY1N2EiLCJ0eXAiOiJSZWZyZXNoIiwiYXpwIjoiYmFja2VuZC1zZXJ2aWNlIiwic2Vzc2lvbl9zdGF0ZSI6IjgwMTM5YTIzLTNiYWEtNDM5Ny04ZTkzLTA2N2UxNWUwYzc1MyIsInNjb3BlIjoib3BlbmlkIGVtYWlsIHByb2ZpbGUiLCJzaWQiOiI4MDEzOWEyMy0zYmFhLTQzOTctOGU5My0wNjdlMTVlMGM3NTMifQ.gpQlpa8fpy0ynMKx3OyfnLNCjgaSxtxvI3aeGxGQ8sRXtmWErifVST8fSRf9tc9b4zySZrtqM5NqqW5Q99bou9J11A0OBD1S1reGBcrVHDhdJyfqbJu9OI_qi95_TnOakd5nslRC5Hg8SA_R4CUdamJP_IXWDtUGo-cGqYhja9jh-kRATVLxeStR9GgkPM8gMcsf2GAboFQDODqhRHz99UnJWUdU-rJP4IFc3CBpIbqq4x4rWaz5LJpHsTLXAN05Ybl4QKEU-_TSUDJaOgjQLnSd76ZRvmkmZb38F_NLeVFVy0Xfl4AJPov2f4LV5znaURYkAXLyKgTGaUbxtJJXwp06M0hSGvvc8h8IhNs3lQnjJ8DXDFzIsemR31bv7i3hQcR-vrqkdrmLCBxbfvGxXIUsKr7qI8rDRi6Frz6LsocNsuYXN7yi_MCg4xaNyJ06qGrhWlUD_5HqcLvYCGBDxqJz74vnHpYk2QglLGDP0n7mz4LVuuqS24P3vEZzlusH';

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
    when(mockAuth.authenticate()).thenAnswer((_) async => const Credential(accessToken: nonExpiredAccessToken, refreshToken: nonExpiredRefreshToken, idToken: 'id'));
    final success = await authService.authenticate();

    expect(success, true);
  });

  test('when authenticate unsuccessfully, then false is returned', () async {
    when(mockAuth.authenticate()).thenAnswer((_) async => null);
    final success = await authService.authenticate();

    expect(success, false);
  });

  test('when refresh successfully, then access token is returned', () async {
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => nonExpiredRefreshToken);
    when(mockAuth.refresh(nonExpiredRefreshToken)).thenAnswer((_) async => const Credential(accessToken: nonExpiredAccessToken, refreshToken: nonExpiredRefreshToken, idToken: 'id'));
    final token = await authService.refresh();

    expect(token, nonExpiredAccessToken);
  });

  test('when refresh unsuccessfully, then null is returned', () async {
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => nonExpiredRefreshToken);
    when(mockAuth.refresh(nonExpiredRefreshToken)).thenAnswer((_) async => null);
    final token = await authService.refresh();

    expect(token, null);
  });

  test('when refresh without refresh token, then null is returned', () async {
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => null);
    final token = await authService.refresh();

    expect(token,null);
  });

  test('when refresh with expired refresh token, then null is returned', () async {
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => expiredRefreshToken);
    final token = await authService.refresh();

    expect(token,null);
  });

  test('when calling isLoggedIn with existing non-expired access token, true is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => nonExpiredAccessToken);
    final isLoggedIn = await authService.isLoggedIn();

    expect(isLoggedIn, true);
  });

  test('when calling isLoggedIn with existing expired access token and successful refresh, true is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => expiredAccessToken);
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => nonExpiredRefreshToken);
    when(mockAuth.refresh(nonExpiredRefreshToken)).thenAnswer((_) async => const Credential(accessToken: nonExpiredAccessToken, refreshToken: nonExpiredRefreshToken, idToken: 'id'));
    final isLoggedIn = await authService.isLoggedIn();

    expect(isLoggedIn, true);
  });

  test('when calling isLoggedIn with existing expired access token and missing refresh token, false is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => expiredAccessToken);
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => null);
    final isLoggedIn = await authService.isLoggedIn();

    expect(isLoggedIn, false);
  });

  test('when calling isLoggedIn with existing expired access token and failing refresh, false is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => expiredAccessToken);
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => nonExpiredRefreshToken);
    when(mockAuth.refresh(nonExpiredRefreshToken)).thenAnswer((_) async => null);
    final isLoggedIn = await authService.isLoggedIn();

    expect(isLoggedIn, false);
  });

  test('when calling isLoggedIn without access token, then false is returned', () async {
    when(mockStorageService.readToken(TokenType.accessToken)).thenAnswer((_) async => null);
    final isLoggedIn = await authService.isLoggedIn();

    expect(isLoggedIn, false);
  });

  test('when calling logout with existing id token, then auth.logout is called', () async {
    when(mockStorageService.readToken(TokenType.idToken)).thenAnswer((_) async => 'id_token');
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => 'refresh_token');
    await authService.logout();

    verify(mockAuth.logout(idToken: 'id_token', refreshToken: 'refresh_token')).called(1);
    verify(mockStorageService.deleteAllSecureData()).called(1);
  });

  test('when calling logout with existing id token, then auth.logout is not called', () async {
    when(mockStorageService.readToken(TokenType.idToken)).thenAnswer((_) async => null);
    when(mockStorageService.readToken(TokenType.refreshToken)).thenAnswer((_) async => 'refresh_token');
    await authService.logout();

    verifyNever(mockAuth.logout(idToken: 'id_token', refreshToken: 'refresh_token')).called(0);
    verify(mockStorageService.deleteAllSecureData()).called(1);
  });
}