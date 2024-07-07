import 'package:flutter/widgets.dart';

/// A function type that takes a `DateTime` object representing the
/// selected date as a parameter and returns no result.
///
/// Used by `EasyDateTimeLine` for detecting changes in the selected date.
typedef OnDateChangeCallBack = void Function(DateTime selectedDate);

/// A function type that takes the necessary information for building an item
/// in the date-time line as parameters and returns a `Widget` object.
///
/// Used by `EasyDateTimeLine` for setting the item builder.
// typedef ItemBuilderCallBack = Widget Function(
//   BuildContext context,
//   String dayNumber,
//   String dayName,
//   String monthName,
//   DateTime fullDate,
//   bool isSelected,
// );
typedef ItemBuilderCallBack = Widget Function({
  required BuildContext context,
  required DateTime date,
  bool isFocused,
  VoidCallback onTap,
  bool isDisabled,
});
