import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paksecureexchange/app/widgets/show_message_widget.dart';

import '../../../constants/appFonts.dart';
import '../../../constants/colors.dart';
import '../../../widgets/search_bar.dart';
import '../../chats/controllers/chats_controller.dart';
import '../../chats/views/chat_detail_view.dart';
import 'widgets/custom_nav_bar.dart';

class AdminChatsView extends StatelessWidget {
  AdminChatsView({super.key});
  final ChatsController controller = Get.put(ChatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: AppTextStyles.appBar,
        title: const Text("Admin Chats"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBarWidget(
              onChanged: (val) => controller.searchQuery.value = val,
            ),
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
                          child: const Icon(Icons.delete, color: Colors.white),
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

      // 🔹 Floating Action Button to start new chat
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.chat, color: Colors.white),
        onPressed: () {
          _showUserListPopup(context);
        },
      ),
      bottomNavigationBar: const CustomAdminNavBar(currentIndex: 1),
    );
  }

  // 🔹 Popup with all users where role == "user"
  void _showUserListPopup(BuildContext context) {
    final ChatsController chatsController = Get.put(ChatsController());

    // Load users when popup opens
    chatsController.fetchUsers();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select User"),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Obx(() {
              if (chatsController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = chatsController.users;

              if (users.isEmpty) {
                return const Center(child: Text("No users found"));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final userName = user['name'] ?? "Unnamed";
                  final userEmail = user['email'] ?? "";

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          (user['image_url'] != null &&
                              user['image_url'].toString().isNotEmpty)
                          ? NetworkImage(user['image_url'])
                          : null,
                      child:
                          (user['image_url'] == null ||
                              user['image_url'].toString().isEmpty)
                          ? const Icon(Icons.person)
                          : null,
                    ),

                    title: Text(userName),
                    subtitle: Text(userEmail),
                    onTap: () async {
                      final userId = user['user_id'];

                      if (user['user_id'] == null ||
                          user['user_id'].toString().isEmpty) {
                        showMessage("Error", "Invalid user ID");
                        return;
                      }

                      final chatId = await controller.createOrGetChat(
                        otherUserId: userId.toString(),
                      );

                      Get.back();
                      Get.to(
                        () => ChatDetailView(
                          chatId: chatId,
                          otherId: userId.toString(),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}
