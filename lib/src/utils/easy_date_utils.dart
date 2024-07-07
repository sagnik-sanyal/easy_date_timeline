import 'package:flutter/material.dart' show DateUtils;

/// A utility class that provides easy access to commonly used date-related functions in the `EasyDateTimeLine` widget.
abstract class EasyDateUtils {
  /// Returns the number of days in the month of the given date.
  static int getDaysInMonth(DateTime date) {
    return DateUtils.getDaysInMonth(date.year, date.month);
  }

  /// Returns whether the given two dates represent the same day or not.
  static bool isSameDay(DateTime dateA, DateTime dateB) {
    return DateUtils.isSameDay(dateA, dateB);
  }

  /// function that takes a DateTime object as input and returns a boolean value
  /// indicating whether it is the current date or not.
  static bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return isSameDay(now, date);
  }

  /// Calculates the number of days between the [firstDate] and [lastDate] inclusive.
  /// Returns the count of days.
  static int calculateDaysCount(DateTime firstDate, DateTime lastDate) {
    return lastDate.difference(firstDate).inDays + 1;
  }
}
