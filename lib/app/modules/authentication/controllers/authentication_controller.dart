import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationController extends GetxController {
  // final name = ''.obs;
  // final email = ''.obs;
  // final number = ''.obs;
  // final password = ''.obs;
  // final confirmPassword = ''.obs;
  // final isLoading = false.obs;
  //
  // final formKey = GlobalKey<FormState>();

  // Future<void> registerUser() async {
  //   if (!formKey.currentState!.validate()) return;
  //
  //   if (password.value != confirmPassword.value) {
  //     Get.snackbar("Error", "Passwords do not match");
  //     return;
  //   }
  //
  //   try {
  //     isLoading.value = true;
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email.value,
  //       password: password.value,
  //     );
  //
  //     Get.offAllNamed('/home');
  //   } on FirebaseAuthException catch (e) {
  //     Get.snackbar("Registration Failed", e.message ?? "Unknown error");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  // Form fields
  final name = ''.obs;
  final email = ''.obs;
  final number = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final otpCode = ''.obs;

  // UI state
  final isLoading = false.obs;
  final isVerifyingOtp = false.obs;

  final formKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  // Firebase
  String? verificationId;

  /// Register user with email and password, then send OTP to phone number
  Future<void> registerUser() async {
    if (!formKey.currentState!.validate()) return;

    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      // 1. Create user with email/password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // 2. Send OTP to phone
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number.value,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Optional: auto verification
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("OTP Failed", e.message ?? "Verification error");
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;

          // Navigate to OTP screen
          Get.toNamed('/otp_verification');
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Registration Failed", e.message ?? "Unknown error");
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP and link phone number with the current Firebase user
  Future<void> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) return;

    try {
      isVerifyingOtp.value = true;

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpCode.value,
      );

      // Link phone number to current signed-in user
      await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("OTP Verification Failed", e.toString());
    } finally {
      isVerifyingOtp.value = false;
    }
  }

}
