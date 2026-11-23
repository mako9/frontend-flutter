import 'package:frontend_flutter/util/json_util.dart';

/// One slot somebody already has: what `GET /user/item/{uuid}/booking/dates` returns, used to grey out
/// days in the date picker so a neighbour does not ask for an item on a day it is already spoken for.
class BookingDateRange {
  final DateTime? startAt;
  final DateTime? endAt;

  BookingDateRange({
    this.startAt,
    this.endAt,
  });

  /// Whether [day] is one of the days this booking occupies. Compared whole-day on purpose: a booking
  /// picked up at nine in the morning still means the item is not available that day, and that is the only
  /// question a calendar asks.
  bool coversDay(DateTime day) {
    if (startAt == null || endAt == null) return false;
    final from = DateTime(startAt!.year, startAt!.month, startAt!.day);
    final to = DateTime(endAt!.year, endAt!.month, endAt!.day);
    // the day asked about is floored too, or an evening would fall outside a booking that started that
    // very morning
    final at = DateTime(day.year, day.month, day.day);
    return !at.isBefore(from) && !at.isAfter(to);
  }

  factory BookingDateRange.fromJson(Map<String, dynamic> json) {
    return BookingDateRange(
      startAt: JsonUtil.parseDateString(json['startAt']),
      endAt: JsonUtil.parseDateString(json['endAt']),
    );
  }
}
