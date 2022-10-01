
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/main_cubit.dart';
import 'package:frontend_flutter/service/auth_service.dart';
import 'package:frontend_flutter/widget/home/home_screen.dart';
import 'package:frontend_flutter/widget/login/login_screen.dart';
import 'package:frontend_flutter/widget/profile/logout_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.dart';
import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthService mockAuthService;
  late LogoutCubit logoutCubit;

  setUpAll(() async {
    getServices();
    mockAuthService = MockAuthService();
    await getIt.unregister<AuthService>();
    getIt.registerLazySingleton<AuthService>(() => mockAuthService);
    logoutCubit = LogoutCubit(false);
  });

  test('when calling logout, then state is true', () async {
    when(mockAuthService.logout()).thenAnswer((_) async => true);
    await logoutCubit.logout();

    expect(logoutCubit.state, true);
  });
}