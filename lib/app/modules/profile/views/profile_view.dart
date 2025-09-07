// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../constants/appFonts.dart';
// import '../../../constants/colors.dart';
// import '../../../widgets/custom_button.dart';
// import '../../../widgets/custom_nav_bar.dart';
// import '../../../widgets/custom_tiles.dart';
// import '../../../widgets/simple_appbar.dart';
// import '../controllers/profile_controller.dart';
//
// class ProfileView extends GetView<ProfileController> {
//   const ProfileView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const SimpleAppbar(),
//       body: Obx(() {
//         final user = controller.userData.value;
//         final imageProvider = controller.profileImageProvider.value;
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               ClipOval(
//                 child: Image(
//                   image:
//                       imageProvider ??
//                       const AssetImage('assets/images/ProfileImage.png'),
//                   width: 120,
//                   height: 120,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(user?["name"] ?? "User", style: AppTextStyles.heading3),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: CustomButton(
//                   text: 'View & Edit Profile',
//                   icon: Icons.person_outline,
//                   TextColor: AppColors.white,
//                   BackgroundColor: AppColors.primary,
//                   onPressed: () => Get.toNamed('/editProfile'),
//                 ),
//               ),
//               const Divider(),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   right: 20.0,
//                   left: 20.0,
//                   bottom: 10.0,
//                   top: 10.0,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomTiles(
//                       icon: Icons.admin_panel_settings,
//                       title: 'Admin Panel',
//                       subtitle: 'an Admin Panel',
//                       tailIcon: Icons.arrow_forward_ios,
//                       onTap: () => Get.toNamed('/adminDashboard'),
//                     ),
//                     const SizedBox(height: 5),
//                     const Divider(),
//                     CustomTiles(
//                       icon: Icons.shopping_bag_outlined,
//                       title: 'My Shop',
//                       subtitle: 'packages, orders, billing and invoices',
//                       tailIcon: Icons.arrow_forward_ios,
//                       onTap: () => Get.toNamed('/myShop'),
//                     ),
//                     const SizedBox(height: 5),
//                     const Divider(),
//                     const SizedBox(height: 5),
//                     CustomTiles(
//                       icon: Icons.settings,
//                       title: 'Settings',
//                       subtitle: 'privacy and manage account',
//                       tailIcon: Icons.arrow_forward_ios,
//                       onTap: () => Get.toNamed('/userSettings'),
//                     ),
//                     const SizedBox(height: 5),
//                     const Divider(),
//                     const SizedBox(height: 5),
//                     CustomTiles(
//                       icon: Icons.help_outline,
//                       title: 'Help & support',
//                       subtitle: 'Help centre and legal terms',
//                       tailIcon: Icons.arrow_forward_ios,
//                       onTap: () => Get.toNamed('/helpAndSupport'),
//                     ),
//                     const SizedBox(height: 5),
//                     const Divider(),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: CustomButton(
//                         text: 'Log Out',
//                         icon: Icons.logout,
//                         TextColor: AppColors.white,
//                         BackgroundColor: AppColors.primary,
//                         onPressed: controller.logout,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//       bottomNavigationBar: const CustomNavBar(currentIndex: 4),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/appFonts.dart';
import '../../../constants/colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_nav_bar.dart';
import '../../../widgets/custom_tiles.dart';
import '../../../widgets/simple_appbar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppbar(),
      body: Obx(() {
        final user = controller.userData.value;
        final imageProvider = controller.profileImageProvider.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Obx(() {
                final imagePath = controller.userData.value?['profile_image'];
                if (imagePath == null || imagePath.isEmpty) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }

                return Image(
                  image: NetworkImage(imagePath),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                );
              }),

              const SizedBox(height: 10),

              /// User Name
              Text(user?["name"] ?? "User", style: AppTextStyles.heading3),

              const SizedBox(height: 10),

              /// View & Edit Profile Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomButton(
                  text: 'View & Edit Profile',
                  icon: Icons.person_outline,
                  TextColor: AppColors.white,
                  BackgroundColor: AppColors.primary,
                  onPressed: () => Get.toNamed('/editProfile'),
                ),
              ),

              const Divider(),

              /// Other Options
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTiles(
                      icon: Icons.admin_panel_settings,
                      title: 'Admin Panel',
                      subtitle: 'Admin Panel',
                      tailIcon: Icons.arrow_forward_ios,
                      onTap: () => Get.toNamed('/adminDashboard'),
                    ),
                    const Divider(),
                    CustomTiles(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Shop',
                      subtitle: 'Packages, orders, billing and invoices',
                      tailIcon: Icons.arrow_forward_ios,
                      onTap: () => Get.toNamed('/myShop'),
                    ),
                    const Divider(),
                    CustomTiles(
                      icon: Icons.settings,
                      title: 'Settings',
                      subtitle: 'Privacy and manage account',
                      tailIcon: Icons.arrow_forward_ios,
                      onTap: () => Get.toNamed('/userSettings'),
                    ),
                    const Divider(),
                    CustomTiles(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Help centre and legal terms',
                      tailIcon: Icons.arrow_forward_ios,
                      onTap: () => Get.toNamed('/helpAndSupport'),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),

                    /// Logout Button
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
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const CustomNavBar(currentIndex: 4),
    );
  }
}
