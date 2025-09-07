import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../widgets/custom_button.dart';
import '../controllers/authentication_controller.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(flex: 3),
          Center(
            child: Image.asset(
              'assets/images/PSX-Logo1.png',
              width: 200,
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(flex: 1),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
              decoration: const BoxDecoration(
                color: Color(0xFF00CFC1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButton(
                    text: 'Continue with Phone',
                    TextColor: AppColors.textColor,
                    BackgroundColor: AppColors.white,
                    icon: Icons.phone_android,
                    onPressed: () {
                      Get.toNamed('/loginPhone');
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Continue with Email',
                    TextColor: AppColors.textColor,
                    BackgroundColor: AppColors.white,
                    icon: Icons.email,
                    onPressed: () {
                      Get.toNamed('/loginEmail');
                    },
                  ),

                  const SizedBox(height: 50),

                  Center(
                    child: Text(
                      "OR",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/singupEmail');
                        // Get.toNamed('/otpVerification');
                      },
                      child: Text(
                        "Create a New Account",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "If you continue, you are accepting\n",
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: "PSX Terms and Conditions and Privacy Policy",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
