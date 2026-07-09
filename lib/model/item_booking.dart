import 'package:frontend_flutter/util/json_util.dart';

enum BookingStatus {
  pending,
  confirmed,
  declined,
  cancelled;

  factory BookingStatus.fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'declined':
        return BookingStatus.declined;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.confirmed;
    }
  }
}

enum CancelledBy {
  owner,
  requester;

  factory CancelledBy.fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'owner':
        return CancelledBy.owner;
      case 'requester':
        return CancelledBy.requester;
      default:
        return CancelledBy.requester;
    }
  }
}

class ItemBooking {
  final String? uuid;
  final String? itemUuid;
  final String? userUuid;
  final DateTime? startAt;
  final DateTime? endAt;
  final DateTime? createdAt;
  final BookingStatus status;
  final CancelledBy? cancelledBy;
  final DateTime? cancelledAt;

  ItemBooking({
    this.uuid,
    this.itemUuid,
    this.userUuid,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.status = BookingStatus.confirmed,
    this.cancelledBy,
    this.cancelledAt,
  });

  factory ItemBooking.fromJson(Map<String, dynamic> json) {
    return ItemBooking(
      uuid: json['uuid'],
      itemUuid: json['itemUuid'],
      userUuid: json['userUuid'],
      startAt: JsonUtil.parseDateString(json['startAt']),
      endAt: JsonUtil.parseDateString(json['endAt']),
      createdAt: JsonUtil.parseDateString(json['createdAt']),
      status: BookingStatus.fromJson(json['status']),
      cancelledBy: json['cancelledBy'] != null
          ? CancelledBy.fromJson(json['cancelledBy'])
          : null,
      cancelledAt: JsonUtil.parseDateString(json['cancelledAt']),
    );
  }
}
