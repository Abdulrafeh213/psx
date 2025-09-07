import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/common_app_bar.dart';
import '../../controllers/admin_dashboard_controller.dart';
import 'custom_nav_bar.dart';

class ProfileSettingView extends GetView<AdminDashboardController> {
  const ProfileSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Profile Settings'),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Profile Image
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(
                  () => CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.imageUrl.value.isNotEmpty
                        ? NetworkImage(controller.imageUrl.value)
                        : const AssetImage("assets/images/default_avatar.png")
                              as ImageProvider,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Name
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // 🔹 Email
              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // 🔹 Phone
              TextField(
                controller: controller.phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Update Button
              ElevatedButton.icon(
                onPressed: controller.updateProfile,
                icon: const Icon(Icons.save),
                label: const Text("Update Profile"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const CustomAdminNavBar(currentIndex: 4),
    );
  }
}
