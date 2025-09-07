import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../../../widgets/custom_input.dart';
import '../../controllers/authentication_controller.dart';

class LoginEmailView extends GetView {
  LoginEmailView({super.key});
  final AuthenticationController controller = Get.put(
    AuthenticationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Login'),
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
              "Enter Your Email Here",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "PSX welcome you in our App",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Input field for email or phone
            CustomInput(label: 'Email', onChanged: controller.setEmailOrPhone),
            const SizedBox(height: 16),

            Obx(
              () => CustomInput(
                label: 'Password',
                obscureText: controller.isPasswordHidden.value,
                onChanged: (val) => controller.passwordController.text = val,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    controller.isPasswordHidden.value =
                        !controller.isPasswordHidden.value;
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            Obx(
              () => CustomButtonOne(
                text: controller.isLoading.value ? "Please wait..." : "Login",
                onPressed: controller.loginWithDynamicMethod,
                disabled: controller.isLoading.value,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/passwordForget');
                },
                child: const Text(
                  'click here to forget password',
                  style: TextStyle(color: AppColors.textColor, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
