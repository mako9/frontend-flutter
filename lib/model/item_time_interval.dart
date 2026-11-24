/// One weekly lending window, carried exactly as the backend serializes it.
///
/// The four fields are the wire contract of `ItemTimeIntervalDto`
/// (`backend-quarkus/src/main/kotlin/api/dto/ItemDto.kt:86-91`): the packaged artifact answers
/// `{"startDayOfWeek":1,"endDayOfWeek":3,"startTimeAt":"09:00Z","endTimeAt":"17:00Z"}`.
/// `startDayOfWeek` and `endDayOfWeek` are `java.time.DayOfWeek` values — **1 = Monday … 7 = Sunday** — and the
/// two times are `OffsetTime` text, which is why they are strings and not [DateTime].
///
/// Nothing in this class parses, reformats or normalises anything, deliberately. The app has no availability
/// editor (that is plan 2d), so its whole job is to carry the owner's windows through a read and hand the
/// identical ones back on save: `PATCH /api/user/item/{uuid}` replaces the column from the request body, so a
/// window that comes back changed, or not at all, is a window erased.
///
/// Two measured limits on that promise, both from the packaged artifact on 2026-11-24:
///
///  * A key this class does not know is **ignored on read and dropped on write** — it is not rejected. Quarkus
///    leaves unknown JSON properties alone, so `{"…four keys…","tz":"Europe/Berlin"}` is accepted and comes back
///    without `tz`. So the four names are load-bearing, but a fifth field added server-side would be erased by
///    the next mobile save; whoever adds one adds it here in the same change.
///  * The server keeps only minutes-of-day and answers in UTC, so `08:30+01:00` is stored and returned as
///    `08:30Z` (`DateTimeUtils.kt`, and `TimeIntervalModel`'s `startTimeAtInMinute`). Passing the text through
///    untouched is still right — it just cannot rescue an offset the backend has already thrown away.
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

  /// Throws [ArgumentError] when one of the four keys is absent. A *missing* key is a contract break the app
  /// must not paper over: all four are non-null on the server, so an interval without them is not an interval,
  /// and inventing a value would rewrite the owner's window with something false. A key the app does not know
  /// is the opposite case and is ignored — see the class comment for what that costs.
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
