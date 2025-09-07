import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/simple_appbar.dart';
import '../controllers/profile_controller.dart';
import '../../../widgets/custom_input.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppbar(),
      body: Obx(() {
        final user = controller.userData.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image
              Obx(() {
                final isEditing = controller.isEditing.value;
                final imagePath = controller.userData.value?['profile_image'];

                return GestureDetector(
                  onTap: isEditing
                      ? () => controller.pickAndUploadProfileImage()
                      : null,
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          (imagePath != null && imagePath.isNotEmpty)
                          ? NetworkImage(imagePath)
                          : null,
                      child: (imagePath == null || imagePath.isEmpty)
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : isEditing
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white70,
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              }),

              // Obx(
              //   () => Center(
              //     child: ClipOval(
              //       child: Image(
              //         image:
              //             controller.profileImageProvider.value ??
              //             AssetImage('assets/images/ProfileImage.png'),
              //         width: 150,
              //         height: 150,
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),

              Obx(
                () => CustomInput(
                  label: 'Name',
                  initialValue: user?["name"] ?? "",
                  enabled: controller.isEditing.value,
                  onChanged: (val) => controller.nameController.text = val,
                ),
              ),
              const SizedBox(height: 10),

              Obx(
                () => CustomInput(
                  label: 'Email',
                  initialValue: user?["email"] ?? "",
                  enabled: controller.isEditing.value,
                  onChanged: (val) => controller.emailController.text = val,
                ),
              ),
              const SizedBox(height: 10),

              Obx(
                () => CustomInput(
                  label: 'Phone',
                  initialValue: user?["phone"] ?? "",
                  enabled: controller.isEditing.value,
                  onChanged: (val) => controller.phoneController.text = val,
                ),
              ),
              const SizedBox(height: 20),

              Obx(
                () => controller.isEditing.value
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.6,
                              height: 50,
                              child: CustomButton(
                                text: 'Update',
                                icon: Icons.update,
                                TextColor: AppColors.white,
                                BackgroundColor: AppColors.primary,
                                onPressed: () {
                                  controller.updateUserData({
                                    "name": controller.nameController.text,
                                    "email": controller.emailController.text,
                                    "phone": controller.phoneController.text,
                                  });
                                  controller.isEditing.value = false;
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.6,
                              height: 50,
                              child: CustomButton(
                                text: 'Cancel',
                                icon: Icons.cancel,
                                TextColor: AppColors.white,
                                BackgroundColor: AppColors.red,
                                onPressed: () {
                                  print('Cancel tapped!');
                                  controller.isEditing.value = false;

                                  // Optional: reset form fields to original data from userData
                                  final user = controller.userData.value;
                                  if (user != null) {
                                    controller.nameController.text =
                                        user["name"] ?? '';
                                    controller.emailController.text =
                                        user["email"] ?? '';
                                    controller.phoneController.text =
                                        user["phone"] ?? '';
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CustomButton(
                          text: 'Edit Details',
                          icon: Icons.edit,
                          TextColor: AppColors.white,
                          BackgroundColor: AppColors.primary,
                          onPressed: () => controller.isEditing.value = true,
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
