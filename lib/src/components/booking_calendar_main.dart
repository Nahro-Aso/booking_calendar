import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;

import '../core/booking_controller.dart';
import '../model/booking_service.dart';
import '../model/enums.dart' as bc;
import '../util/booking_util.dart';
import 'booking_dialog.dart';
import 'booking_explanation.dart';
import 'booking_slot.dart';
import 'common_button.dart';
import 'common_card.dart';

class BookingCalendarMain extends StatefulWidget {
  const BookingCalendarMain({
    super.key,
    required this.getBookingStream,
    required this.convertStreamResultToDateTimeRanges,
    required this.uploadBooking,
    this.bookingExplanation,
    this.bookingGridCrossAxisCount,
    this.bookingGridChildAspectRatio,
    this.formatDateTime,
    this.bookingButtonText,
    this.bookingButtonColor,
    this.bookedSlotColor,
    this.selectedSlotColor,
    this.availableSlotColor,
    this.bookedSlotText,
    this.bookedSlotTextStyle,
    this.selectedSlotText,
    this.selectedSlotTextStyle,
    this.availableSlotText,
    this.availableSlotTextStyle,
    this.gridScrollPhysics,
    this.loadingWidget,
    this.errorWidget,
    this.uploadingWidget,
    this.wholeDayIsBookedWidget,
    this.pauseSlotColor,
    this.pauseSlotText,
    this.hideBreakTime = false,
    this.locale,
    this.startingDayOfWeek,
    this.disabledDays,
    this.disabledDates,
    this.lastDay,
  });

  final Stream<dynamic>? Function(
      {required DateTime start, required DateTime end}) getBookingStream;
  final Future<dynamic> Function({required BookingService newBooking})
      uploadBooking;
  final List<DateTimeRange> Function({required dynamic streamResult})
      convertStreamResultToDateTimeRanges;

  ///Customizable
  final Widget? bookingExplanation;
  final int? bookingGridCrossAxisCount;
  final double? bookingGridChildAspectRatio;
  final String Function(DateTime dt)? formatDateTime;
  final String? bookingButtonText;
  final Color? bookingButtonColor;
  final Color? bookedSlotColor;
  final Color? selectedSlotColor;
  final Color? availableSlotColor;
  final Color? pauseSlotColor;

//Added optional TextStyle to available, booked and selected cards.
  final String? bookedSlotText;
  final String? selectedSlotText;
  final String? availableSlotText;
  final String? pauseSlotText;

  final TextStyle? bookedSlotTextStyle;
  final TextStyle? availableSlotTextStyle;
  final TextStyle? selectedSlotTextStyle;

  final ScrollPhysics? gridScrollPhysics;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? uploadingWidget;

  final bool? hideBreakTime;
  final DateTime? lastDay;
  final String? locale;
  final bc.StartingDayOfWeek? startingDayOfWeek;
  final List<int>? disabledDays;
  final List<DateTime>? disabledDates;

  final Widget? wholeDayIsBookedWidget;

  @override
  State<BookingCalendarMain> createState() => _BookingCalendarMainState();
}

class _BookingCalendarMainState extends State<BookingCalendarMain> {
  late BookingController controller;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = context.read<BookingController>();
    final firstDay = calculateFirstDay();

