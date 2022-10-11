
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/main_cubit.dart';
import 'package:frontend_flutter/service/auth_service.dart';
import 'package:frontend_flutter/widget/home/home_screen.dart';
import 'package:frontend_flutter/widget/login/login_cubit.dart';
import 'package:frontend_flutter/widget/login/login_screen.dart';
import 'package:frontend_flutter/widget/setting/logout_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.dart';
import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthService mockAuthService;
  late LoginCubit loginCubit;

  setUpAll(() async {
    getServices();
    mockAuthService = MockAuthService();
    await getIt.unregister<AuthService>();
    getIt.registerLazySingleton<AuthService>(() => mockAuthService);
    loginCubit = LoginCubit(false);
  });

  test('when login is successful, then state is true', () async {
    when(mockAuthService.authenticate()).thenAnswer((_) async => true);
    await loginCubit.login();

    expect(loginCubit.state, true);
  });

  test('when login is unsuccessful, then state is true', () async {
    when(mockAuthService.authenticate()).thenAnswer((_) async => false);
    await loginCubit.login();

    expect(loginCubit.state, false);
  });
}