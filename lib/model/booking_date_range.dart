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

  factory BookingDateRange.fromJson(Map<String, dynamic> json) {
    return BookingDateRange(
      startAt: JsonUtil.parseDateString(json['startAt']),
      endAt: JsonUtil.parseDateString(json['endAt']),
    );
  }
}
