import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/booking_date_range.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/service/booking_service.dart';
import 'package:frontend_flutter/service/item_service.dart';
import 'package:frontend_flutter/widget/item/item_detail_screen.dart';
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

  late BookingService mockBookingService;
  late ItemService mockItemService;

  final item = Item(uuid: 'i1', name: 'Drill', isOwner: false);

  setUpAll(() async {
    getServices();
    mockBookingService = MockBookingService();
    mockItemService = MockItemService();
    await getIt.unregister<BookingService>();
    getIt.registerLazySingleton<BookingService>(() => mockBookingService);
    await getIt.unregister<ItemService>();
    getIt.registerLazySingleton<ItemService>(() => mockItemService);

    when(mockItemService.getItem('i1')).thenAnswer(
        (_) async => DataResponse<Item>(data: item, errorMessage: null));
    when(mockItemService.getItemImage('i1')).thenAnswer(
        (_) async => DataResponse<Uint8List?>(data: null, errorMessage: null));
  });

  testWidgets('the dates other neighbours already have are listed',
      (WidgetTester tester) async {
    when(mockBookingService.getBookingDates('i1'))
        .thenAnswer((_) async => DataResponse<List<BookingDateRange>>(data: [
              BookingDateRange(
                startAt: DateTime(2026, 6, 4),
                endAt: DateTime(2026, 6, 6),
              )
            ], errorMessage: null));

    await tester.pumpWidget(_wrap(ItemDetailScreen(item: item)));
    await tester.pumpAndSettle();

    expect(find.text('Some dates are already booked'), findsOneWidget);
    expect(find.text('04.06.2026 – 06.06.2026'), findsOneWidget);
  });

  testWidgets('an item nobody has booked says nothing about booked dates',
      (WidgetTester tester) async {
    when(mockBookingService.getBookingDates('i1')).thenAnswer((_) async =>
        DataResponse<List<BookingDateRange>>(
            data: <BookingDateRange>[], errorMessage: null));

    await tester.pumpWidget(_wrap(ItemDetailScreen(item: item)));
    await tester.pumpAndSettle();

    expect(find.text('Some dates are already booked'), findsNothing);
  });

  testWidgets('a failed booked-dates lookup leaves the booking form usable',
      (WidgetTester tester) async {
    when(mockBookingService.getBookingDates('i1')).thenAnswer((_) async =>
        DataResponse<List<BookingDateRange>>(
            data: null, errorMessage: 'error'));

    await tester.pumpWidget(_wrap(ItemDetailScreen(item: item)));
    await tester.pumpAndSettle();

    expect(find.text('Some dates are already booked'), findsNothing);
    expect(find.text('Start date:'), findsOneWidget);
  });
}
