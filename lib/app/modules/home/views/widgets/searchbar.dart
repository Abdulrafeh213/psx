import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/supabase_services.dart';
import '../../../chats/controllers/notifications_controller.dart';
import '../../controllers/home_controller.dart';
import 'search_result.dart';

class Searchbar extends GetView<HomeController> {
  Searchbar({super.key});
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );
  @override
  Widget build(BuildContext context) {
    // final searchController = Get.find<SearchController>();
    TextEditingController textEditingController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.textEditingController,
            onChanged: (query) {
              // Trigger filtering when the search query changes
              controller.filterAdsBySearch(query);
            },
            onSubmitted: (query) {
              // Trigger search action when the user presses "Enter" or submits the query
              if (query.isNotEmpty) {
                controller.filterAdsBySearch(query);
                Get.to(() => SearchResultView(categoryId: '',));
              }
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Find cars, Mobile Phones, bikes, and more...',
              // Padding for the hint and input text
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16.0,
              ),
              suffixIcon: Row(
                mainAxisSize:
                    MainAxisSize.min, // Keep icons aligned horizontally
                children: [
                  // // Search Icon
                  // IconButton(
                  //   icon: Icon(Icons.search),  // Search icon on the right
                  //   onPressed: () {
                  //     // Trigger search action and navigate
                  //     controller.filterAdsBySearch(textEditingController.text);
                  //     // Navigate to SearchResultView when the user presses the search button
                  //     Get.to(() => SearchResultView());
                  //   },
                  // ),
                  // Cancel Icon
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        Obx(() {
          int count = notificationController.unreadMessagesCount.value;
          return Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                   // If there are unread notifications, mark them all as read
                  if (count > 0) {
                    final userId = notificationController.supabase.auth.currentUser?.id;
                    // if (userId != null) {
                    //   // Mark all notifications as read
                    //   notificationController.markAllAsRead(userId);
                    // }
                  }

                  // Show the notifications in a dialog
                  _showNotificationDialog(context);
                },
              ),
              if (count > 0)
                Positioned(
                  right: 11,
                  top: 11,
                  child: GestureDetector(
                    onTap: (){


                      _showNotificationDialog(context);

                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$count',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
// Function to show the notification dialog
  // Function to show the notification dialog
  void _showNotificationDialog(BuildContext context) {
    final notificationController = Get.find<NotificationController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notifications"),
          content: Obx(() {
            var notifications = notificationController.notifications;

            // If there are no notifications
            if (notifications.isEmpty) {
              return Text("No new notifications.");
            }

            return SizedBox(
              width: 300,
              height: 400,
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notifications[index]['text'] ?? 'No message'),
                    subtitle: Text(notifications[index]['timestamp'] ?? 'No date'),
                    onTap: () {
                      // Perform action when a notification is tapped
                      print('Tapped on notification: ${notifications[index]}');
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            );
          }),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}