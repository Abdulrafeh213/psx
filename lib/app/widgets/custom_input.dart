import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool enabled;
  final String? initialValue;

  const CustomInput({
    super.key,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
    this.enabled = true,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: keyboardType,
        enabled: enabled,
        obscureText: obscureText,
        onChanged: onChanged,
        initialValue: initialValue,

        validator: (val) {
          if (val == null || val.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
      ),
    );
  }
}
