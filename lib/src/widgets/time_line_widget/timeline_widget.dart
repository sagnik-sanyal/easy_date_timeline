// import 'package:easy_date_timeline/src/easy_infinite_date_time/widgets/web_scroll_behavior.dart';
// import 'package:flutter/material.dart';

// import '../../properties/easy_day_props.dart';
// import '../../properties/time_line_props.dart';
// import '../../utils/utils.dart';

// /// A widget that displays a timeline of days.
// class TimeLineWidget extends StatefulWidget {
//   TimeLineWidget({
//     super.key,
//     required this.initialDate,
//     required this.focusedDate,
//     required this.activeDayTextColor,
//     required this.activeDayColor,
//     this.inactiveDayPredicate,
//     this.locale = "en_US",
//     this.dayProps = const EasyDayProps(),
//     this.timeLineProps = const EasyTimeLineProps(),
//     this.onDateChange,
//     required this.itemBuilder,
//   })  : assert(timeLineProps.hPadding > -1,
//             "Can't set timeline hPadding less than zero."),
//         assert(timeLineProps.separatorPadding > -1,
//             "Can't set timeline separatorPadding less than zero."),
//         assert(timeLineProps.vPadding > -1,
//             "Can't set timeline vPadding less than zero.");

//   /// Represents the initial date for the timeline widget.
//   /// This is the date that will be displayed as the first day in the timeline.
//   final DateTime initialDate;

//   /// The currently focused date in the timeline.
//   final DateTime? focusedDate;

//   /// The color of the text for the selected day.
//   final Color activeDayTextColor;

//   /// The background color of the selected day.
//   final Color activeDayColor;

//   /// Represents function that shows the predicate for inactive days
//   final bool Function(DateTime)? inactiveDayPredicate;

//   /// Contains properties for configuring the appearance and
//   /// behavior of the timeline widget.
//   /// This object includes properties such as the height of the timeline,
//   /// the color of the selected day,
//   /// and the animation duration for scrolling.
//   final EasyTimeLineProps timeLineProps;

//   /// Contains properties for configuring the appearance and
//   /// behavior of the day widgets in the timeline.
//   /// This object includes properties such as the width and
//   /// height of each day widget,
//   /// the color of the text and background, and the font size.
//   final EasyDayProps dayProps;

//   /// Called when the selected date in the timeline changes.
//   /// This function takes a `DateTime` object as its parameter,
//   /// which represents the new selected date.
//   final OnDateChangeCallBack? onDateChange;

//   /// Called for each day in the timeline, allowing the developer to
//   /// customize the appearance and behavior of each day widget.
//   /// This function takes a `BuildContext` and a `DateTime` object
//   /// as its parameters, and should return a `Widget` that represents the day.
//   final ItemBuilderCallBack itemBuilder;

//   /// A `String` that represents the locale code to use for formatting
//   /// the dates in the timeline.
//   final String locale;

//   @override
//   State<TimeLineWidget> createState() => _TimeLineWidgetState();
// }

// class _TimeLineWidgetState extends State<TimeLineWidget> {
//   EasyDayProps get _dayProps => widget.dayProps;
//   EasyTimeLineProps get _timeLineProps => widget.timeLineProps;
//   bool get _isLandscapeMode => _dayProps.landScapeMode;
//   double get _dayWidth => _dayProps.width;
//   double get _dayHeight => _dayProps.height;
//   double get _dayOffsetConstrains => _isLandscapeMode ? _dayHeight : _dayWidth;

//   late ScrollController _controller;
//   @override
//   void initState() {
//     super.initState();
//     _controller = ScrollController(
//       initialScrollOffset: _calculateDateOffset(widget.initialDate),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   /// the method calculates the number of days between startDate
//   /// and date using the difference() method
//   /// of the Duration class. This value is stored in the offset variable.
//   /// If offset is equal to 0, the method returns 0.0.
//   /// Otherwise, the method calculates the horizontal offset of the day
//   /// by multiplying the offset value by the width of a day widget
//   /// (which is either the value of widget.easyDayProps.width or a
//   /// default value of EasyConstants.dayWidgetWidth).
//   /// It then adds to this value the product of offset and
//   /// [EasyConstants.separatorPadding] (which represents the
//   /// width of the space between each day widget)
//   double _calculateDateOffset(DateTime date) {
//     final startDate = DateTime(date.year, date.month, 1);
//     int offset = date.difference(startDate).inDays;
//     double adjustedHPadding =
//         _timeLineProps.hPadding > EasyConstants.timelinePadding
//             ? (_timeLineProps.hPadding - EasyConstants.timelinePadding)
//             : 0.0;
//     if (offset == 0) return 0.0;
//     return (offset * _dayOffsetConstrains) +
//         (offset * _timeLineProps.separatorPadding) +
//         adjustedHPadding;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final DateTime initialDate = widget.initialDate;
//     final double effectiveTimeLineHeight =
//         _isLandscapeMode ? _dayWidth : _dayHeight;
//     final Color? effectiveTimeLineBackgroundColor =
//         _timeLineProps.decoration == null
//             ? _timeLineProps.backgroundColor
//             : null;
//     final BorderRadiusGeometry effectiveTimeLineBorderRadius =
//         _timeLineProps.decoration?.borderRadius ?? BorderRadius.zero;

//     return Container(
//       height: effectiveTimeLineHeight,
//       margin: _timeLineProps.margin,
//       color: effectiveTimeLineBackgroundColor,
//       decoration: _timeLineProps.decoration,
//       child: ClipRRect(
//         borderRadius: effectiveTimeLineBorderRadius,
//         child: ScrollConfiguration(
//           behavior: EasyCustomScrollBehavior(),
//           child: ListView.separated(
//             controller: _controller,
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(
//               horizontal: _timeLineProps.hPadding,
//               vertical: _timeLineProps.vPadding,
//             ),
//             itemBuilder: (BuildContext context, int index) {
//               final DateTime currentDate =
//                   DateTime(initialDate.year, initialDate.month, index + 1);
//               return widget.itemBuilder(
//                 context: context,
//                 date: currentDate,
//                 isSelected: DateUtils.isSameDay(
//                     widget.focusedDate ?? initialDate, currentDate),
//                 onTap: () => widget.onDateChange?.call(currentDate),
//                 isDisabled:
//                     widget.inactiveDayPredicate?.call(currentDate) ?? false,
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return SizedBox(width: _timeLineProps.separatorPadding);
//             },
//             itemCount: EasyDateUtils.getDaysInMonth(initialDate),
//           ),
//         ),
//       ),
//     );
//   }
// }
