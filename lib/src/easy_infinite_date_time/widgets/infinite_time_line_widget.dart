import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SliverLayoutDimensions;

import '../../properties/properties.dart';
import '../../utils/utils.dart';
import 'web_scroll_behavior.dart';

part 'infinite_timeline_controller.dart';

class InfiniteTimeLineWidget extends StatefulWidget {
  InfiniteTimeLineWidget({
    required this.firstDate,
    required this.focusedDate,
    required this.activeDayTextColor,
    required this.activeDayColor,
    required this.lastDate,
    required this.selectionMode,
    super.key,
    this.inactiveDayPredicate,
    this.dayProps = const EasyDayProps(),
    this.locale = "en_US",
    this.timeLineProps = const EasyTimeLineProps(),
    this.onDateChange,
    required this.itemBuilder,
    this.physics,
    this.controller,
    this.hiddenDayPredicate,
  })  : assert(timeLineProps.hPadding > -1,
            "Can't set timeline hPadding less than zero."),
        assert(timeLineProps.separatorPadding > -1,
            "Can't set timeline separatorPadding less than zero."),
        assert(timeLineProps.vPadding > -1,
            "Can't set timeline vPadding less than zero."),
        assert(
          !lastDate.isBefore(firstDate),
          'lastDate $lastDate must be on or after firstDate $firstDate.',
        );

  /// Represents the initial date for the timeline widget.
  /// This is the date that will be displayed as the first day in the timeline.
  final DateTime firstDate;

  /// Represents the last date for the timeline widget.
  /// This is the date that will be displayed as the last day in the timeline.
  final DateTime lastDate;

  /// The currently focused date in the timeline.
  final DateTime? focusedDate;

  /// The color of the text for the selected day.
  final Color activeDayTextColor;

  /// The background color of the selected day.
  final Color activeDayColor;

  /// Inactive day predicate that determines whether a day is inactive.
  final bool Function(DateTime)? inactiveDayPredicate;

  /// Dates that are considered hiddent and arent rendered in the timeline.
  final bool Function(DateTime)? hiddenDayPredicate;

  /// Contains properties for configuring the appearance and behavior of
  /// the timeline widget.
  /// This object includes properties such as the height of the timeline,
  /// the color of the selected day,
  /// and the animation duration for scrolling.
  final EasyTimeLineProps timeLineProps;

  /// Contains properties for configuring the appearance and behavior of
  /// the day widgets in the timeline.
  /// This object includes properties such as the width and height of each
  /// day widget,
  /// the color of the text and background, and the font size.
  final EasyDayProps dayProps;

  /// Called when the selected date in the timeline changes.
  /// This function takes a `DateTime` object as its parameter, which
  /// represents the new selected date.
  final OnDateChangeCallBack? onDateChange;

  /// Called for each day in the timeline, allowing the developer
  /// to customize the appearance and behavior of each day widget.
  /// This function takes a `BuildContext` and a `DateTime` object as its
  /// parameters, and should return a `Widget` that represents the day.
  final ItemBuilderCallBack itemBuilder;

  /// A `String` that represents the locale code to use for formatting the
  /// dates in the timeline.
  final String locale;

  /// Determines the selection mode of the infinite date timeline.
  ///
  /// The [selectionMode] specifies how the timeline should behave when
  /// the selected date changes.
  /// It can be set to one of the following values:
  /// - [SelectionMode.none]: The timeline does not animate the selection.
  /// - [SelectionMode.autoCenter]: The timeline automatically centers
  /// the selected date.
  /// - [SelectionMode.alwaysFirst]: The timeline always positions the
  /// selected date at the first visible day of the timeline.
  ///
  /// By default, the selection mode is set to [SelectionMode.autoCenter].
  ///
  /// This property is used to customize the behavior of the timeline
  /// when the selected date changes.
  /// For example, if you set it to `SelectionMode.alwaysFirst()`,
  /// the timeline will always position the selected date at the first
  /// visible day of the timeline.
  final SelectionMode selectionMode;

