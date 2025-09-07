import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/appFonts.dart';
import '../../../constants/colors.dart';
import '../../../widgets/custom_nav_bar.dart';
import '../../../widgets/search_bar.dart';
import '../../../widgets/show_message_widget.dart';
import '../controllers/chats_controller.dart';
import 'chat_detail_view.dart';

class ChatsView extends GetView<ChatsController> {
  ChatsView({super.key});

  final ChatsController controller = Get.put(ChatsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: AppColors.white),
          titleTextStyle: AppTextStyles.appBar,
          title: const Text("Chats"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
              110,
            ), // enough height for search + tabs
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchBarWidget(
                    onChanged: (val) => controller.searchQuery.value = val,
                  ),
                ),
                TabBar(
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.navBar,
                  indicatorColor: AppColors.white,
                  onTap: (index) {
                    if (index == 0) controller.selectedTab.value = 'all';
                    if (index == 1) controller.selectedTab.value = 'buyer';
                    if (index == 2) controller.selectedTab.value = 'seller';
                  },
                  tabs: const [
                    Tab(text: "All"),
                    Tab(text: "Buying"),
                    Tab(text: "Selling"),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            // Chat List
            Expanded(
              child: Obx(() {
                final chats = controller.filteredChats;

                if (chats.isEmpty) {
                  return const Center(child: Text("No chats yet."));
                }

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final lastMsg = chat['last_message'] ?? '';
                    final lastTime = chat['last_message_time'] ?? '';

                    String buyerId = "Unknown";
                    String sellerId = "Unknown";

                    if (chat['participants'] is Map) {
                      buyerId = chat['participants']['buyerId'] ?? "Unknown";
                      sellerId = chat['participants']['sellerId'] ?? "Unknown";
                    }

                    final otherId = buyerId; // fallback

                    return FutureBuilder<Map<String, dynamic>?>(
                      future: controller.getUser(otherId),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const SizedBox();
                        }

                        final userData = userSnapshot.data!;
                        final name = userData['name'] ?? "User";
                        final email = userData['email'] ?? "";
                        final shortEmail = email.contains("@")
                            ? email.split("@").first
                            : email;

                        return Dismissible(
                          key: Key(chat['id']),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) async {
                            await controller.deleteChat(chat['id']);
                            showMessage(
                              "Deleted",
                              "Chat removed successfully",

                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shortEmail,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    lastMsg,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Text(
                                lastTime.toString().substring(11, 16),
                              ),
                              onTap: () async {
                                await controller.markChatRead(chat['id']);
                                Get.to(
                                  () => ChatDetailView(
                                    chatId: chat['id'],
                                    otherId: otherId,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 1),
      ),
    );
  }
}
