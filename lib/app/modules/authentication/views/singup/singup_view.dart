import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../widgets/custom_phone_number.dart';
import '../../controllers/authentication_controller.dart';

class SignupView extends GetView {
  SignupView({super.key});
  final AuthenticationController controller = Get.put(
    AuthenticationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Signup'),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Image.asset(
                    'assets/images/ProfileImage.png',
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Let’s Get You Signed In",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Discover the PSX experience",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // // Name input
                // CustomInput(
                //   label: 'Name',
                //   onChanged: (val) => controller.name.value = val,
                // ),

                // Email input
                CustomInput(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) => controller.email.value = val,
                  // custom validator on form submit in controller
                ),

                // // Country code + Number row
                // CustomPhoneInput(
                //   selectedCountryDialCode: controller.selectedCountryDialCode,
                //   selectedCountryCode: controller.selectedCountryCode,
                //   onCountryCodeChanged: (code) {
                //     controller.onCountryCodeChanged(code);
                //   },
                //   onNumberChanged: (number) {
                //     controller.number.value = number;
                //   },
                // ),
                SizedBox(height: 15),
                // Password input
                CustomInput(
                  label: 'Password',
                  obscureText: true,
                  onChanged: (val) => controller.password.value = val,
                ),

                // Confirm password input
                CustomInput(
                  label: 'Re-type Password',
                  obscureText: true,
                  onChanged: (val) => controller.confirmPassword.value = val,
                ),

                const SizedBox(height: 32),

                Obx(
                  () => CustomButtonOne(
                    text: controller.isLoading.value
                        ? "Please wait..."
                        : "Signup",
                    onPressed: controller.onSignupPressed,
                    disabled: controller.isLoading.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../widgets/common_app_bar.dart';
// import '../../../../widgets/custom_button_one.dart';
// import '../../../../widgets/custom_input.dart';
// import '../../../../widgets/custom_phone_number.dart';
// import '../../controllers/authentication_controller.dart';
//
// class SignupView extends GetView {
//   SignupView({super.key});
//   final AuthenticationController controller = Get.put(
//     AuthenticationController(),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CommonAppBar(title: 'Signup'),
//       body: SingleChildScrollView(
//         child: Form(
//           key: controller.formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//
//
//                 Center(
//                   child: Image.asset(
//                     'assets/images/ProfileImage.png',
//                     width: 200,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   "Let’s Get You Signed In",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Discover the PSX experience",
//                   style: TextStyle(color: Colors.grey),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 32),
//
//
//                 // Email input
//                 CustomInput(
//                   label: 'Email',
//                   keyboardType: TextInputType.emailAddress,
//                   onChanged: (val) => controller.email.value = val,
//                   // custom validator on form submit in controller
//                 ),
//
//
//
//                 SizedBox(height: 15),
//                 // Password input
//                 CustomInput(
//                   label: 'Password',
//                   obscureText: true,
//                   onChanged: (val) => controller.password.value = val,
//                 ),
//
//                 // Confirm password input
//                 CustomInput(
//                   label: 'Re-type Password',
//                   obscureText: true,
//                   onChanged: (val) => controller.confirmPassword.value = val,
//                 ),
//
//                 const SizedBox(height: 32),
//
//                 Obx(
//                       () => CustomButtonOne(
//
//                     text: controller.isLoading.value
//                         ? "Please wait..."
//                         : "Signup",
//                     onPressed: controller.onSignupPressed,
//                     disabled: controller.isLoading.value,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
