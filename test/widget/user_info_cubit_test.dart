
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_response.dart';
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
    userInfoCubit = UserInfoCubit.ofInitialState();
  });

  test('when loading user without success, then data response has errorMessage', () async {
    when(mockUserService.getUser()).thenAnswer((_) async => const DataResponse(data: null, errorMessage: 'some error'));
    await userInfoCubit.loadUser();

    expect(userInfoCubit.state.data, null);
    expect(userInfoCubit.state.errorMessage, 'some error');
  });

  test('when loading user with success, then state contains user', () async {
    when(mockUserService.getUser()).thenAnswer((_) async => DataResponse(data: user, errorMessage: null));
    await userInfoCubit.loadUser();

    expect(userInfoCubit.state.data, user);
    expect(userInfoCubit.state.errorMessage, null);
  });

  test('when updating user without success, then state is null', () async {
    when(mockUserService.updateUser(user)).thenAnswer((_) async => const DataResponse(data: null, errorMessage: 'some error'));
    await userInfoCubit.updateUser(user);

    expect(userInfoCubit.state.data, null);
    expect(userInfoCubit.state.errorMessage, 'some error');
  });

  test('when updating user with success, then state contains user', () async {
    when(mockUserService.updateUser(user)).thenAnswer((_) async => DataResponse(data: user, errorMessage: null));
    await userInfoCubit.updateUser(user);

    expect(userInfoCubit.state.data, user);
    expect(userInfoCubit.state.errorMessage, null);
  });
}