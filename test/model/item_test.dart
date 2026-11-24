import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/model/item_time_interval.dart';

/// `requiresApproval` is the one field whose *absent* value is a decision: since 2026-11-23 lending here
/// needs the owner's yes, so a payload that says nothing must not quietly opt the item out. The server's
/// own defaults say the same (ItemRequestDto / ItemModel / changelog-3.1.sql).
void main() {
  test(
      'when building an item without touching approval, then approval is required',
      () {
    expect(Item(name: 'pressure washer').requiresApproval, isTrue);
  });

  test(
      'when parsing an item without the approval field, then approval is required',
      () {
    final item = Item.fromJson({
      'uuid': 'i1',
      'name': 'pressure washer',
      'categories': ['TOOL'],
    });

    expect(item.requiresApproval, isTrue);
  });

  test(
      'when parsing an item whose owner switched approval off, then it stays off',
      () {
    final item = Item.fromJson({
      'uuid': 'i1',
      'name': 'ladder',
      'requiresApproval': false,
    });

    expect(item.requiresApproval, isFalse);
  });

  // The body below is the packaged artifact's answer, measured 2026-11-23 and recorded in
  // backend-quarkus/docs/runbook.md ("What does not work" 8). It is not a fixture invented from the DTO's
  // name, and it must not be tidied: the day numbers are java.time.DayOfWeek (1 = Monday) and the times are
  // OffsetTime text.
  test(
      'when parsing the availability the artifact sends, then the four fields survive',
      () {
    final item = Item.fromJson({
      'uuid': 'i1',
      'name': 'pressure washer',
      'availability': [
        {
          'startDayOfWeek': 1,
          'endDayOfWeek': 3,
          'startTimeAt': '09:00Z',
          'endTimeAt': '17:00Z'
        }
      ],
    });

    expect(item.availability, [
      ItemTimeInterval(
          startDayOfWeek: 1,
          endDayOfWeek: 3,
          startTimeAt: '09:00Z',
          endTimeAt: '17:00Z'),
    ]);
  });

  // Review Focus 4: a Sunday window in a +01:00 offset is what a well-meaning DateTime round trip, or a
  // 0-based day index, breaks. The interval carries text and the DayOfWeek numbering, not a Dart TimeOfDay.
  test(
      'an item written by toJson is read back by fromJson with its availability intact',
      () {
    final item = Item(name: 'ladder', availability: const [
      ItemTimeInterval(
          startDayOfWeek: 7,
          endDayOfWeek: 1,
          startTimeAt: '08:30+01:00',
          endTimeAt: '12:00+01:00'),
      ItemTimeInterval(
          startDayOfWeek: 2,
          endDayOfWeek: 4,
          startTimeAt: '09:00Z',
          endTimeAt: '17:00Z'),
    ]);

    expect(Item.fromJson(item.toJson()).availability, item.availability);
  });

  // Review Focus 1: the create path. This is the HTTP 400 — the body used to carry "availability": null, and
  // ItemRequestDto.availability is a non-null List.
  test('a new item sends an empty availability list, never null', () {
    expect(Item(name: 'drill').toJson()['availability'], isEmpty);
    expect(Item(name: 'drill').toJson().containsKey('availability'), isTrue);
  });

  // Review Focus 2: page payloads can carry no availability at all; that is "no windows", not a crash.
  test('an item response without the availability key parses to no windows',
      () {
    expect(
        Item.fromJson({'uuid': 'i1', 'name': 'drill'}).availability, isEmpty);
  });

  // Review Focus 5: the artifact answers an interval with unknown keys with HTTP 400 rather than ignoring it,
  // so an interval this client cannot name is a contract break. Dropping it would silently eat the owner's
  // lending window.
  test('an interval whose keys the DTO does not know is rejected, not ignored',
      () {
    expect(
      () => ItemTimeInterval.fromJson({'startAt': '09:00Z', 'endAt': '17:00Z'}),
      throwsA(isA<ArgumentError>()),
    );
  });

  // The cross-language pin: these four spellings live in backend-quarkus/src/main/kotlin/api/dto/ItemDto.kt:86-91
  // and in the set below, and no test on either side of the network can see the other.
  test('an interval serializes exactly the four keys the DTO declares', () {
    expect(
      const ItemTimeInterval(
              startDayOfWeek: 1,
              endDayOfWeek: 3,
              startTimeAt: '09:00Z',
              endTimeAt: '17:00Z')
          .toJson()
          .keys
          .toSet(),
      {'startDayOfWeek', 'endDayOfWeek', 'startTimeAt', 'endTimeAt'},
    );
  });
}
