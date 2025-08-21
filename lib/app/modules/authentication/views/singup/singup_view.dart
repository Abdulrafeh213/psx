import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paksecureexchange/app/constants/colors.dart';
import '../../../../constants/appFonts.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../../../widgets/custom_input.dart';
import '../../controllers/authentication_controller.dart';

class SingupView extends GetView {
   SingupView({super.key});
  final AuthenticationController controller = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up', style: AppTextStyles.appBar,),
        backgroundColor: const Color(0xFF00CFC1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Create an Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
        
                CustomInput(
                  label: 'Name',
                  onChanged: (val) => controller.name.value = val,
                ),
                CustomInput(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) => controller.email.value = val,
                ),
                CustomInput(
                  label: 'Number',
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => controller.number.value = val,
                ),
                CustomInput(
                  label: 'Password',
                  obscureText: true,
                  onChanged: (val) => controller.password.value = val,
                ),
                CustomInput(
                  label: 'Re-type Password',
                  obscureText: true,
                  onChanged: (val) => controller.confirmPassword.value = val,
                ),
                const SizedBox(height: 32),
        
                Obx(() => CustomButtonOne(
                  text: controller.isLoading.value ? "Please wait..." : "Singup",
                  onPressed: controller.registerUser,
                  disabled: controller.isLoading.value,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
