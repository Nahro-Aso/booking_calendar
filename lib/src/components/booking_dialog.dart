import 'package:flutter/material.dart';

class BookingDialog extends StatelessWidget {
  const BookingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              border: Border.all(
                color: Colors.black.withOpacity(0.08),
                width: 0.25,
              ),
              borderRadius: BorderRadius.zero,
            ),
            child: const CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'PROCESSING BOOKING...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please wait while we confirm your booking',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