  /// The controller to manage the EasyInfiniteDateTimeline. Allows
  /// programmatic control over the timeline,
  /// such as scrolling to a specific date or scrolling to the focus date.
  final EasyInfiniteDateTimelineController? controller;

  final ScrollPhysics? physics;

  @override
  State<InfiniteTimeLineWidget> createState() => _InfiniteTimeLineWidgetState();
}

class _InfiniteTimeLineWidgetState extends State<InfiniteTimeLineWidget> {
  /// Returns the [EasyDayProps] associated with the widget.
  EasyDayProps get _dayProps => widget.dayProps;

  /// Returns the [EasyTimeLineProps] associated with this [InfiniteTimeLineWidget].
  EasyTimeLineProps get _timeLineProps => widget.timeLineProps;

  /// Returns a boolean value indicating whether the widget is in landscape mode.
  bool get _isLandscapeMode => _dayProps.landScapeMode;

  /// Returns the width of a single day in the timeline.
  double get _dayWidth => _dayProps.width;

  /// Returns the height of a single day in the timeline.
  double get _dayHeight => _dayProps.height;

  /// Scroll controller for the infinite timeline widget.
  late final ScrollController _controller;

  /// Returns the focus date of the timeline widget.
  /// If the `focusedDate` property is not set,
  /// it returns the `firstDate` property.
  DateTime get _focusDate => widget.focusedDate ?? widget.firstDate;

  /// The extent of each item in the infinite timeline widget.
  double _itemExtent = 0.0;

  late final int _daysCount;

