import 'package:intl/intl.dart';

class DateUtil {
  static String? toDateString(DateTime? dateTime) {
    if (dateTime == null) return null;
    DateFormat dateFormat = DateFormat.yMd();
    return dateFormat.format(dateTime);
  }
}