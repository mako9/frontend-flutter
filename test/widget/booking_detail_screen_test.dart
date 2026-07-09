import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/item_booking.dart';
import 'package:frontend_flutter/service/booking_service.dart';
import 'package:frontend_flutter/widget/booking/booking_detail_screen.dart';

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

  late BookingService mockBookingService;

  final confirmedBooking = ItemBooking(
    uuid: 'b1',
    status: BookingStatus.confirmed,
    startAt: DateTime.now().add(const Duration(days: 10)),
    endAt: DateTime.now().add(const Duration(days: 15)),
  );

  final pendingBooking = ItemBooking(
    uuid: 'b2',
    status: BookingStatus.pending,
    startAt: DateTime.now().add(const Duration(days: 5)),
    endAt: DateTime.now().add(const Duration(days: 8)),
  );

  setUpAll(() async {
    getServices();
    mockBookingService = MockBookingService();
    await getIt.unregister<BookingService>();
    getIt.registerLazySingleton<BookingService>(() => mockBookingService);
  });

  testWidgets('booking detail screen renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      BookingDetailScreen(booking: confirmedBooking),
    ));
    await tester.pump();

    expect(find.byType(BookingDetailScreen), findsOneWidget);
  });

  testWidgets('booking detail screen shows confirmed status chip', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      BookingDetailScreen(booking: confirmedBooking),
    ));
    await tester.pump();

    expect(find.byType(Chip), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
  });

  testWidgets('booking detail screen shows pending status chip', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      BookingDetailScreen(booking: pendingBooking),
    ));
    await tester.pump();

    expect(find.byType(Chip), findsOneWidget);
    expect(find.text('Awaiting approval'), findsOneWidget);
  });

  testWidgets('booking detail screen shows approve and decline buttons for owner on pending booking',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      BookingDetailScreen(booking: pendingBooking, isOwner: true),
    ));
    await tester.pump();

    expect(find.text('Approve'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
  });

  testWidgets('booking detail screen does not show approve/decline buttons for non-owner',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      BookingDetailScreen(booking: pendingBooking),
    ));
    await tester.pump();

    expect(find.text('Approve'), findsNothing);
    expect(find.text('Decline'), findsNothing);
  });

  testWidgets('booking detail screen shows cancel button for future confirmed booking',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      BookingDetailScreen(booking: confirmedBooking),
    ));
    await tester.pump();

    expect(find.text('Cancel booking'), findsOneWidget);
  });
}
