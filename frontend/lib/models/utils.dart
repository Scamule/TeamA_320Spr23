import 'package:intl/intl.dart';

// Utility class for date and time formatting

class Utils {
  /// Format a DateTime object to a formatted date and time string.
  ///
  /// Example output: "Jan 1, 2022 10:30 AM"
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime); // Format the date
    final time = DateFormat.Hm().format(dateTime); // Format the time

    return '$date $time'; // Combine the date and time
  }

  /// Format a DateTime object to a formatted date string.
  ///
  /// Example output: "Jan 1, 2022"
  static String toDate(DateTime dateTime) {
    
    final date = DateFormat.yMMMEd().format(dateTime); // Format the date

    return '$date'; // Return the formatted date
  }

  /// Format a DateTime object to a formatted time string.
  ///
  /// Example output: "10:30 AM"
  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime); // Format the time

    return '$time'; // Return the formatted time
  }
}
