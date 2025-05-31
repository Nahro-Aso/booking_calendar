import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isActive = true,
    this.isDisabled = false,
    this.buttonStyle,
    this.width,
    this.buttonActiveColor,
    this.buttonInActiveColor,
  });

  final String text;
  final VoidCallback onTap;
  final bool? isActive;
  final bool? isDisabled;
  final TextStyle? buttonStyle;
  final Color? buttonActiveColor;
  final Color? buttonInActiveColor;
  final double? width;

  Color _getButtonColor() {
    if (isActive == true && isDisabled == false) {
      return buttonActiveColor ?? Colors.black;
    } else if (isActive == false && isDisabled == false) {
      return Colors.white;
    } else {
      return buttonInActiveColor ?? Colors.black.withOpacity(0.3);
    }
  }

  Color _getTextColor() {
    if (isActive == true && isDisabled == false) {
      return Colors.white;
    } else if (isActive == false && isDisabled == false) {
      return buttonActiveColor ?? Colors.black;
    } else {
      return Colors.white;
    }
  }

  Border? _getBorder() {
    if (isActive == false && isDisabled == false) {
      return Border.all(
        color: buttonActiveColor ?? Colors.black,
        width: 0.25,
      );
    }
    return Border.all(
      color: Colors.black.withOpacity(0.1),
      width: 0.25,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (isDisabled == null || isDisabled == false) ? onTap : null,
        child: Container(
          width: width ?? double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: _getButtonColor(),
            borderRadius: BorderRadius.zero,
            border: _getBorder(),
          ),
          child: Text(
            text.toUpperCase(),
            style: buttonStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getTextColor(),
                  letterSpacing: 0.5,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
