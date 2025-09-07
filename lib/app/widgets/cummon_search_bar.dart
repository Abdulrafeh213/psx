import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/ads/controllers/ads_controller.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/home/views/widgets/search_result.dart';
import '../modules/chats/controllers/notifications_controller.dart';

class CommonSearchbar extends GetView<HomeController> {
  CommonSearchbar({super.key});
  final NotificationController notificationController = Get.put(NotificationController());
  final AdsController adsController = Get.put(AdsController()); // Reference to AdsController

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
            // Grid View Icon
            IconButton(
              icon: Obx(() {
                // Check if the current view is Grid view
                return Icon(
                  Icons.grid_on,
                  color: adsController.isGridView.value ? Colors.blue : Colors.grey,
                );
              }),
              onPressed: () {
                adsController.isGridView.value = true; // Switch to Grid view
              },
            ),
            // List View Icon
            IconButton(
              icon: Obx(() {
                // Check if the current view is List view
                return Icon(
                  Icons.list,
                  color: !adsController.isGridView.value ? Colors.blue : Colors.grey,
                );
              }),
              onPressed: () {
                adsController.isGridView.value = false; // Switch to List view
              },
            ),
          ],
        ),

      ],
    );
  }
}
