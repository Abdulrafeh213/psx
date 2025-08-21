import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/appFonts.dart';
import '../../../widgets/custom_button_one.dart';
import '../../../widgets/custom_input.dart';

class OtpVerificationView extends GetView {
  const OtpVerificationView({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification', style: AppTextStyles.appBar),
        backgroundColor: const Color(0xFF00CFC1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Text(
                "Enter OTP sent to your phone",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              CustomInput(
                label: 'OTP Code',
                keyboardType: TextInputType.number,
                onChanged: (val) => controller.otpCode.value = val,
              ),
              const SizedBox(height: 32),
              Obx(() => CustomButtonOne(
                text: controller.isVerifying.value ? "Verifying..." : "Verify",
                onPressed: controller.verifyOtp,
                disabled: controller.isVerifying.value,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
