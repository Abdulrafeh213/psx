import 'package:flutter/material.dart';
import 'package:paksecureexchange/app/constants/appFonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? image;
  final VoidCallback onPressed;
  final BackgroundColor;
  final TextColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.image,
    required this.BackgroundColor,
    required this.TextColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: TextColor,
        backgroundColor: BackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, size: 20, color: TextColor)
          else if (image != null)
            Image.asset(image!, width: 20, height: 20),
          const SizedBox(width: 10),
          Text(text, style: AppTextStyles.button.copyWith(color: TextColor)),
        ],
      ),
    );
  }
}
