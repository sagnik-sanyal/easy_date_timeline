import 'package:flutter/material.dart' show DateUtils;

final class InfiniteTimelineScrollHelper {
  /// A utility class that provides methods to calculate the scroll position
  /// for the [EasyInfiniteDateTimeLine] widget.
  ///
  /// The [InfiniteTimelineScrollHelper] class provides methods to calculate
  /// the scroll position for the [EasyInfiniteDateTimeLine] widget based on the
  /// first and last dates, the day width, the maximum scroll extent, and the
  /// screen width.
  InfiniteTimelineScrollHelper({
    required this.firstDate,
    required this.lastDate,
    required this.dayWidth,
    required this.maxScrollExtent,
    required this.screenWidth,
    this.isHiddenDay,
  });

  /// The first date of the timeline.
  final DateTime firstDate;

  /// The last date of the timeline.
  final DateTime lastDate;

  /// The width of a day widget.
  final double dayWidth;

  /// The maximum scroll extent of the timeline.
  final double maxScrollExtent;

  /// The width of the screen.
  final double screenWidth;

  /// Hidden day predicate
  final bool Function(DateTime)? isHiddenDay;

  /// Calculates the scroll position to place the selected date at the leftmost
  /// position of the timeline.
  ///
  /// The calculation is based on the first and last dates, the day width,
  /// the maximum scroll extent, and the screen width.
  ///
  /// Returns the scroll position to place the selected date at the leftmost
  /// position. If the calculated scroll position is greater than the maximum
  /// scroll extent, the maximum scroll extent is returned instead.
  double getScrollPositionForFirstDate() {
    // Calculate the number of days between the first and last dates
    final dayIndex = _dateDifference(firstDate, lastDate);
    // Calculate the target scroll position to place the first date at the
    // leftmost position
    final double targetScrollPosition = dayIndex * dayWidth;

    // Check if the target scroll position is within the valid range
    final bool canApplyAutoFirst = targetScrollPosition <= maxScrollExtent;

    // Calculate and return the horizontal offset to place the first date at
    // the leftmost position. If the target scroll position is out of range,
    // return the maximum scroll extent.
    return canApplyAutoFirst ? targetScrollPosition : maxScrollExtent;
  }

  /// Calculates the scroll position to center the date.
  ///
  /// The calculation is based on the first and last dates, the day width,
  /// the maximum scroll extent, and the screen width.
  ///
  /// Returns the scroll position to center the date.
  double getScrollPositionForCenterDate() {
    // Calculate the number of days between the first and last dates
    final dayIndex = _dateDifference(firstDate, lastDate);

    // Calculate the half of the screen width
    final double halfScreenWidth = screenWidth / 2;

    // Calculate the half of the width of a day widget
    final double halfItemWidth = dayWidth / 2;

    // Calculate the total width of all day widgets
    final double totalDaysWidth = dayIndex * dayWidth;

    // Calculate the target scroll position to center the date
    final double targetScrollPosition =
        totalDaysWidth - halfScreenWidth + halfItemWidth;

    // Check if the target scroll position is within the valid range
    final canApplyAutoCenter =
        targetScrollPosition >= 0 && targetScrollPosition <= maxScrollExtent;

    // Calculate and return the horizontal offset to center the date
    if (canApplyAutoCenter) return targetScrollPosition;
    // If the target scroll position is out of range,
    //return the maximum or minimum scroll extent
    return targetScrollPosition <= 0.0 ? 0.0 : maxScrollExtent;
  }

  /// Computes the number of days between the first date and the end date in the
  /// timeline excluding the hidden days.
  int _dateDifference(DateTime firstDate, DateTime endDate) {
    if (firstDate.isAfter(endDate)) return 0;
    int count = 0;
    DateTime start = DateUtils.dateOnly(firstDate);
    final DateTime end = DateUtils.dateOnly(endDate);
    while (start.isBefore(end)) {
      if (isHiddenDay != null && isHiddenDay!(start)) {
        start = DateUtils.addDaysToDate(start, 1);
        continue;
      }
      count++;
      start = DateUtils.addDaysToDate(start, 1);
    }
    return count;
  }
}
