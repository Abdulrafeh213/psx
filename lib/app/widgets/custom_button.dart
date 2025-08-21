import 'package:flutter/material.dart';
import 'package:paksecureexchange/app/constants/appFonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? image;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, size: 25)
          else if (image != null)
            Image.asset(image!, width: 25, height: 25),
          const SizedBox(width: 10),
          Text(
            text,
            style: AppTextStyles.button,
          ),
        ],
      ),
    );
  }
}
