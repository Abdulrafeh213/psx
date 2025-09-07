// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../widgets/common_app_bar.dart';
// import '../controllers/chats_controller.dart';
// import 'chat_detail_view.dart';
//
// class ChatListView extends StatelessWidget {
//   final ChatsController controller = Get.find<ChatsController>();
//
//   ChatListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CommonAppBar(title: 'Chats'),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: controller.chatsStream,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//
//           final chats = snapshot.data!.docs;
//
//           if (chats.isEmpty) {
//             return const Center(child: Text("No chats yet."));
//           }
//
//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               final participants = List<String>.from(chat['participants']);
//               final otherId = participants.firstWhere((id) => id != controller.auth.currentUser!.uid);
//
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.teal[300],
//                   child: Icon(Icons.person, color: Colors.white),
//                 ),
//                 title: Text(chat['lastMessage'] ?? 'No message'),
//                 subtitle: Text("Tap to continue..."),
//                 trailing: Text(
//                   chat['lastTimestamp'] != null
//                       ? (chat['lastTimestamp'] as Timestamp).toDate().toLocal().toString().substring(11, 16)
//                       : '',
//                 ),
//                 onTap: () {
//                   Get.to(() => ChatDetailView(
//                     userId: otherId,
//                     userName: 'User $otherId',
//                     userEmail: '',
//                   ));
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
