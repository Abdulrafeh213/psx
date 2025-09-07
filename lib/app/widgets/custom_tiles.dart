import 'package:flutter/material.dart';

import '../constants/appFonts.dart';
import '../constants/colors.dart';

class CustomTiles extends StatelessWidget {
  final IconData icon;
  final IconData tailIcon;
  final String title;
  final subtitle;
  final VoidCallback onTap;

  const CustomTiles({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    required this.tailIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.textColor),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading4),
                Text(subtitle, style: AppTextStyles.body),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: Icon(tailIcon, color: AppColors.textColor),
        ),
      ],
    );

    //   ListTile(
    //   leading: Icon(icon, color: Colors.black),
    //   title: Text(title, style: const TextStyle(fontSize: 14)),
    //   subtitle:Text(subtitle, style: const TextStyle(fontSize: 12)),
    //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    //   onTap: onTap,
    // );
  }
}
