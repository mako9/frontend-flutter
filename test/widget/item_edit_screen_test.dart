import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/model/item_time_interval.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/service/item_service.dart';
import 'package:frontend_flutter/widget/item/item_edit_screen.dart';
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

/// The switch sitting in the same row as `label`: the form has one switch per setting, and which is
/// which only follows from the text next to it.
bool _switchValue(WidgetTester tester, String label) {
  final row = find.ancestor(
      of: find.text(label),
      matching:
          find.ancestor(of: find.byType(Switch), matching: find.byType(Row)));
  final switches = find.descendant(of: row, matching: find.byType(Switch));
  expect(switches, findsOneWidget, reason: 'no switch next to "$label"');
  return tester.widget<Switch>(switches).value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockItemService mockItemService;
  late CommunityService mockCommunityService;

  final communityPage = DataPage<Community>(
    content: [Community(uuid: 'c1', name: 'Test Community')],
    isFirstPage: true,
    isLastPage: true,
    pageNumber: 0,
    pageSize: 20,
    totalElements: 1,
    totalPages: 1,
  );

  setUpAll(() async {
    getServices();
    mockItemService = MockItemService();
    mockCommunityService = MockCommunityService();
    await getIt.unregister<ItemService>();
    getIt.registerLazySingleton<ItemService>(() => mockItemService);
    await getIt.unregister<CommunityService>();
    getIt.registerLazySingleton<CommunityService>(() => mockCommunityService);

    when(mockCommunityService.getMyCommunities()).thenAnswer((_) async =>
        DataResponse<DataPage<Community>>(
            data: communityPage, errorMessage: null));
    // the cubit loads the picture unasked in edit mode; without a stub mockito hands back a Fake
    when(mockItemService.getItemImage('i2')).thenAnswer(
        (_) async => DataResponse<Uint8List?>(data: null, errorMessage: null));
  });

  // the switch is easy to leave alone, so what an untouched form shows is the real default
  testWidgets('a new item asks for approval and is listed as active',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(ItemEditScreen()));
    await tester.pumpAndSettle();

    expect(_switchValue(tester, 'Requires approval'), isTrue);
    expect(_switchValue(tester, 'Is item active'), isTrue);
  });

  // an item whose owner already switched approval off must not be shown with it back on
  testWidgets('editing an item shows the approval the item actually has',
      (WidgetTester tester) async {
    final saved = Item(
      uuid: 'i2',
      name: 'Ladder',
      requiresApproval: false,
    );
    when(mockItemService.getItem('i2')).thenAnswer(
        (_) async => DataResponse<Item>(data: saved, errorMessage: null));

    await tester.pumpWidget(_wrap(ItemEditScreen(item: saved)));
    await tester.pumpAndSettle();

    expect(_switchValue(tester, 'Requires approval'), isFalse);
  });

  // The save builds its request from the form's own fields, and PATCH replaces the lending window from that
  // body (ItemController.kt:138, ItemRequestDto.availability defaults to emptyList()). So a field the form
  // does not show is a field it erases unless it is carried across - here, the weekly window an owner set on
  // the web.
  //
  // The item the screen is OPENED with is deliberately not the one getItem hands back. In production the
  // opening payload is a page entry, and the page DTO (ItemDto) carries no availability at all, so its windows
  // are always empty: the carry-across works only because getItem has replaced the screen's item by the time
  // Save is possible. Handing both the same object would keep this green after a cleanup like
  // `_item = widget.item`, which in production would wipe every owner's window on the first mobile save.
  testWidgets('saving an edited item keeps the lending windows the server sent',
      (WidgetTester tester) async {
    const windows = [
      ItemTimeInterval(
          startDayOfWeek: 1,
          endDayOfWeek: 3,
          startTimeAt: '09:00Z',
          endTimeAt: '17:00Z')
    ];
    final pageItem = Item(uuid: 'i3', name: 'Ladder');
    final detailItem = Item(uuid: 'i3', name: 'Ladder', availability: windows);
    expect(pageItem.availability, isEmpty,
        reason: 'the page payload must not be what carries the windows');
    when(mockItemService.getItem('i3')).thenAnswer(
        (_) async => DataResponse<Item>(data: detailItem, errorMessage: null));
    when(mockItemService.getItemImage('i3')).thenAnswer(
        (_) async => DataResponse<Uint8List?>(data: null, errorMessage: null));
    when(mockItemService.updateItem(any)).thenAnswer(
        (_) async => DataResponse<Item>(data: detailItem, errorMessage: null));

    await tester.pumpWidget(_wrap(ItemEditScreen(item: pageItem)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final sent =
        verify(mockItemService.updateItem(captureAny)).captured.single as Item;
    expect(sent.availability, windows);
  });
}
