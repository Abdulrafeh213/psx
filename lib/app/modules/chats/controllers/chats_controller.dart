// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ChatsController extends GetxController {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final TextEditingController messageController = TextEditingController();
//
//   final RxList<QueryDocumentSnapshot> chatList = <QueryDocumentSnapshot>[].obs;
//   final RxString searchQuery = ''.obs;
//   final RxString selectedTab = 'all'.obs; // all / buyer / seller
//
//   User get currentUser => _auth.currentUser!;
//
//   // -----------------------
//   // Streams / queries
//   // -----------------------
//
//   /// Get chats stream. If [isAdmin] true, admin sees all chats,
//   /// otherwise only chats where the current user is a participant.
//   Stream<QuerySnapshot> getChatsStream({bool isAdmin = false}) {
//     Query query = _db.collection('chats');
//
//     if (!isAdmin) {
//       query = query.where('participants', arrayContains: currentUser.uid);
//     }
//
//     return query.orderBy('lastMessageTime', descending: true).snapshots();
//   }
//
//   /// Messages stream for a given chatId (ascending by timestamp)
//   Stream<QuerySnapshot> getMessagesStream(String chatId) {
//     return _db
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots();
//   }
//
//   // -----------------------
//   // Helpers
//   // -----------------------
//
//   /// Build a deterministic chatId (sorted user ids + productId or 'general')
//   String _buildChatId(String a, String b, {String? productId}) {
//     final ids = [a, b]..sort();
//     return "${ids[0]}_${ids[1]}_${productId ?? 'general'}";
//   }
//
//   /// Create a new chat doc or return existing chatId.
//   Future<String> createOrGetChat({
//     required String otherUserId,
//     String? productId,
//   }) async {
//     final me = currentUser.uid;
//     final chatId = _buildChatId(me, otherUserId, productId: productId);
//     final chatRef = _db.collection('chats').doc(chatId);
//
//     final existing = await chatRef.get();
//     if (existing.exists) return chatRef.id;
//
//     // Try to infer buyer/seller if product provided
//     String? sellerIdVal;
//     String? buyerIdVal;
//
//     if (productId != null && productId.isNotEmpty) {
//       try {
//         final prodSnap = await _db.collection('products').doc(productId).get();
//         if (prodSnap.exists) {
//           final prodSeller = (prodSnap.data()?['sellerId'] as String?)?.trim();
//           if (prodSeller != null && prodSeller.isNotEmpty) {
//             sellerIdVal = prodSeller;
//             buyerIdVal = (me == prodSeller) ? otherUserId : me;
//           }
//         }
//       } catch (_) {}
//     }
//
//     final docData = <String, dynamic>{
//       'participants': [me, otherUserId],
//       'productId': productId ?? '',
//       'lastMessage': '',
//       'lastMessageTime': FieldValue.serverTimestamp(),
//       'unreadBy': [otherUserId],
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//
//     if (sellerIdVal != null && buyerIdVal != null) {
//       docData['participantsMap'] = {
//         'sellerId': sellerIdVal,
//         'buyerId': buyerIdVal,
//       };
//     }
//
//     await chatRef.set(docData);
//     return chatRef.id;
//   }
//
//   /// Get the "other" participant id from a chat doc snapshot
//   String otherParticipantFromDoc(DocumentSnapshot chatDoc) {
//     final me = currentUser.uid;
//     final participants = List<String>.from(chatDoc['participants'] ?? []);
//     if (participants.isEmpty) return '';
//     return participants.firstWhere((id) => id != me, orElse: () => participants.first);
//   }
//
//   // -----------------------
//   // Messaging
//   // -----------------------
//
//   Future<void> sendMessage(String chatId) async {
//     final text = messageController.text.trim();
//     if (text.isEmpty) return;
//
//     final chatRef = _db.collection('chats').doc(chatId);
//     final msgRef = chatRef.collection('messages').doc();
//
//     try {
//       await msgRef.set({
//         'senderId': currentUser.uid,
//         'text': text,
//         'timestamp': FieldValue.serverTimestamp(),
//         'isRead': false,
//       });
//
//       final chatSnap = await chatRef.get();
//       final participants = List<String>.from(chatSnap.data()?['participants'] ?? []);
//       final others = participants.where((id) => id != currentUser.uid).toList();
//
//       await chatRef.update({
//         'lastMessage': text,
//         'lastMessageTime': FieldValue.serverTimestamp(),
//         'unreadBy': others,
//       });
//
//       messageController.clear();
//     } catch (e) {
//       showMessage('Error', 'Failed to send message: $e', snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   Future<void> markChatRead(String chatId) async {
//     final chatRef = _db.collection('chats').doc(chatId);
//
//     final snap = await chatRef.get();
//     if (!snap.exists) return;
//
//     // 1️⃣ Update chat-level "unreadBy"
//     final unreadBy = List<String>.from(snap.data()?['unreadBy'] ?? []);
//     if (unreadBy.contains(currentUser.uid)) {
//       unreadBy.remove(currentUser.uid);
//       await chatRef.update({'unreadBy': unreadBy});
//     }
//
//     final msgs = await chatRef
//         .collection('messages')
//         .where('isRead', isEqualTo: false)
//         .get();
//
//     final batch = _db.batch();
//     for (final msg in msgs.docs) {
//       // only update if senderId != currentUser.uid
//       if (msg['senderId'] != currentUser.uid) {
//         batch.update(msg.reference, {'isRead': true});
//       }
//     }
//     await batch.commit();
//   }
//
//
//
//
//   Future<void> deleteChatCompletely(String chatId) async {
//     final chatRef = _db.collection('chats').doc(chatId);
//     final msgs = await chatRef.collection('messages').get();
//     final batch = _db.batch();
//     for (final d in msgs.docs) {
//       batch.delete(d.reference);
//     }
//     batch.delete(chatRef);
//     await batch.commit();
//   }
//
//   String usernameFromEmail(String email) {
//     return email.split('@').first;
//   }
//
//
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../services/supabase_services.dart';
import '../../../widgets/show_message_widget.dart';

