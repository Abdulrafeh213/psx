import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../../../widgets/show_message_widget.dart';
import '../../controllers/authentication_controller.dart';

class LoginOtpVerificationView extends GetView<AuthenticationController> {
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
              key: controller.otpFormKey,
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

                  Obx(
                        () => CustomButtonOne(
                      text: controller.isVerifying.value
                          ? "Verifying..."
                          : "Verify",
                      onPressed: controller.isVerifying.value
                          ? null
                          : () {
                        // Combine all OTP parts
                        String otp = controller.otpControllers
                            .map((controller) => controller.text)
                            .join();

                        // Pass the OTP to verifyOtp method
                        if (otp.isNotEmpty && otp.length == 6) {
                          controller.verifyOtp(otp);
                        } else {
                          showMessage("Error", "Invalid OTP");
                        }
                      },
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
