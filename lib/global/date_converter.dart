import 'package:intl/intl.dart';

abstract class DateConverter {
  static final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

  static String dateToString(DateTime date) {
    return formatter.format(date.toUtc());
  }

  static DateTime stringToDate(String date) {
    return formatter.parse(date);
  }
}
