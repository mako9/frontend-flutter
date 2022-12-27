import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class JsonUtil {
  static DateTime? parseDateString(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (exception) {
      debugPrint('Could not parse date string $dateString: $exception');
      return null;
    }
  }

  static String? parseDateTime(DateTime? dateTime) {
    if (dateTime == null) return null;
    var dateString = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
    var offset = dateTime.timeZoneOffset;
    var offsetInHours = offset.inHours > 0 ? offset.inHours : 1; // For fixing divide by 0

    if (!offset.isNegative) {
      dateString = "$dateString+${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % (offsetInHours * 60)).toString().padLeft(2, '0')}";
    } else {
      dateString = "$dateString-${(-offset.inHours).toString().padLeft(2, '0')}:${(offset.inMinutes % (offsetInHours * 60)).toString().padLeft(2, '0')}";
    }
    print(dateString);
    return dateString;
  }
}