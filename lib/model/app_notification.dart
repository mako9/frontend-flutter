class AppNotification {
  final String? uuid;
  final String? type;
  final String? bookingUuid;
  final bool read;
  final DateTime? createdAt;

  AppNotification({
    this.uuid,
    this.type,
    this.bookingUuid,
    this.read = false,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      uuid: json['uuid'],
      type: json['type'],
      bookingUuid: json['bookingUuid'],
      read: json['read'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