class ChatsController extends GetxController {
  final supabase = Supabase.instance.client;
  final SupabaseService service = SupabaseService();
  final TextEditingController messageController = TextEditingController();

  final RxList<Map<String, dynamic>> chatList = <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedTab = 'all'.obs; // all / buyer / seller

  String get currentUserId => supabase.auth.currentUser!.id;

  // -----------------------
  // Streams / queries
  // -----------------------

  /// Get chats stream. Admin sees all chats,
  /// normal user sees only their chats.
  Stream<List<Map<String, dynamic>>> getChatsStream({bool isAdmin = false}) {
    final channel = supabase.channel('public:chats');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'chats',
      callback: (_) async {
        final data = await fetchChats(isAdmin: isAdmin);
        chatList.value = data;
      },
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'chats',
      callback: (_) async {
        final data = await fetchChats(isAdmin: isAdmin);
        chatList.value = data;
      },
    );

    channel.subscribe();

    // initial load
    fetchChats(isAdmin: isAdmin).then((data) => chatList.value = data);

    return chatList.stream;
  }

  Future<List<Map<String, dynamic>>> fetchChats({bool isAdmin = false}) async {
    final query = supabase.from('chats').select();

    if (!isAdmin) {
      final data = await query
          .contains('participants', [currentUserId])
          .order('last_message_time', ascending: false);
      return List<Map<String, dynamic>>.from(data);
    }

    final data = await query.order('last_message_time', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  /// Messages stream for given chatId
  Stream<List<Map<String, dynamic>>> getMessagesStream(String chatId) {
    final channel = supabase.channel('public:messages');

    final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        column: 'chat_id',
        value: chatId,
        type: PostgresChangeFilterType.eq,
      ),
      callback: (_) async {
        final data = await supabase
            .from('messages')
            .select()
            .eq('chat_id', chatId)
            .order('timestamp', ascending: true);
        messages.value = List<Map<String, dynamic>>.from(data);
      },
    );

    channel.subscribe();

    // initial load
    supabase
        .from('messages')
        .select()
        .eq('chat_id', chatId)
        .order('timestamp', ascending: true)
        .then((data) => messages.value = List<Map<String, dynamic>>.from(data));

    return messages.stream;
  }

  // -----------------------
  // Helpers
  // -----------------------

  String _buildChatId(String a, String b, {String? productId}) {
    final ids = [a, b]..sort();
    return "${ids[0]}_${ids[1]}_${productId ?? 'general'}";
  }

  var users = [].obs; // observable list of users
  var isLoading = false.obs;

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      // Step 1: Fetch users including image field
      final response = await supabase
          .from('users')
          .select('user_id, name, email, user_role, created_at, profile_image')
          .eq('user_role', 'user')
          .order('created_at', ascending: false);

      // Step 2: Generate correct image URL
      final List<Map<String, dynamic>> usersWithImages = [];
      for (var user in response) {
        String? imagePath = user['profile_image'];
        String? imageUrl;

        if (imagePath != null && imagePath.isNotEmpty) {
          if (imagePath.startsWith("http")) {
            // Already a full URL
            imageUrl = imagePath;
          } else {
            // Only a filename/path → build public URL
            imageUrl = supabase.storage
                .from('profile-images') // your bucket
                .getPublicUrl(imagePath);
          }
        }

        usersWithImages.add({...user, 'image_url': imageUrl});
      }

      users.value = usersWithImages;
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch single user by ID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('user_id', userId)
          .single();
      return response;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<String> createOrGetChat({
    required String otherUserId,
    String? productId,
  }) async {
    final me = currentUserId;

    // Generate chatId safely (your _buildChatId should return a valid string)
    final chatId = _buildChatId(me, otherUserId, productId: productId);

    // 🔹 Check if chat already exists
    final existing = await supabase
        .from('chats')
        .select()
        .eq('id', chatId)
        .maybeSingle();

    if (existing != null) return chatId;

    String? sellerIdVal;
    String? buyerIdVal;

    // 🔹 If chat is about a product → fetch seller_id
    if (productId != null && productId.isNotEmpty) {
      final prodSnap = await supabase
          .from('products')
          .select('seller_id')
          .eq('id', productId)
          .maybeSingle();

      if (prodSnap != null) {
        final prodSeller = prodSnap['seller_id'] as String?;
        if (prodSeller != null && prodSeller.isNotEmpty) {
          sellerIdVal = prodSeller;
          buyerIdVal = (me == prodSeller) ? otherUserId : me;
        }
      }
    }

    // 🔹 Prepare chat row data
    final docData = <String, dynamic>{
      'id': chatId, // should match your chats.id (text/uuid)
      'participants': [me, otherUserId],
      'product_id': (productId != null && productId.isNotEmpty)
          ? productId
          : null,
      'last_message': '',
      'last_message_time': DateTime.now().toIso8601String(),
      'unread_by': [otherUserId],
      'created_at': DateTime.now().toIso8601String(),
    };

    // 🔹 Add participants_map only if both values exist
    if (sellerIdVal != null && buyerIdVal != null) {
      docData['participants_map'] = {
        'sellerId': sellerIdVal,
        'buyerId': buyerIdVal,
      };
    }

    // 🔹 Insert new chat
    await supabase.from('chats').insert(docData);

    return chatId;
  }

  String otherParticipantFromDoc(Map<String, dynamic> chatDoc) {
    final me = currentUserId;
    final participants = List<String>.from(chatDoc['participants'] ?? []);
    if (participants.isEmpty) return '';
    return participants.firstWhere(
      (id) => id != me,
      orElse: () => participants.first,
    );
  }

  // -----------------------
  // Messaging
  // -----------------------


  Future<String?> getReceiverId(String chatId, String senderId) async {
    try {
      final response = await supabase
          .from('chats')
          .select('participants')
          .eq('id', chatId)
          .single();  // Single because the chat_id is unique

      if (response != null) {
        List<String> participants = List<String>.from(response['participants']);

        // Remove senderId from the list of participants to find the receiver
        participants.remove(senderId);

        if (participants.isNotEmpty) {
          return participants.first;  // The receiver is the other participant
        } else {
          return null;  // If no receiver found, the chat might only have one participant
        }
      }
    } catch (e) {
      print('Error fetching chat participants: $e');
    }
    return null;  // Default return if no receiver is found
  }


  Future<void> sendMessage(String chatId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      // Get the receiverId from participants in the chat
      final receiverId = await getReceiverId(chatId, currentUserId);
      if (receiverId == null) {
        showMessage('Error', 'No receiver found for this chat.');
        return;
      }

      // Send message with receiverId
      await supabase.from('messages').insert({
        'chat_id': chatId,
        'sender_id': currentUserId,
        'receiver_id': receiverId,  // Set receiverId
        'text': text,
        'timestamp': DateTime.now().toIso8601String(),
        'is_read': false,
      });

      // Update chat with last message info
      final chatSnap = await supabase.from('chats').select().eq('id', chatId).maybeSingle();
      if (chatSnap != null) {
        final participants = List<String>.from(chatSnap['participants'] ?? []);
        final others = participants.where((id) => id != currentUserId).toList();
        await supabase
            .from('chats')
            .update({
          'last_message': text,
          'last_message_time': DateTime.now().toIso8601String(),
          'unread_by': others,
        })
            .eq('id', chatId);
      }

      messageController.clear();
    } catch (e) {
      showMessage('Error', 'Failed to send message: $e');
    }
  }


  Future<void> markChatRead(String chatId) async {
    final chatSnap = await supabase
        .from('chats')
        .select()
        .eq('id', chatId)
        .maybeSingle();
    if (chatSnap == null) return;

    final unreadBy = List<String>.from(chatSnap['unread_by'] ?? []);
    if (unreadBy.contains(currentUserId)) {
      unreadBy.remove(currentUserId);
      await supabase
          .from('chats')
          .update({'unread_by': unreadBy})
          .eq('id', chatId);
    }

    final msgs = await supabase
        .from('messages')
        .select()
        .eq('chat_id', chatId)
        .eq('is_read', false);

    for (final msg in msgs) {
      if (msg['sender_id'] != currentUserId) {
        await supabase
            .from('messages')
            .update({'is_read': true})
            .eq('id', msg['id']);
      }
    }
  }

  Future<void> deleteChatCompletely(String chatId) async {
    await supabase.from('messages').delete().eq('chat_id', chatId);
    await supabase.from('chats').delete().eq('id', chatId);
  }

  String usernameFromEmail(String email) {
    return email.split('@').first;
  }

  var chats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    service.getChatsStream().listen((data) {
      chats.value = data;
    });
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    return await service.getUser(userId);
  }

  Future<void> deleteChat(String chatId) async {
    await service.deleteChat(chatId);
  }

  /// Filtered chats (by tab + search)
  List<Map<String, dynamic>> get filteredChats {
    var filtered = chats;

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (chat) => (chat['last_message'] ?? '').toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
          )
          .toList()
          .obs;
    }

    return filtered;
  }
}
