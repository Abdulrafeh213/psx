import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/appFonts.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../widgets/custom_phone_number.dart';
import '../../controllers/authentication_controller.dart';

class PersonalDetailsView extends GetView {
  PersonalDetailsView({super.key});

  final AuthenticationController controller = Get.put(
    AuthenticationController(),
  );
  Rx<File?> profileImageFile = Rx<File?>(null);

  Future<void> pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      profileImageFile.value = File(result.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch email from Supabase user
    controller.email.value = controller.supabase.auth.currentUser?.email ?? '';

    return Scaffold(
      appBar: const CommonAppBar(title: 'Personal Information'),
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
                  child: Text(
                    'Almost there! \nFill in your personal details to complete your profile and get started with the app.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Profile image picker
                Obx(
                  () => Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: profileImageFile.value != null
                              ? FileImage(profileImageFile.value!)
                              : const AssetImage(
                                      'assets/images/ProfileImage.png',
                                    )
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: pickProfileImage,
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.upload_file,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Name input
                CustomInput(
                  label: 'Name',
                  onChanged: (val) => controller.name.value = val,
                ),

                const SizedBox(height: 16),

                // Email (read-only)
                CustomInput(
                  label: 'Email',
                  initialValue: controller.email.value,
                  enabled: false,
                ),

                const SizedBox(height: 16),

                // Phone number input
                CustomPhoneInput(
                  selectedCountryDialCode: controller.selectedCountryDialCode,
                  selectedCountryCode: controller.selectedCountryCode,
                  onCountryCodeChanged: (code) {
                    controller.onCountryCodeChanged(code);
                  },
                  onNumberChanged: (number) {
                    controller.number.value = number;
                  },
                ),

                const SizedBox(height: 32),

                Obx(
                  () => CustomButtonOne(
                    text: controller.isLoading.value
                        ? "Please wait..."
                        : "Submit Personal Details",
                    onPressed: controller.submitPersonalDetails,
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
