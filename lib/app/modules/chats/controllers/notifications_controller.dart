import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final RxInt unreadMessagesCount = 0.obs;
  final RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[].obs; // Store notifications
  RealtimeChannel? _channel;

  @override
  void onInit() {
    super.onInit();
    _listenUnreadMessages();
  }

  void _listenUnreadMessages() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Initial fetch for unread messages
    _fetchUnreadMessagesCount(userId);
    fetchNotifications(userId);

    // Realtime subscription using channel
    _channel = supabase
        .channel('public:messages')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert, // Triggered when a new message is inserted
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        column: 'receiverId',
        value: userId,
        type: PostgresChangeFilterType.eq,
      ),
      callback: (payload) {
        print('New message: ${payload.newRecord}');
        fetchNotifications(userId); // Refresh the notifications list
      },
    )
        .subscribe();
  }

  Future<void> _fetchUnreadMessagesCount(String userId) async {
    try {
      final response = await supabase.from('chats').select('id').contains(
        'unread_by',
        [userId],
      ).count();

      unreadMessagesCount.value = response.count ?? 0;
    } catch (e) {
      unreadMessagesCount.value = 0;
      print('Error fetching unread messages: $e');
    }
  }

  Future<void> fetchNotifications(String userId) async {
    try {
      final response = await supabase
          .from('messages')
          .select('*')
          .eq('is_read', false) // Unread messages
          .order('timestamp', ascending: false) // Order by timestamp (newest first)
          .limit(10); // Limit to 10 messages

      // Print the raw response for debugging
      print('Raw response: $response');

      // Update notifications directly with the response
      if (response != null && response.isNotEmpty) {
        notifications.value = List<Map<String, dynamic>>.from(response);
      } else {
        print('No notifications found.');
      }

      // Print the notifications list for debugging
      print(notifications.value);

    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }


  // Future<void> markAllAsRead(String userId) async {
  //   try {
  //     // Update the isRead field of all unread messages to true
  //     final response = await supabase
  //         .from('messages')
  //         .update({'isRead': true})
  //         .eq('receiverId', userId)
  //         .eq('isRead', false);
  //
  //     if (response.error == null) {
  //       // Successfully marked all as read, update the notifications list
  //       notifications.clear();
  //       unreadMessagesCount.value = 0;
  //     } else {
  //       print('Error marking notifications as read: ${response.error?.message}');
  //     }
  //   } catch (e) {
  //     print('Error marking notifications as read: $e');
  //   }
  // }

  @override
  void onClose() {
    if (_channel != null) {
      supabase.removeChannel(_channel!);
    }
    super.onClose();
  }
}
