/// One weekly lending window, carried exactly as the backend serializes it.
///
/// The four fields are the wire contract of `ItemTimeIntervalDto`
/// (`backend-quarkus/src/main/kotlin/api/dto/ItemDto.kt:86-91`): the packaged artifact answers
/// `{"startDayOfWeek":1,"endDayOfWeek":3,"startTimeAt":"09:00Z","endTimeAt":"17:00Z"}` and answers an interval
/// carrying other keys with HTTP 400, so the spelling here is load-bearing rather than stylistic.
/// `startDayOfWeek` and `endDayOfWeek` are `java.time.DayOfWeek` values — **1 = Monday … 7 = Sunday** — and the
/// two times are `OffsetTime` text, which is why they are strings and not [DateTime].
///
/// Nothing in this class parses, reformats or normalises anything, deliberately. The app has no availability
/// editor (that is plan 2d), so its whole job is to carry the owner's windows through a read and hand the
/// identical ones back on save: `PATCH /api/user/item/{uuid}` replaces the column from the request body, so a
/// window that comes back changed, or not at all, is a window erased.
class ItemTimeInterval {
  final int startDayOfWeek;
  final int endDayOfWeek;
  final String startTimeAt;
  final String endTimeAt;

  const ItemTimeInterval({
    required this.startDayOfWeek,
    required this.endDayOfWeek,
    required this.startTimeAt,
    required this.endTimeAt,
  });

  static const List<String> _wireKeys = [
    'startDayOfWeek',
    'endDayOfWeek',
    'startTimeAt',
    'endTimeAt',
  ];

  /// Throws [ArgumentError] when a key is absent. The server refuses an interval whose keys it does not know
  /// instead of ignoring it, so an interval this client cannot name means the contract moved under the app,
  /// and guessing would quietly drop the owner's window.
  factory ItemTimeInterval.fromJson(Map<String, dynamic> json) {
    final missing = _wireKeys.where((key) => !json.containsKey(key)).join(', ');
    if (missing.isNotEmpty) {
      throw ArgumentError.value(
          json, 'json', 'availability interval is missing $missing');
    }
    return ItemTimeInterval(
      startDayOfWeek: json['startDayOfWeek'] as int,
      endDayOfWeek: json['endDayOfWeek'] as int,
      startTimeAt: json['startTimeAt'] as String,
      endTimeAt: json['endTimeAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'startDayOfWeek': startDayOfWeek,
        'endDayOfWeek': endDayOfWeek,
        'startTimeAt': startTimeAt,
        'endTimeAt': endTimeAt,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemTimeInterval &&
          other.startDayOfWeek == startDayOfWeek &&
          other.endDayOfWeek == endDayOfWeek &&
          other.startTimeAt == startTimeAt &&
          other.endTimeAt == endTimeAt;

  @override
  int get hashCode =>
      Object.hash(startDayOfWeek, endDayOfWeek, startTimeAt, endTimeAt);

  @override
  String toString() =>
      'ItemTimeInterval(Mon=1 day $startDayOfWeek-$endDayOfWeek, '
      '$startTimeAt..$endTimeAt)';
}
