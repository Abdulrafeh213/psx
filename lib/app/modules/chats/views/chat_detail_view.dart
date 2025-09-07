// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../constants/appFonts.dart';
// import '../../../constants/colors.dart';
// import '../controllers/chats_controller.dart';
//
// class ChatDetailView extends StatelessWidget {
//   final String chatId;
//   final String otherId;
//
//   ChatDetailView({super.key, required this.chatId, required this.otherId});
//
//   final ChatsController controller = Get.find();
//
//   Future<Map<String, dynamic>?> _getOtherUser() async {
//     final userSnap = await FirebaseFirestore.instance
//         .collection("users")
//         .doc(otherId)
//         .get();
//     if (userSnap.exists) {
//       return userSnap.data();
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         iconTheme: const IconThemeData(
//           color: Colors.white, ),
//         title: FutureBuilder<Map<String, dynamic>?>(
//           future: _getOtherUser(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Text("Loading...");
//             }
//             if (!snapshot.hasData || snapshot.data == null) {
//               return const Text("Unknown User");
//             }
//
//             final userData = snapshot.data!;
//             final name = userData["name"] ?? "User";
//             final email = userData["email"] ?? "";
//
//             // Remove @gmail.com part
//             final shortEmail = email.contains("@")
//                 ? email.split("@").first
//                 : email;
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: AppTextStyles.appBar),
//                 Text(
//                   shortEmail,
//                   style: AppTextStyles.appBarDis,
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           // Messages
//           Expanded(
//             child: StreamBuilder(
//               stream: controller.getMessagesStream(chatId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData)
//                   return const Center(child: CircularProgressIndicator());
//
//                 final messages = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(10),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index];
//                     final isMe = msg['senderId'] == controller.currentUser.uid;
//
//                     return Align(
//                       alignment: isMe
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 3),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.teal : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           msg['text'] ?? "",
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//
//           // Input box
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             color: Colors.grey[100],
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.attach_file),
//                   onPressed: () {},
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: controller.messageController,
//                     decoration: const InputDecoration(
//                       hintText: "Type a message...",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.teal),
//                   onPressed: () => controller.sendMessage(chatId),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/appFonts.dart';
import '../../../constants/colors.dart';
import '../controllers/chats_controller.dart';

class ChatDetailView extends StatelessWidget {
  final String chatId;
  final String otherId;

  ChatDetailView({super.key, required this.chatId, required this.otherId});

  final ChatsController controller = Get.find();

  // ✅ Fetch other user from Supabase "users" table
  Future<Map<String, dynamic>?> _getOtherUser() async {
    final response = await Supabase.instance.client
        .from("users")
        .select()
        .eq("user_id", otherId)
        .maybeSingle();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    final users = controller.users; // Declare variable outside widget tree
    final user = users.first; // example: pick first user or loop later
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: FutureBuilder<Map<String, dynamic>?>(
          future: _getOtherUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Text("Unknown User");
            }

            final userData = snapshot.data!;
            final name = userData["name"] ?? "User";
            final email = userData["email"] ?? "";

            // Remove @gmail.com part
            final shortEmail = email.contains("@")
                ? email.split("@").first
                : email;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
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
                  ],
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.appBar),
                    Text(shortEmail, style: AppTextStyles.appBarDis),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from("messages")
                  .stream(primaryKey: ["message_id"])
                  .eq("chat_id", chatId)
                  .order("timestamp", ascending: true),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['sender_id'] == controller.currentUserId;

                    // ✅ Find sender info from controller.users list
                    final sender = controller.users.firstWhereOrNull(
                      (u) => u['user_id'] == msg['sender_id'],
                    );

                    final senderImage = sender?['image_url'];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        // Show avatar only for other user (on left)
                        if (!isMe)
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                (senderImage != null &&
                                    senderImage.toString().isNotEmpty)
                                ? NetworkImage(senderImage)
                                : null,
                            child:
                                (senderImage == null ||
                                    senderImage.toString().isEmpty)
                                ? const Icon(Icons.person)
                                : null,
                          ),
                        const SizedBox(width: 8),

                        // Message bubble
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.teal : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              msg['text'] ?? "",
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Show avatar for me (on right)
                        if (isMe)
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                (senderImage != null &&
                                    senderImage.toString().isNotEmpty)
                                ? NetworkImage(senderImage)
                                : null,
                            child:
                                (senderImage == null ||
                                    senderImage.toString().isEmpty)
                                ? const Icon(Icons.person)
                                : null,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // ✅ Input box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.grey[100],
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () => controller.sendMessage(chatId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
