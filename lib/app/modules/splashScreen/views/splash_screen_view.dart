import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:paksecureexchange/app/constants/colors.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  SplashScreenView({super.key});
  @override
  final SplashScreenController controller = Get.put(SplashScreenController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image.asset(
          'assets/images/PSX-Logo.png',
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
