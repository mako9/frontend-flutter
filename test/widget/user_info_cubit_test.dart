
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/user.dart';
import 'package:frontend_flutter/service/user_service.dart';
import 'package:frontend_flutter/widget/profile/user_info_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late UserService mockUserService;
  late UserInfoCubit userInfoCubit;
  User user = const User(
    firstName: 'Test',
    lastName: 'Test'
  );

  setUpAll(() async {
    getServices();
    mockUserService = MockUserService();
    await getIt.unregister<UserService>();
    getIt.registerLazySingleton<UserService>(() => mockUserService);
    userInfoCubit = UserInfoCubit(null);
  });

  test('when loading user without success, then state is null', () async {
    when(mockUserService.getUser()).thenAnswer((_) async => null);
    await userInfoCubit.loadUser();

    expect(userInfoCubit.state, null);
  });

  test('when loading user with success, then state contains user', () async {
    when(mockUserService.getUser()).thenAnswer((_) async => user);
    await userInfoCubit.loadUser();

    expect(userInfoCubit.state, user);
  });

  test('when updating user without success, then state is null', () async {
    when(mockUserService.updateUser(user)).thenAnswer((_) async => null);
    await userInfoCubit.updateUser(user);

    expect(userInfoCubit.state, null);
  });

  test('when updating user with success, then state contains user', () async {
    when(mockUserService.updateUser(user)).thenAnswer((_) async => user);
    await userInfoCubit.updateUser(user);

    expect(userInfoCubit.state, user);
  });
}