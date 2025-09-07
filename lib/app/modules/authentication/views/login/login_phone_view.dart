import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../widgets/custom_phone_number.dart';
import '../../controllers/authentication_controller.dart';

class LoginPhoneView extends GetView<AuthenticationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Login'),
      body: SingleChildScrollView(
        child: Padding(
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
                "Enter your phone number",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "We’ll send you a verification code on the same number",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Phone input with country code picker
              CustomPhoneInput(
                selectedCountryDialCode: controller.selectedCountryDialCode,
                selectedCountryCode: controller.selectedCountryCode,
                onCountryCodeChanged: controller.onCountryCodeChanged,
                onNumberChanged: (val) => controller.number.value = val,
              ),
              const SizedBox(height: 16),

              Obx(
                    () => CustomButtonOne(
                  text: controller.isLoading.value ? "Please wait..." : "Login",
                  onPressed: controller.sendOtp,
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

