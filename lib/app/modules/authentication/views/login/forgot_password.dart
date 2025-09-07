import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../../../widgets/custom_input.dart';
import '../../controllers/authentication_controller.dart';

class PasswordForget extends GetView {
  PasswordForget({super.key});
  final AuthenticationController controller = Get.put(
    AuthenticationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Password Forget'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/images/ProfileImage.png',
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "You can forget your password through email",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Input field for email or phone
            CustomInput(label: 'Email', onChanged: controller.setEmailOrPhone),

            const SizedBox(height: 32),

            Obx(
              () => CustomButtonOne(
                text: controller.isLoading.value
                    ? "Please wait..."
                    : "Forget Password",
                onPressed: controller.sendPasswordResetEmail,
                disabled: controller.isLoading.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
