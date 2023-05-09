import 'package:intl/intl.dart';

//for date and time formatting
class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time'; //formats to date / time
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);  // format of week day : month day : year


    return '$date'; //formats date component from DateTime obj
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime); //format of hour:minute


    return '$time'; //formats time component from DateTime obj

  }
}