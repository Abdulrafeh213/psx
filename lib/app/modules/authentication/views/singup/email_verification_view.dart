import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/appFonts.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../controllers/authentication_controller.dart';

class EmailVerificationView extends GetView {
  EmailVerificationView({super.key});

  final AuthenticationController controller = Get.find();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Verify Email'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch horizontally
            children: [
              Center(
                child: Image.asset(
                  'assets/images/PSX-Logo1.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  "A verification link has been sent\nCheck your inbox and spam folder\n to complete registration",
                  style: AppTextStyles.heading4,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              Obx(
                () => CustomButtonOne(
                  text: controller.isLoading.value
                      ? "Please wait..."
                      : "Check Verification",
                  onPressed: controller.checkEmailVerifiedAndProceed,
                  disabled: controller.isLoading.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
