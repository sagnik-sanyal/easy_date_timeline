// import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_local.dart';

// import '../../properties/properties.dart';
// import '../../utils/utils.dart';
// import '../time_line_widget/timeline_widget.dart';

// /// Represents a timeline widget for displaying dates in a horizontal line.
// class EasyDateTimeLine extends StatefulWidget {
//   const EasyDateTimeLine({
//     super.key,
//     required this.initialDate,
//     this.inactiveDayPredicate,
//     this.timeLineProps = const EasyTimeLineProps(),
//     this.dayProps = const EasyDayProps(),
//     this.onDateChange,
//     required this.itemBuilder,
//     this.activeColor,
//     this.locale = "en_US",
//   });

//   /// Represents the initial date for the timeline widget.
//   /// This is the date that will be displayed as the first day in the timeline.
//   final DateTime initialDate;

//   /// Represents a list of inactive dates for the timeline widget.
//   /// Note that all the dates defined in the `disabledDates` list will be deactivated.
//   final bool Function(DateTime)? inactiveDayPredicate;

//   /// The color for the active day.
//   final Color? activeColor;

//   /// Contains properties for configuring the appearance and behavior of the timeline widget.
//   final EasyTimeLineProps timeLineProps;

//   /// Contains properties for configuring the appearance and behavior of the day widgets in the timeline.
//   /// This includes properties such as the width and height of each day widget,
//   /// the color of the text and background, and the font size.
//   final EasyDayProps dayProps;

//   /// Called when the selected date in the timeline changes.
//   /// This function takes a `DateTime` object as its parameter, which represents the new selected date.
//   final OnDateChangeCallBack? onDateChange;

//   /// > **NOTE:**
//   /// > When utilizing the `itemBuilder`, it is essential to provide the width of each day for the date timeline widget.
//   /// >
//   ///
//   /// For example:
//   /// ```dart
//   /// dayProps: const EasyDayProps(
//   ///  // You must specify the width in this case.
//   ///  width: 124.0,
//   /// )
//   /// ```

//   final ItemBuilderCallBack itemBuilder;

//   /// A `String` that represents the locale code to use for formatting the dates in the timeline.
//   final String locale;

//   @override
//   State<EasyDateTimeLine> createState() => _EasyDateTimeLineState();
// }

// class _EasyDateTimeLineState extends State<EasyDateTimeLine> {
//   late ValueNotifier<DateTime?> _focusedDateListener;
//   DateTime get initialDate => widget.initialDate;

//   @override
//   void didUpdateWidget(covariant EasyDateTimeLine oldWidget) {
//     if (widget.initialDate != oldWidget.initialDate) {
//       _onFocusedDateChanged(widget.initialDate);
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void initState() {
//     // Init easy date timeline locale
//     initializeDateFormatting(widget.locale, null);
//     super.initState();
//     _focusedDateListener = ValueNotifier(initialDate);
//   }

//   void _onFocusedDateChanged(DateTime date) {
//     _focusedDateListener.value = date;
//     widget.onDateChange?.call(date);
//   }

//   @override
//   void dispose() {
//     _focusedDateListener.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     /// activeDayColor is initialized to the value of widget.activeColor if it is not null,
//     /// or to the primary color of the current theme if widget.activeColor is null.
//     /// This provides a fallback color if no active color is explicitly provided.
//     final Color activeDayColor =
//         widget.activeColor ?? Theme.of(context).primaryColor;

//     /// brightness is initialized to the brightness of the active color or the fallback color,
//     /// using the ThemeData.estimateBrightnessForColor method.
//     /// This method returns Brightness.dark if the color is closer to black,
//     ///  and Brightness.light if the color is closer to white.
//     final Brightness brightness = ThemeData.estimateBrightnessForColor(
//       widget.activeColor ?? activeDayColor,
//     );

//     /// activeDayTextColor is initialized to EasyColors.dayAsNumColor
//     /// if the brightness is Brightness.light,
//     /// indicating that the active color is light, or to
//     /// Colors.white if the brightness is Brightness.dark,
//     /// indicating that the active color is dark.
//     final activeDayTextColor = brightness == Brightness.light
//         ? EasyColors.dayAsNumColor
//         : Colors.white;
//     return ValueListenableBuilder(
//       valueListenable: _focusedDateListener,
//       builder: (context, focusedDate, child) => TimeLineWidget(
//         initialDate: initialDate,
//         inactiveDayPredicate: widget.inactiveDayPredicate,
//         focusedDate: focusedDate,
//         onDateChange: _onFocusedDateChanged,
//         timeLineProps: widget.timeLineProps,
//         dayProps: widget.dayProps,
//         itemBuilder: widget.itemBuilder,
//         activeDayTextColor: activeDayTextColor,
//         activeDayColor: activeDayColor,
//         locale: widget.locale,
//       ),
//     );
//   }
// }
