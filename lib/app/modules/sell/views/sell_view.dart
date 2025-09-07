import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_button_one.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/custom_nav_bar.dart';
import '../controllers/sell_controller.dart';

class SellView extends GetView<SellController> {
  final SellController sellController = Get.put(SellController());
   SellView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Post Ad'),
      body: SingleChildScrollView(
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
                              onPressed:()=> controller.pickImage(context),
                            ),
                          ),
                        )
                      : GestureDetector(
                    onTap: () => controller.pickImage(context),
                          child: Image.file(
                            File(path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                          ),
                        ),
                );
              }),

              const SizedBox(height: 10),

              CustomInput(
                label: 'Write a catchy title for your ad',
                onChanged: (val) => controller.name.value = val,
              ),
              const SizedBox(height: 8),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: controller.categoryId.value.isEmpty ? null : controller.categoryId.value,
                  items: controller.categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat["id"],
                      child: Text(cat["category_name"]),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.categoryId.value = val;
                  },
                  decoration: const InputDecoration(
                    labelText: "Choose a category",
                    border: OutlineInputBorder(),
                  ),
                );
              }),


              const SizedBox(height: 8),
              CustomInput(
                label: 'Description',
                onChanged: (val) => controller.description.value = val,
              ),
              // const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                items: ["New", "Used"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => controller.condition.value = val ?? '',
                decoration: const InputDecoration(
                  labelText: "Item",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<int>(
                  value: controller.sellerRating.value,
                  items: List.generate(10, (index) => index + 1)
                      .map(
                        (number) => DropdownMenuItem(
                          value: number,
                          child: Text(number.toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) controller.sellerRating.value = val;
                  },
                  decoration: const InputDecoration(
                    labelText: "Rate (1-10)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              CustomInput(
                label: 'Warranty (optional)',
                onChanged: (val) => controller.warranty.value = val,
              ),

              const SizedBox(height: 8),
              CustomInput(
                label: 'Set your price',
                onChanged: (val) =>
                    controller.price.value = double.tryParse(val) ?? 0.0,
              ),
              const SizedBox(height: 8),

              // Obx(
              //       () => CustomButtonOne(
              //     text: controller.isLoading.value ? "Please wait..." : "Login",
              //     onPressed: controller.loginWithDynamicMethod,
              //     disabled: controller.isLoading.value,
              //   ),
              // ),
              const SizedBox(height: 8),
              TextFormField(
                  controller: controller.locationController,
                  decoration: InputDecoration(
                    labelText: 'Enter Location',
                    hintText: 'e.g. Street 5, Azam Basti, Karachi, Pakistan',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.gps_fixed, color: Colors.blue),
                      onPressed: controller.fetchLiveLocation,
                      tooltip: 'Fetch live location',
                    ),
                  ),
                  onChanged: (val) {
                    if (val.trim().isNotEmpty) {
                      controller.setManualLocation(val.trim());
                    }
                  },
                ),



              // Row(
              //   children: [
              //     // Live Location Button
              //     Expanded(
              //       child: CustomButton(
              //         text: 'Live Location',
              //         icon: Icons.gps_fixed,
              //         TextColor: AppColors.white,
              //         BackgroundColor: AppColors.primary,
              //         onPressed: controller.fetchLiveLocation,
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     // Manual Location Button
              //     Expanded(
              //       child: CustomButton(
              //         text: 'Manual Location',
              //         icon: Icons.gps_fixed,
              //         TextColor: AppColors.white,
              //         BackgroundColor: AppColors.secondary,
              //         onPressed: () {
              //           Get.dialog(
              //             AlertDialog(
              //               title: const Text('Enter Manual Location'),
              //               content: TextField(
              //                 decoration: const InputDecoration(
              //                   hintText: 'e.g. Lahore, Pakistan',
              //                 ),
              //                 onSubmitted: (val) {
              //                   if (val.trim().isNotEmpty) {
              //                     controller.setManualLocation(val.trim());
              //                   }
              //                 },
              //               ),
              //             ),
              //           );
              //         },
              //       ),
              //     ),
              //   ],
              // ),

              const SizedBox(height: 8),



              // CustomButton(
              //   text: 'Set Location',
              //   icon: Icons.location_on,
              //   TextColor: AppColors.white,
              //   BackgroundColor: AppColors.primary,
              //
              //   onPressed: () {
              //
              //     controller.location.value = {"name": "Karachi, Pakistan", "lat": 24.8607, "lng": 67.0011};
              //   },
              // ),

              // ElevatedButton(
              //   onPressed: () {
              //
              //     controller.location.value = {"name": "Karachi, Pakistan", "lat": 24.8607, "lng": 67.0011};
              //   },
              //   child: const Text("Set Location"),
              // ),
              const SizedBox(height: 10),

              // Preview & Cancel
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    height: 50,
                    child: CustomButton(
                      text: 'Preview Ad',
                      icon: Icons.remove_red_eye,
                      TextColor: AppColors.white,
                      BackgroundColor: AppColors.primary,

                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text("Preview Ad"),
                            content: Obx(() {
                              final imagePath =
                                  controller.pickedImagePath.value;
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imagePath.isNotEmpty)
                                      Image.file(
                                        File(imagePath),
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    const SizedBox(height: 8),
                                    Text("Title: ${controller.name.value}"),
                                    Text(
                                      "Description: ${controller.description.value}",
                                    ),
                                    Text(
                                      "Condition: ${controller.condition.value}",
                                    ),
                                    Text(
                                      "Warranty: ${controller.warranty.value}",
                                    ),
                                    Text("Price: Rs ${controller.price.value}"),
                                    Text(
                                      "Location: ${controller.location.value?['full_address'] ?? 'Not Set'}",
                                    ),
                                    Text(
                                      "Phone: ${controller.phoneNumber.value}",
                                    ),
                                  ],
                                )
                              );
                            }),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Get.back(), // Go back to editing without losing data
                                child: const Text("Go Back"),
                              ),
                              ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () => controller.submitAd(context),
                                // onPressed: () async {
                                //
                                //   await controller.submitAd();
                                //
                                // },
                                child: const Text("Submit"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () {
                  //     Get.dialog(AlertDialog(
                  //       title: const Text("Preview Ad"),
                  //       content: Obx(() {
                  //         final imageBytes = controller.pickedImageBytes.value;
                  //         return SingleChildScrollView(
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               if (imageBytes != null)
                  //                 Image.memory(
                  //                   imageBytes,
                  //                   height: 100,
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               const SizedBox(height: 8),
                  //               Text("Title: ${controller.title.value}"),
                  //               Text("Description: ${controller.description.value}"),
                  //               Text("Condition: ${controller.condition.value}"),
                  //               Text("Warranty: ${controller.warranty.value}"),
                  //               Text("Price: Rs ${controller.price.value}"),
                  //               Text("Location: ${controller.location.value?['name'] ?? 'Not Set'}"),
                  //               Text("Phone: ${controller.phoneNumber.value}"),
                  //             ],
                  //           ),
                  //         );
                  //       }),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () => Get.back(), // Go back to editing without losing data
                  //           child: const Text("Go Back"),
                  //         ),
                  //         ElevatedButton(
                  //           onPressed: () async {
                  //             await controller.submitAd();
                  //             Get.back();
                  //           },
                  //           child: const Text("Submit"),
                  //         ),
                  //       ],
                  //     ));
                  //   },
                  //   child: const Text("Preview Ad"),
                  // ),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    height: 50,
                    child: CustomButton(
                      text: 'Cancel',
                      icon: Icons.cancel,
                      TextColor: AppColors.white,
                      BackgroundColor: AppColors.red,

                      onPressed: () => Get.offAllNamed('/home'),
                    ),
                  ),
                  // OutlinedButton(
                  //   onPressed: () => Get.offAllNamed('/home'),
                  //   child: const Text("Cancel"),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
    );
  }
}
