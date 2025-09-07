import 'package:flutter/material.dart';

class CustomButtonOne extends StatelessWidget {
  final String text;
  final VoidCallback?
  onPressed; // Made nullable to better handle disabled state
  final bool disabled;

  // Optional colors and padding for flexibility
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;

  const CustomButtonOne({
    super.key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
    this.backgroundColor = const Color(0xFF00CFC1),
    this.disabledBackgroundColor = const Color(0xFF9E9E9E),
    this.foregroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: disabled ? disabledBackgroundColor : backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // Optional: Add elevation or shadow if you want
        elevation: disabled ? 0 : 2,
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
