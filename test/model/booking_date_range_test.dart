import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/model/booking_date_range.dart';

/// The calendar speaks in whole days, so a booking occupies every day it touches - including the day it is
/// picked up on and the day it is brought back, whatever time of day those handovers happen at.
void main() {
  final june = BookingDateRange(
    startAt: DateTime(2026, 6, 4, 9, 0),
    endAt: DateTime(2026, 6, 6, 17, 0),
  );

  test('the day a booking starts on counts as booked even when the handover is later that day', () {
    expect(june.coversDay(DateTime(2026, 6, 4)), isTrue);
    expect(june.coversDay(DateTime(2026, 6, 4, 23, 59)), isTrue);
  });

  test('the days in between and the day it ends on count as booked', () {
    expect(june.coversDay(DateTime(2026, 6, 5)), isTrue);
    expect(june.coversDay(DateTime(2026, 6, 6, 0, 0)), isTrue);
  });

  test('the day before and the day after are free', () {
    expect(june.coversDay(DateTime(2026, 6, 3)), isFalse);
    expect(june.coversDay(DateTime(2026, 6, 7)), isFalse);
  });

  test('a single-hour booking still blocks its whole day', () {
    final sameDay = BookingDateRange(
      startAt: DateTime(2026, 6, 10, 9),
      endAt: DateTime(2026, 6, 10, 10),
    );

    expect(sameDay.coversDay(DateTime(2026, 6, 10, 23)), isTrue);
  });

  test('a range the server did not finish describing blocks nothing', () {
    expect(
        BookingDateRange(startAt: null, endAt: DateTime(2026, 6, 6))
            .coversDay(DateTime(2026, 6, 5)),
        isFalse);
    expect(
        BookingDateRange(startAt: DateTime(2026, 6, 4), endAt: null)
            .coversDay(DateTime(2026, 6, 5)),
        isFalse);
  });
}
