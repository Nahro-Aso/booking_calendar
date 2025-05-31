import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  const CommonCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.border,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final BoxShadow? boxShadow;
  final Color? color;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.zero,
        border: border ??
            Border.all(
              color: Colors.black.withOpacity(0.08),
              width: 0.25,
            ),
        // Remove shadows for clean minimalist design
      ),
      child: child,
    );
  }
}
