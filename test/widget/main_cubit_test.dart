
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/main_cubit.dart';
import 'package:frontend_flutter/service/auth_service.dart';
import 'package:frontend_flutter/widget/home/home_screen.dart';
import 'package:frontend_flutter/widget/login/login_screen.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.dart';
import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthService mockAuthService;
  late BuildContext mockBuildContext;
  late MainCubit mainCubit;

  setUpAll(() async {
    getServices();
    mockAuthService = MockAuthService();
    await getIt.unregister<AuthService>();
    getIt.registerLazySingleton<AuthService>(() => mockAuthService);
    mockBuildContext = MockBuildContext();
    mainCubit = MainCubit(null, mockBuildContext);
  });

  test('when access token exists, then state is home route', () async {
    when(mockAuthService.isLoggedIn()).thenAnswer((_) async => true);
    await mainCubit.getInitialRoute(mockBuildContext);

    expect(mainCubit.state, HomeScreen.route);
  });

  test('when no access token exists, then state is login route', () async {
    when(mockAuthService.isLoggedIn()).thenAnswer((_) async => false);
    await mainCubit.getInitialRoute(mockBuildContext);

    expect(mainCubit.state, LoginScreen.route);
  });
}