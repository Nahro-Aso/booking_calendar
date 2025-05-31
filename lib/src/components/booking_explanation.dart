import 'package:flutter/material.dart';

class BookingExplanation extends StatelessWidget {
  const BookingExplanation({
    super.key,
    required this.color,
    required this.text,
    this.explanationIconSize,
  });

  final Color color;
  final String text;
  final double? explanationIconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.02),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
          width: 0.25,
        ),
        borderRadius: BorderRadius.zero,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: explanationIconSize ?? 12,
            width: explanationIconSize ?? 12,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 0.25,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
