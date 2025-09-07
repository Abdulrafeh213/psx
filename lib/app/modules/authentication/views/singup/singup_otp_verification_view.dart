import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../controllers/authentication_controller.dart';

class SignupOtpVerificationView extends GetView<AuthenticationController> {
  SignupOtpVerificationView({super.key});

  @override
  final AuthenticationController controller = Get.put(
    AuthenticationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'OTP Verification'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/PSX-Logo1.png',
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: controller.otpFormKey, // ✅ use OTP-specific key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    "Enter the 6-digit code sent to your phone",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),

                  // OTP Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: controller.otpControllers[index],
                          focusNode: controller.otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) =>
                              controller.onOtpChanged(val, index),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  // ✅ Verify Button
                  Obx(
                    () => CustomButtonOne(
                      text: controller.isVerifying.value
                          ? "Verifying..."
                          : "Verify",
                      onPressed: controller.isVerifying.value
                          ? null
                          : controller.onOtpVerifyPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
