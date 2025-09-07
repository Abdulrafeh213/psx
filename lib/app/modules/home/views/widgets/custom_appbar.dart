import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../authentication/controllers/authentication_controller.dart';
import '../../../chats/controllers/notifications_controller.dart';
import '../../controllers/home_controller.dart';
import 'searchbar.dart';

class HomeTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomeTopAppBar({super.key});

  final _controller = Get.put(HomeController());
  final authController = Get.put(AuthenticationController());
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.only(right: 16, left: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.textColor)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () => Get.offNamed('/home'),

                    child: Image.asset(
                      'assets/images/PSX-Logo1.png',
                      width: 90,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 80),

                  // Location with overflow + icon fixed at end
                  Expanded(
                    child: Row(
                      children: [
                        // Location icon (fixed at the end)
                        const Icon(Icons.location_on_outlined, size: 18),
                        const SizedBox(width: 4),
                        // Text with ellipsis
                        Expanded(
                          child: Obx(() {
                            final authController =
                                Get.find<AuthenticationController>();
                            return Text(
                              authController.location.value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 14),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Searchbar(),
                ),
                // const SizedBox(width: 8),
                // Obx(() {
                //   int count = notificationController.unreadMessagesCount.value;
                //   return Stack(
                //     children: [
                //       IconButton(
                //         icon: Icon(Icons.notifications),
                //         onPressed: () {
                //           // Navigate to notifications screen
                //         },
                //       ),
                //       if (count > 0)
                //         Positioned(
                //           right: 11,
                //           top: 11,
                //           child: Container(
                //             padding: EdgeInsets.all(2),
                //             decoration: BoxDecoration(
                //               color: Colors.red,
                //               shape: BoxShape.circle,
                //             ),
                //             constraints: BoxConstraints(
                //               minWidth: 16,
                //               minHeight: 16,
                //             ),
                //             child: Text(
                //               '$count',
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 10,
                //               ),
                //               textAlign: TextAlign.center,
                //             ),
                //           ),
                //         ),
                //     ],
                //   );
                // }),
                // IconButton(
                //   icon: const Icon(Icons.notifications_none),
                //   onPressed: () {},
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
