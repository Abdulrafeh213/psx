import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/common_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../controllers/category_controller.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/custom_button_one.dart';
import '../../../constants/colors.dart';
import 'widgets/custom_nav_bar.dart';

class CategoryFormView extends GetView {
  const CategoryFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryFormController());

    return Scaffold(
      appBar: const CommonAppBar(title: 'Add Category'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Image Box
              Obx(() {
                final path = controller.pickedImagePath.value;

                return Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: path.isEmpty
                      ? Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 50,
                            child: CustomButton(
                              text: 'Upload Image',
                              icon: Icons.image,
                              TextColor: AppColors.white,
                              BackgroundColor: AppColors.primary,
                              onPressed: () =>
                                  controller.pickImageFile(context),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => controller.pickImageFile(context),
                          child: Image.file(
                            File(path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                );
              }),

              const SizedBox(height: 30),
              CustomInput(
                label: 'Category Name',
                onChanged: (val) => controller.categoryName.value = val,
              ),

              const SizedBox(height: 30),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: CustomButtonOne(
                    text: controller.isLoading.value
                        ? 'Please wait...'
                        : 'Submit',
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.submitForm(context),
                    disabled: controller.isLoading.value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomAdminNavBar(currentIndex: 1),
    );
  }
}