  @override
  void initState() {
    super.initState();
    _initItemExtend();
    _attachEasyController();
    _daysCount = _daysDifference(widget.firstDate, widget.lastDate);
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToInitialOffset());
  }

  /// Calculates the number of days between the [firstDate]
  /// and [lastDate] inclusive.
  /// Returns the count of days.
  int _daysDifference(DateTime firstDate, DateTime lastDate) =>
      lastDate.difference(firstDate).inDays + 1;

  void _jumpToInitialOffset() {
    final initialScrollOffset = _getScrollOffset();
    if (_controller.hasClients) _controller.jumpTo(initialScrollOffset);
  }

  @override
  void didUpdateWidget(covariant InfiniteTimeLineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _attachEasyController();
    } else if (widget.timeLineProps != oldWidget.timeLineProps ||
        widget.dayProps != oldWidget.dayProps) {
      _initItemExtend();
    } else if (widget.selectionMode != oldWidget.selectionMode) {
      _jumpToInitialOffset();
    }
  }

  /// Attaches the [EasyInfiniteDateTimelineController]
  /// to the [InfiniteTimeLineWidget].
  ///
  /// This method is responsible for attaching the
  /// [EasyInfiniteDateTimelineController] provided by the widget
  /// to the [InfiniteTimeLineWidget].
  /// It calls the `_attachEasyDateState` method on the
  /// [EasyInfiniteDateTimelineController] to establish the connection.
  ///
  /// If the [EasyInfiniteDateTimelineController] is not
  /// provided, this method does nothing.
  void _attachEasyController() => widget.controller?._attachEasyDateState(this);

  /// Detaches the [EasyInfiniteDateTimelineController]
  /// from the [InfiniteTimeLineWidget].
  ///
  /// This method is responsible for detaching the
  /// [EasyInfiniteDateTimelineController] provided by the widget
  /// from the [InfiniteTimeLineWidget].
  /// It calls the `_detachEasyDateState` method on the
  /// [EasyInfiniteDateTimelineController] to remove the connection.
  ///
  /// If the [EasyInfiniteDateTimelineController] is not provided,
  /// this method does nothing.
  void _detachEasyController() => widget.controller?._detachEasyDateState();

  @override
  void dispose() {
    _controller.dispose();
    _detachEasyController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double effectiveTimeLineHeight =
        _isLandscapeMode ? _dayWidth : _dayHeight;
    final Color? effectiveTimeLineBackgroundColor =
        _timeLineProps.decoration == null
            ? _timeLineProps.backgroundColor
            : null;
    final BorderRadiusGeometry effectiveTimeLineBorderRadius =
        _timeLineProps.decoration?.borderRadius ?? BorderRadius.zero;
    return Container(
      height: effectiveTimeLineHeight,
      margin: _timeLineProps.margin,
      color: effectiveTimeLineBackgroundColor,
      decoration: _timeLineProps.decoration,
      child: ClipRRect(
        borderRadius: effectiveTimeLineBorderRadius,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          scrollBehavior: EasyCustomScrollBehavior(),
          controller: _controller,
          physics: widget.physics,
          slivers: <SliverPadding>[
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: _timeLineProps.hPadding,
                vertical: _timeLineProps.vPadding,
              ),
              sliver: SliverVariedExtentList.builder(
                itemCount: _daysCount,
                itemExtentBuilder: (int index, SliverLayoutDimensions layout) {
                  final DateTime currentDate =
                      widget.firstDate.add(Duration(days: index));
                  return (widget.hiddenDayPredicate?.call(currentDate) ?? false)
                      ? 0
                      : _itemExtent;
                },
                itemBuilder: (context, index) {
                  /// Adds a duration of [index] days to the
                  /// [firstDate] and assigns the result to [currentDate].
                  ///
                  /// The [firstDate] is the starting date
                  /// from which the duration is added.
                  /// The [index] represents the number of
                  /// days to be added to the [firstDate].
                  final DateTime currentDate =
                      widget.firstDate.add(Duration(days: index));
                  return Padding(
                    key: ValueKey<DateTime>(currentDate),
                    padding: EdgeInsets.symmetric(
                      horizontal: _timeLineProps.separatorPadding / 2,
                    ),
                    child: widget.itemBuilder(
                      context,
                      currentDate,
                      DateUtils.isSameDay(_focusDate, currentDate),
                      () => _onDayTapped(currentDate),
                      widget.inactiveDayPredicate?.call(currentDate) ?? false,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Callback function that is called when a day is tapped.
  ///
  /// The [currentDate] parameter represents the current selected date.
  void _onDayTapped(DateTime currentDate) {
    widget.onDateChange?.call(currentDate);
    final SelectionMode selectionMode = widget.selectionMode;
    if (selectionMode.isAutoCenter || selectionMode.isAlwaysFirst) {
      final double offset = _getScrollOffset(currentDate);
      _controller.animateTo(
        offset,
        duration: selectionMode.duration ?? kThemeAnimationDuration,
        curve: selectionMode.curve ?? Curves.linear,
      );
    }
  }

  /// Calculates the scroll offset for the specified [lastDate].
  ///
  /// If [lastDate] is not provided, it falls back to [widget.focusedDate].
  ///
  /// Returns the calculated scroll offset.
  double _getScrollOffset([DateTime? lastDate]) {
    // Get the last date to use, defaulting to widget.focusedDate
    // if not provided
    final DateTime? effectiveLastDate = lastDate ?? widget.focusedDate;
    if (effectiveLastDate == null) return 0;
    final InfiniteTimelineScrollHelper scrollHelper =
        InfiniteTimelineScrollHelper(
      firstDate: widget.firstDate,
      lastDate: effectiveLastDate,
      dayWidth: _itemExtent,
      maxScrollExtent: _controller.position.maxScrollExtent,
      screenWidth: _controller.position.viewportDimension,
      isHiddenDay: widget.hiddenDayPredicate,
    );
    return switch (widget.selectionMode) {
      // If the selection mode is none or always first
      SelectionModeNone() ||
      SelectionModeAlwaysFirst() =>
        scrollHelper.getScrollPositionForFirstDate(),
      // If the selection mode is auto center
      SelectionModeAutoCenter() =>
        scrollHelper.getScrollPositionForCenterDate(),
    };
  }

  /// Initializes the item extend value based on the current orientation and timeline properties.
  /// The item extend value is calculated by adding the day height or day width (depending on the landscape mode)
  /// with the separator padding from the timeline properties.
  void _initItemExtend() {
    _itemExtent = (_isLandscapeMode ? _dayHeight : _dayWidth) +
        _timeLineProps.separatorPadding;
  }
}
