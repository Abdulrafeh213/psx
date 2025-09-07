import 'package:flutter/material.dart';
import '../../../../app/constants/colors.dart';

class SimpleAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/images/PSX-Logo.png',
        width: 70,
        height: 70,
        fit: BoxFit.contain,
      ),
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
