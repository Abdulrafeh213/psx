import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/common_app_bar.dart';
import '../controllers/admin_dashboard_controller.dart';
import 'widgets/admin_grid_item.dart';
import 'widgets/custom_nav_bar.dart';
import 'widgets/show_categories.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 2; // Mobile
    } else if (width < 1024) {
      return 3; // Tablet
    } else {
      return 5; // Desktop / Web
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Admin Panel'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = _getCrossAxisCount(context);

          return Obx(() {
            final stats = controller.dashboardStats;

            return GridView.count(
              crossAxisCount: crossAxisCount,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                AdminGridItem(
                  icon: Icons.people,
                  title: "Users",
                  value: stats["users"].toString(),
                  onTap: () => Get.toNamed("/adminUsersView"),
                ),
                AdminGridItem(
                  icon: Icons.shopping_bag,
                  title: "Ads",
                  value: stats["ads"].toString(),
                  onTap: () => Get.toNamed("/adminAds"),
                ),
                // AdminGridItem(
                //   icon: Icons.category,
                //   title: "Categories",
                //   value: stats["categories"].toString(),
                //   onTap: () => Get.to(() => AdminCategoriesView()),
                //
                //   // onTap: () => Get.toNamed("/adminCategoriesView"),
                // ),
                AdminGridItem(
                  icon: Icons.sell,
                  title: "Items Sold",
                  value: stats["itemsSold"].toString(),
                  onTap: () => Get.toNamed("/adminItemsSold"),
                ),
                AdminGridItem(
                  icon: Icons.inventory,
                  title: "All Items",
                  value: stats["allItems"].toString(),
                  onTap: () => Get.toNamed("/adminItems"),
                ),
                AdminGridItem(
                  icon: Icons.payment,
                  title: "Payments",
                  value: stats["payments"].toString(),
                  onTap: () => Get.toNamed("/adminPayments"),
                ),
                AdminGridItem(
                  icon: Icons.local_shipping,
                  title: "Deliveries Pending",
                  value: stats["pendingDeliveries"].toString(),
                  onTap: () => Get.toNamed("/adminDeliveriesPending"),
                ),
                AdminGridItem(
                  icon: Icons.check_circle,
                  title: "Deliveries Done",
                  value: stats["delivered"].toString(),
                  onTap: () => Get.toNamed("/adminDeliveriesDone"),
                ),
                AdminGridItem(
                  icon: Icons.chat,
                  title: "Chats",
                  value: stats["chats"].toString(),
                  onTap: () => Get.toNamed("/adminChat"),
                ),
              ],
            );
          });
        },
      ),
      bottomNavigationBar: const CustomAdminNavBar(currentIndex: 0),
    );
  }
}
