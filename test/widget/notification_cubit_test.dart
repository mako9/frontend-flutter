import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/service/notification_service.dart';
import 'package:frontend_flutter/widget/notification/notification_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NotificationService mockNotificationService;
  late NotificationCubit notificationCubit;

  setUpAll(() async {
    getServices();
    mockNotificationService = MockNotificationService();
    await getIt.unregister<NotificationService>();
    getIt.registerLazySingleton<NotificationService>(
        () => mockNotificationService);
    when(mockNotificationService.getUnreadCount()).thenAnswer((_) async => 3);
    notificationCubit = NotificationCubit();
  });

  test('when loading unread count with success, then state is count', () async {
    await notificationCubit.loadUnreadCount();
    expect(notificationCubit.state, 3);
  });

  test('when loading unread count returns 0, then state is 0', () async {
    when(mockNotificationService.getUnreadCount()).thenAnswer((_) async => 0);
    await notificationCubit.loadUnreadCount();
    expect(notificationCubit.state, 0);
  });
}
