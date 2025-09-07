import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../widgets/icon_button.dart';
import '../../../chats/views/chat_detail_view.dart';
import '../../controllers/admin_dashboard_controller.dart';

// class UserDetailView extends StatelessWidget {
//   final String userId;
//
//   UserDetailView({super.key, required this.userId});
//
//   final AdminDashboardController controller = Get.put(
//     AdminDashboardController(),
//   );
//

//   @override
//   Widget build(BuildContext context) {
//     controller.loadUser(userId);
//
//     return Scaffold(
//       appBar: const CommonAppBar(title: "User Details"),
//       body: Obx(() {
//         final user = controller.userData.value;
//         if (user == null) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey[200],
//                   child: ClipOval(
//                     child: Image.network(
//                       user["profile_image"] ?? "",
//                       fit: BoxFit.cover,
//                       width: 120,
//                       height: 120,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Image.asset(
//                           'assets/images/ProfileImage.png',
//                           fit: BoxFit.cover,
//                           width: 120,
//                           height: 120,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               CustomInput(
//                 label: "Name",
//                 initialValue: user["name"] ?? "",
//                 enabled: controller.isEditing.value,
//                 onChanged: (val) => controller.nameController.text = val,
//               ),
//               const SizedBox(height: 10),
//
//               CustomInput(
//                 label: "Email",
//                 initialValue: user["email"] ?? "",
//                 enabled: controller.isEditing.value,
//                 onChanged: (val) => controller.emailController.text = val,
//               ),
//               const SizedBox(height: 10),
//
//               CustomInput(
//                 label: "Phone",
//                 initialValue: user["phone"] ?? "",
//                 enabled: controller.isEditing.value,
//                 onChanged: (val) => controller.phoneController.text = val,
//               ),
//
//               const SizedBox(height: 30),
//
//               // Action Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ActionIconButton(
//                     icon: Icons.delete,
//                     label: "Delete",
//                     color: Colors.red,
//                     onPressed: () => controller.deleteUser(userId),
//                   ),
//
//                   // ActionIconButton(
//                   //   icon: Icons.chat,
//                   //   label: "Chat",
//                   //   color: Colors.blue,
//                   //   onPressed: () async {
//                   //     final TextEditingController textController = TextEditingController();
//                   //
//                   //     final message = await Get.dialog<String>(
//                   //       AlertDialog(
//                   //         title: const Text("Send Message"),
//                   //         content: TextField(
//                   //           controller: textController,
//                   //           autofocus: true,
//                   //           decoration: const InputDecoration(hintText: "Enter your message"),
//                   //         ),
//                   //         actions: [
//                   //           TextButton(
//                   //             onPressed: () => Get.back(result: null),
//                   //             child: const Text("Cancel"),
//                   //           ),
//                   //           ElevatedButton(
//                   //             onPressed: () => Get.back(result: textController.text.trim()),
//                   //             child: const Text("Send"),
//                   //           ),
//                   //         ],
//                   //       ),
//                   //       barrierDismissible: false,
//                   //     );
//                   //
//                   //     if (message != null && message.isNotEmpty) {
//                   //       controller.startChatWithMessage(
//                   //         userId,
//                   //         user["name"] ?? "User",
//                   //         user["email"] ?? "",
//                   //         message,
//                   //       );
//                   //     }
//                   //   },
//                   // ),
//                   // ActionIconButton(
//                   //   icon: Icons.chat,
//                   //   label: "Chat",
//                   //   color: Colors.blue,
//                   //   onPressed: () {
//                   //     Get.to(() => ChatDetailView(
//                   //       userId: userId,
//                   //       userName: user["name"] ?? "",
//                   //       userEmail: user["email"] ?? "",
//                   //     ));
//                   //   },
//                   // ),
//                   ActionIconButton(
//                     icon: Icons.edit,
//                     label: "Edit",
//                     color: Colors.green,
//                     onPressed: () => controller.isEditing.value = true,
//                   ),
//                   ActionIconButton(
//                     icon: Icons.toggle_on,
//                     label: "Status",
//                     color: Colors.orange,
//                     onPressed: () => controller.toggleUserStatus(userId),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               Obx(
//                 () => controller.isEditing.value
//                     ? Row(
//                         children: [
//                           Expanded(
//                             child: CustomButton(
//                               text: "Update",
//                               icon: Icons.update,
//                               TextColor: AppColors.white,
//                               BackgroundColor: AppColors.primary,
//                               onPressed: () {
//                                 controller.updateUserData({
//                                   "name": controller.nameController.text,
//                                   "email": controller.emailController.text,
//                                   "phone": controller.phoneController.text,
//                                 });
//                                 controller.isEditing.value = false;
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: CustomButton(
//                               text: "Cancel",
//                               icon: Icons.cancel,
//                               TextColor: AppColors.white,
//                               BackgroundColor: AppColors.red,
//                               onPressed: () {
//                                 controller.isEditing.value = false;
//                                 controller.loadUser(userId);
//                               },
//                             ),
//                           ),
//                         ],
//                       )
//                     : const SizedBox.shrink(),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../widgets/icon_button.dart';
import '../../controllers/admin_dashboard_controller.dart';

class UserDetailView extends StatelessWidget {
  final String userId;

  UserDetailView({super.key, required this.userId});

  final AdminDashboardController controller = Get.put(
    AdminDashboardController(),
  );

  @override
  Widget build(BuildContext context) {
    controller.loadUser(userId);

    return Scaffold(
      appBar: const CommonAppBar(title: "User Details"),
      body: Obx(() {
        final user = controller.userData.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile Image
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: Image.network(
                      user["profile_image"] ?? "",
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/ProfileImage.png',
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Name
              CustomInput(
                label: "Name",
                initialValue: user["name"] ?? "",
                enabled: controller.isEditing.value,
                onChanged: (val) => controller.nameController.text = val,
              ),
              const SizedBox(height: 10),

              /// Email
              CustomInput(
                label: "Email",
                initialValue: user["email"] ?? "",
                enabled: controller.isEditing.value,
                onChanged: (val) => controller.emailController.text = val,
              ),
              const SizedBox(height: 10),

              /// Phone
              CustomInput(
                label: "Phone",
                initialValue: user["phone"] ?? "",
                enabled: controller.isEditing.value,
                onChanged: (val) => controller.phoneController.text = val,
              ),
              const SizedBox(height: 10),

              /// Location
              CustomInput(
                label: "Location",
                initialValue: user["location"] ?? "",
                enabled: controller.isEditing.value,
                onChanged: (val) => controller.locationController.text = val,
              ),
              const SizedBox(height: 10),

              /// Role
              CustomInput(
                label: "Role",
                initialValue: user["user_role"] ?? "",
                enabled: controller.isEditing.value,
                // onChanged: (val) => controller.locationController.text = val,
              ),
              const SizedBox(height: 10),


              /// Status
               CustomInput(
                              label: "Status",
                              initialValue: user["user_status"] ?? "",
                              enabled: controller.isEditing.value,
                              // onChanged: (val) => controller.locationController.text = val,
                            ),
                            const SizedBox(height: 10),


              /// Created At
              CustomInput(
                label: "Created At",
                initialValue: user["created_at"] ?? "",
                enabled: controller.isEditing.value,
                // onChanged: (val) => controller.locationController.text = val,
              ),

              const SizedBox(height: 30),

              /// Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionIconButton(
                    icon: Icons.delete,
                    label: "Delete",
                    color: Colors.red,
                    onPressed: () => controller.deleteUser(userId),
                  ),
                  ActionIconButton(
                    icon: Icons.edit,
                    label: "Edit",
                    color: Colors.green,
                    onPressed: () => controller.isEditing.value = true,
                  ),
                  ActionIconButton(
                    icon: Icons.toggle_on,
                    label: "Status",
                    color: Colors.orange,
                    onPressed: () => controller.toggleUserStatus(userId),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Update / Cancel Buttons
              Obx(
                    () => controller.isEditing.value
                    ? Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Update",
                        icon: Icons.update,
                        TextColor: AppColors.white,
                        BackgroundColor: AppColors.primary,
                        onPressed: () {
                          controller.updateUserData(userId, {
                            "name": controller.nameController.text,
                            "email": controller.emailController.text,
                            "phone": controller.phoneController.text,
                            "location": controller.locationController.text,
                          });
                          controller.isEditing.value = false;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: "Cancel",
                        icon: Icons.cancel,
                        TextColor: AppColors.white,
                        BackgroundColor: AppColors.red,
                        onPressed: () {
                          controller.isEditing.value = false;
                          controller.loadUser(userId);
                        },
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