    startOfDay = firstDay.startOfDayService(controller.serviceOpening!);
    endOfDay = firstDay.endOfDayService(controller.serviceClosing!);
    _focusedDay = firstDay;
    _selectedDay = firstDay;
    controller.selectFirstDayByHoliday(startOfDay, endOfDay);
  }

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime startOfDay;
  late DateTime endOfDay;

  void selectNewDateRange() {
    startOfDay = _selectedDay.startOfDayService(controller.serviceOpening!);
    endOfDay = _selectedDay
        .add(const Duration(days: 1))
        .endOfDayService(controller.serviceClosing!);

    controller.base = startOfDay;
    controller.resetSelectedSlot();
  }

  DateTime calculateFirstDay() {
    final now = DateTime.now();
    if (widget.disabledDays != null) {
      return widget.disabledDays!.contains(now.weekday)
          ? now.add(Duration(days: getFirstMissingDay(now.weekday)))
          : now;
    } else {
      return DateTime.now();
    }
  }

  int getFirstMissingDay(int now) {
    for (var i = 1; i <= 7; i++) {
      if (!widget.disabledDays!.contains(now + i)) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    controller = context.watch<BookingController>();

    return Consumer<BookingController>(
      builder: (_, controller, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: (controller.isUploading)
            ? widget.uploadingWidget ?? const BookingDialog()
            : Column(
                children: [
                  CommonCard(
                    child: TableCalendar(
                      startingDayOfWeek: widget.startingDayOfWeek?.toTC() ??
                          tc.StartingDayOfWeek.monday,
                      holidayPredicate: (day) {
                        if (widget.disabledDates == null) return false;

                        bool isHoliday = false;
                        for (var holiday in widget.disabledDates!) {
                          if (isSameDay(day, holiday)) {
                            isHoliday = true;
                          }
                        }
                        return isHoliday;
                      },
                      enabledDayPredicate: (day) {
                        if (widget.disabledDays == null &&
                            widget.disabledDates == null) {
                          return true;
                        }

                        bool isEnabled = true;
                        if (widget.disabledDates != null) {
                          for (var holiday in widget.disabledDates!) {
                            if (isSameDay(day, holiday)) {
                              isEnabled = false;
                            }
                          }
                          if (!isEnabled) return false;
                        }
                        if (widget.disabledDays != null) {
                          isEnabled =
                              !widget.disabledDays!.contains(day.weekday);
                        }

                        return isEnabled;
                      },
                      locale: widget.locale,
                      firstDay: calculateFirstDay(),
                      lastDay: widget.lastDay ??
                          DateTime.now().add(const Duration(days: 1000)),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        todayDecoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          border: Border.all(color: Colors.black, width: 0.25),
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: Colors.black,
                          border: Border.fromBorderSide(
                            BorderSide(color: Colors.black, width: 0.25),
                          ),
                        ),
                        weekendTextStyle: TextStyle(
                          color: Colors.red.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        defaultTextStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        outsideTextStyle: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontWeight: FontWeight.w400,
                        ),
                        disabledTextStyle: TextStyle(
                          color: Colors.black.withOpacity(0.2),
                          fontWeight: FontWeight.w400,
                        ),
                        holidayTextStyle: TextStyle(
                          color: Colors.red.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                        markersMaxCount: 1,
                        markerDecoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                        ),
                        tablePadding: const EdgeInsets.all(8),
                        cellMargin: const EdgeInsets.all(2),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.1),
                            width: 0.25,
                          ),
                        ),
                        formatButtonTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.black.withOpacity(0.7),
                          size: 20,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.black.withOpacity(0.7),
                          size: 20,
                        ),
                        titleTextStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 0.3,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        weekendStyle: TextStyle(
                          color: Colors.red.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                          selectNewDateRange();
                        }
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  widget.bookingExplanation ??
                      Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 12.0,
                        runSpacing: 12.0,
                        direction: Axis.horizontal,
                        children: [
                          BookingExplanation(
                              color: widget.availableSlotColor ??
                                  Colors.green.withOpacity(0.05),
                              text: widget.availableSlotText ?? "Available"),
                          BookingExplanation(
                              color: widget.selectedSlotColor ?? Colors.black,
                              text: widget.selectedSlotText ?? "Selected"),
                          BookingExplanation(
                              color: widget.bookedSlotColor ??
                                  Colors.red.withOpacity(0.05),
                              text: widget.bookedSlotText ?? "Booked"),
                          if (widget.hideBreakTime != null &&
                              widget.hideBreakTime == false)
                            BookingExplanation(
                                color: widget.pauseSlotColor ??
                                    Colors.black.withOpacity(0.05),
                                text: widget.pauseSlotText ?? "Break"),
                        ],
                      ),
                  const SizedBox(height: 8),
                  StreamBuilder<dynamic>(
                    stream: widget.getBookingStream(
                        start: startOfDay, end: endOfDay),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return widget.errorWidget ??
                            Center(
                              child: Text(snapshot.error.toString()),
                            );
                      }

                      if (!snapshot.hasData) {
                        return widget.loadingWidget ??
                            const Center(child: CircularProgressIndicator());
                      }

                      ///this snapshot should be converted to List<DateTimeRange>
                      final data = snapshot.requireData;
                      controller.generateBookedSlots(
                          widget.convertStreamResultToDateTimeRanges(
                              streamResult: data));

                      return Expanded(
                        child: (widget.wholeDayIsBookedWidget != null &&
                                controller.isWholeDayBooked())
                            ? widget.wholeDayIsBookedWidget!
                            : GridView.builder(
                                physics: widget.gridScrollPhysics ??
                                    const BouncingScrollPhysics(),
                                itemCount: controller.allBookingSlots.length,
                                itemBuilder: (context, index) {
                                  TextStyle? getTextStyle() {
                                    if (controller.isSlotBooked(index)) {
                                      return widget.bookedSlotTextStyle;
                                    } else if (index ==
                                        controller.selectedSlot) {
                                      return widget.selectedSlotTextStyle;
                                    } else {
                                      return widget.availableSlotTextStyle;
                                    }
                                  }

                                  final slot = controller.allBookingSlots
                                      .elementAt(index);
                                  return BookingSlot(
                                    hideBreakSlot: widget.hideBreakTime,
                                    pauseSlotColor: widget.pauseSlotColor,
                                    availableSlotColor:
                                        widget.availableSlotColor,
                                    bookedSlotColor: widget.bookedSlotColor,
                                    selectedSlotColor: widget.selectedSlotColor,
                                    isPauseTime:
                                        controller.isSlotInPauseTime(slot),
                                    isBooked: controller.isSlotBooked(index),
                                    isSelected:
                                        index == controller.selectedSlot,
                                    onTap: () => controller.selectSlot(index),
                                    child: Center(
                                      child: Text(
                                        widget.formatDateTime?.call(slot) ??
                                            BookingUtil.formatDateTime(slot),
                                        style: getTextStyle(),
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      widget.bookingGridCrossAxisCount ?? 3,
                                  childAspectRatio:
                                      widget.bookingGridChildAspectRatio ?? 1.5,
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CommonButton(
                    text: widget.bookingButtonText ?? 'BOOK NOW',
                    onTap: () async {
                      controller.toggleUploading();
                      await widget.uploadBooking(
                          newBooking:
                              controller.generateNewBookingForUploading());
                      controller.toggleUploading();
                      controller.resetSelectedSlot();
                    },
                    isDisabled: controller.selectedSlot == -1,
                    buttonActiveColor:
                        widget.bookingButtonColor ?? Colors.black,
                  ),
                ],
              ),
      ),
    );
  }
}
