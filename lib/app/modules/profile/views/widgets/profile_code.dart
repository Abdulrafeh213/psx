import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/appFonts.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_tiles.dart';

class ProfileCode extends GetView {
  const ProfileCode({super.key});
  @override
  Widget build(BuildContext context) {
    final user = controller.userData.value;
    final imageProvider = controller.profileImageProvider.value;
    return Obx(() {
      return Column(
        children: [
          const SizedBox(height: 20),
          ClipOval(
            child: Image(
              image:
                  imageProvider ??
                  const AssetImage('assets/images/ProfileImage.png'),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(user["name"] ?? "User", style: AppTextStyles.heading3),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
              text: 'View & Edit Profile',
              icon: Icons.person_outline,
              TextColor: AppColors.white,
              BackgroundColor: AppColors.primary,
              onPressed: () => Get.toNamed('/editProfile'),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
              left: 20.0,
              bottom: 10.0,
              top: 10.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTiles(
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Shop',
                  subtitle: 'packages, orders, billing and invoices',
                  tailIcon: Icons.arrow_forward_ios,
                  onTap: () => Get.toNamed('/myShop'),
                ),
                const SizedBox(height: 20),
                CustomTiles(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'privacy and manage account',
                  tailIcon: Icons.arrow_forward_ios,
                  onTap: () => Get.toNamed('/userSettings'),
                ),
                const SizedBox(height: 20),
                CustomTiles(
                  icon: Icons.help_outline,
                  title: 'Help & support',
                  subtitle: 'Help centre and legal terms',
                  tailIcon: Icons.arrow_forward_ios,
                  onTap: () => Get.toNamed('/helpAndSupport'),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomButton(
                    text: 'Log Out',
                    icon: Icons.logout,
                    TextColor: AppColors.white,
                    BackgroundColor: AppColors.primary,
                    onPressed: controller.logout,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      );
    });
  }
}
