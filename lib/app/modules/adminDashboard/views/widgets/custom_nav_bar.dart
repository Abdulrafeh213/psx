import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';

class CustomAdminNavBar extends StatelessWidget {
  final int currentIndex;
  const CustomAdminNavBar({super.key, required this.currentIndex});

  void onTabTapped(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/adminDashboard');
        break;
      case 1:
        Get.toNamed('/adminChat');
        break;
      case 2:
        Get.toNamed('/sell');
        break;
      case 3:
        Get.toNamed('/categoryForm');
        break;
      case 4:
        Get.toNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Shadow above navbar
        Positioned(
          top: -6,
          left: 0,
          right: 0,
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.15), Colors.transparent],
              ),
            ),
          ),
        ),

        // Custom bottom nav bar container
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.home,
                filledIcon: Icons.home_filled,
                label: 'HOME',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.chat_bubble_outline,
                filledIcon: Icons.chat_bubble,
                label: 'CHATS',
                index: 1,
              ),
              const SizedBox(width: 80),
              _buildNavItem(
                icon: Icons.category,
                filledIcon: Icons.favorite,
                label: 'CATEGORY',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                filledIcon: Icons.person,
                label: 'PROFILE',
                index: 4,
              ),
            ],
          ),
        ),

        // Floating Action Button (half overlap)
        Positioned(
          bottom: 5,
          child: GestureDetector(
            onTap: () => onTabTapped(2),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(
                        colors: [
                          AppColors.cyan,
                          AppColors.blue,
                          AppColors.yellow,
                          AppColors.cyan,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => onTabTapped(2),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: GestureDetector(
                          onTap: () => onTabTapped(2),
                          child: Icon(Icons.add, size: 30, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => onTabTapped(2),
                  child: const Text(
                    'SELL',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.barTextAndFill,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData filledIcon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTabTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? filledIcon : icon,
              size: 20,
              color: isSelected
                  ? AppColors.barTextAndFill
                  : AppColors.barTextAndFill.withOpacity(0.6),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppColors.barTextAndFill
                    : AppColors.barTextAndFill.withOpacity(0.6),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
