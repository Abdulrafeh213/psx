import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/common_app_bar.dart';
import '../controllers/admin_dashboard_controller.dart';
import 'widgets/users_detail_view.dart';

class UsersView extends GetView<AdminDashboardController> {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'All Users'),
      body: Obx(() {
      if (controller.usersList.isEmpty) {
        return const Center(child: Text("No users found"));
      }
      return ListView.builder(
        itemCount: controller.usersList.length,
        itemBuilder: (context, index) {
          final user = controller.usersList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user['profile_image'] != null && user['profile_image'] != ''
                  ? NetworkImage(user['profile_image'])
                  : const AssetImage('assets/images/ProfileImage.png') as ImageProvider,
            ),
            title: Text(user['name'] ?? 'No Name'),
            subtitle: Text(user['email'] ?? ''),
            trailing: Text(user['user_status'] ?? 'active'),
            onTap: () {
              Get.to(() => UserDetailView(userId: user['user_id']));
            },
          );
        },
      );
    }),

    );
  }
}
