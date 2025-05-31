import 'package:booking_calendar/src/components/common_card.dart';
import 'package:flutter/material.dart';

class BookingSlot extends StatelessWidget {
  const BookingSlot({
    super.key,
    required this.child,
    required this.isBooked,
    required this.onTap,
    required this.isSelected,
    required this.isPauseTime,
    this.bookedSlotColor,
    this.selectedSlotColor,
    this.availableSlotColor,
    this.pauseSlotColor,
    this.hideBreakSlot,
  });

  final Widget child;
  final bool isBooked;
  final bool isPauseTime;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? bookedSlotColor;
  final Color? selectedSlotColor;
  final Color? availableSlotColor;
  final Color? pauseSlotColor;
  final bool? hideBreakSlot;

  Color getSlotColor() {
    if (isPauseTime) {
      return pauseSlotColor ?? Colors.black.withOpacity(0.05);
    }

    if (isBooked) {
      return bookedSlotColor ?? Colors.red.withOpacity(0.05);
    } else {
      return isSelected
          ? selectedSlotColor ?? Colors.black
          : availableSlotColor ?? Colors.green.withOpacity(0.05);
    }
  }

  Border getSlotBorder() {
    if (isPauseTime) {
      return Border.all(
        color: Colors.black.withOpacity(0.1),
        width: 0.25,
      );
    }

    if (isBooked) {
      return Border.all(
        color: Colors.red.withOpacity(0.3),
        width: 0.25,
      );
    } else {
      return isSelected
          ? Border.all(color: Colors.black, width: 0.25)
          : Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 0.25,
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return (hideBreakSlot != null && hideBreakSlot == true && isPauseTime)
        ? const SizedBox()
        : Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (!isBooked && !isPauseTime) ? onTap : null,
              child: Container(
                margin: const EdgeInsets.all(4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: getSlotColor(),
                  borderRadius: BorderRadius.zero,
                  border: getSlotBorder(),
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                    letterSpacing: 0.3,
                  ),
                  child: child,
                ),
              ),
            ),
          );
  }
}
