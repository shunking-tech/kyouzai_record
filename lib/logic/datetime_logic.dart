import 'package:intl/intl.dart';

class DatetimeLogic {
  static String formatDate(DateTime dateTime) {
    DateFormat format = DateFormat('yyyy年MM月dd日');
    String dateText = format.format(dateTime);
    return dateText;
  }
}