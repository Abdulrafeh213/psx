import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home/controllers/home_controller.dart';
import '../../../home/views/widgets/search_result.dart';
import '../../controllers/admin_dashboard_controller.dart';

class AdminAdsSearchBar extends GetView<HomeController> {
  AdminAdsSearchBar({super.key});
  final AdminDashboardController adminDashboardController = Get.put(AdminDashboardController()); // Reference to AdsController

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.textEditingController,
            onChanged: (query) {
              controller.filterAdsBySearch(query); // Trigger filtering when the search query changes
            },
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                controller.filterAdsBySearch(query);
                Get.to(() => SearchResultView(categoryId: '',));
              }
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Find cars, Mobile Phones, bikes, and more...',
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.textEditingController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        controller.clearSearch();
                        Get.back(); // Clear the search field
                      },
                    ),
                ],
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),

        // Row for Grid/List View Toggle
        Row(
          children: [
            IconButton(
              icon: Obx(() {
                return Icon(
                  Icons.grid_on,
                  color: adminDashboardController.isGridView.value ? Colors.blue : Colors.grey,
                );
              }),
              onPressed: () {
                adminDashboardController.isGridView.value = true;
              },
            ),
            IconButton(
              icon: Obx(() {
                return Icon(
                  Icons.list,
                  color: !adminDashboardController.isGridView.value ? Colors.blue : Colors.grey,
                );
              }),
              onPressed: () {
                adminDashboardController.isGridView.value = false;
              },
            ),
          ],
        ),
      ],
    );
  }
}
