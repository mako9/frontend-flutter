import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/app_notification.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/service/notification_service.dart';
import 'package:frontend_flutter/widget/notification/notification_screen.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en', '')],
    home: child,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NotificationService mockNotificationService;

  setUpAll(() async {
    getServices();
    mockNotificationService = MockNotificationService();
    await getIt.unregister<NotificationService>();
    getIt.registerLazySingleton<NotificationService>(
        () => mockNotificationService);
  });

  testWidgets('notification screen renders without crashing', (WidgetTester tester) async {
    when(mockNotificationService.markAllRead())
        .thenAnswer((_) async {});
    when(mockNotificationService.getNotifications())
        .thenAnswer((_) async => DataResponse<DataPage<AppNotification>>(
              data: DataPage<AppNotification>.emptyPage(),
              errorMessage: null,
            ));

    await tester.pumpWidget(_wrap(const NotificationScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationScreen), findsOneWidget);
  });

  testWidgets('notification screen shows empty state when no notifications',
      (WidgetTester tester) async {
    when(mockNotificationService.markAllRead())
        .thenAnswer((_) async {});
    when(mockNotificationService.getNotifications())
        .thenAnswer((_) async => DataResponse<DataPage<AppNotification>>(
              data: DataPage<AppNotification>.emptyPage(),
              errorMessage: null,
            ));

    await tester.pumpWidget(_wrap(const NotificationScreen()));
    await tester.pumpAndSettle();

    expect(find.text('No entries found.'), findsOneWidget);
  });

  testWidgets('notification screen shows notification items when data is present',
      (WidgetTester tester) async {
    final notification = AppNotification(
      uuid: 'n1',
      type: 'BOOKING_CONFIRMED',
      bookingUuid: 'b1',
      read: false,
    );
    final page = DataPage<AppNotification>(
      content: [notification],
      isFirstPage: true,
      isLastPage: true,
      pageNumber: 0,
      pageSize: 1,
      totalElements: 1,
      totalPages: 1,
    );

    when(mockNotificationService.markAllRead())
        .thenAnswer((_) async {});
    when(mockNotificationService.getNotifications())
        .thenAnswer((_) async => DataResponse(data: page, errorMessage: null));

    await tester.pumpWidget(_wrap(const NotificationScreen()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.notifications), findsOneWidget);
    expect(find.text('Booking confirmed'), findsOneWidget);
  });
}
