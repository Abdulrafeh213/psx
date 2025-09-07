import 'package:supabase_flutter/supabase_flutter.dart';
import '../app/models/listing.dart';
import 'database_service.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

final supabase = Supabase.instance.client;

class SupabaseService implements DatabaseService {
  static const _url = 'https://jzotfyxetsyliprlbvxh.supabase.co';
  static const _anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6b3RmeXhldHN5bGlwcmxidnhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY1ODQyMzAsImV4cCI6MjA3MjE2MDIzMH0.Yzq2kg3E2M5k1D94XKQLZg9ah-_Ljbsu_x_NMMPJCNI';

  late final SupabaseClient _client;

  @override
  Future<void> init() async {
    await Supabase.initialize(url: _url, anonKey: _anonKey);
    _client = Supabase.instance.client;
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) return null;

    // Try to fetch profile from users table (if you keep it)
    final profile = await _client
        .from('users')
        .select()
        .eq('id', authUser.id)
        .maybeSingle();

    return {
      if (profile != null) ...Map<String, dynamic>.from(profile),
      'id': authUser.id,
      'userId': authUser.id,
      'email': authUser.email,
    };
  }

  @override
  Future<Map<String, dynamic>?> getUser(String userId) async {
    final result = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return result == null ? null : Map<String, dynamic>.from(result);
  }

  @override
  // Sign up user via Supabase Auth and return UID
  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'phone': phone,
        'userRole': 'user',
        'userStatus': 'active',
      },
    );
    return response.user?.id;
  }

  // Upload image to Supabase Storage and return public URL
  Future<String> uploadProfileImage(String uid, String assetPath) async {
    // Convert asset to temporary file
    ByteData byteData = await rootBundle.load(assetPath);
    Uint8List bytes = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/ProfileImage.png');
    await file.writeAsBytes(bytes, flush: true);

    // Upload file
    await supabase.storage
        .from('profile-images')
        .upload(
          'users/$uid/ProfileImage.png',
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    // Return public URL
    return supabase.storage
        .from('profile-images')
        .getPublicUrl('users/$uid/ProfileImage.png');
  }

  // Insert user data into Supabase table
  Future<void> insertUserData({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String profileImageUrl,
  }) async {
    final response = await supabase.from('users').insert({
      'user_id': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'location': '',
      'user_role': 'user',
      'user_status': 'active',
      'profile_image': profileImageUrl,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (response.error != null) throw Exception(response.error!.message);
  }

  @override
  Future<String?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user?.id;
  }

  @override
  Future<String?> loginWithPhone({required String phone}) async {
    final result = await _client
        .from('users')
        .select()
        .eq('phone', phone)
        .limit(1);
    if (result.isEmpty) return null;
    return result.first['id'] as String?;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> saveUser(String userId, Map<String, dynamic> data) async {
    await _client.from('users').insert({...data, 'id': userId});
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _client.from('users').update(data).eq('id', userId);
  }

  @override
  Future<void> saveUserLocation(
    String userId, {
    required double latitude,
    required double longitude,
    required String placeName,
  }) async {
    await _client
        .from('users')
        .update({
          'location': {
            'lat': latitude,
            'lng': longitude,
            'placeName': placeName,
            'updatedAt': DateTime.now().toIso8601String(),
          },
        })
        .eq('id', userId);
  }

  @override
  Future<Map<String, dynamic>?> getUserLocation(String userId) async {
    final result = await _client
        .from('users')
        .select('location')
        .eq('id', userId)
        .maybeSingle();
    return result?['location'] as Map<String, dynamic>?;
  }

  // Fetch all listings stream
  Stream<List<Listing>> listingsStream() {
    return supabase
        .from('listings')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((event) => event.map((e) => Listing.fromMap(e)).toList());
  }

  // Get current user location
  Future<String> currentUserLocationName() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return '';
    final data = await supabase
        .from('users')
        .select('location')
        .eq('id', userId)
        .single();
    if (data['location'] != null) {
      // Assuming location is stored as JSON {'placeName': ['City', 'State']}
      final List<dynamic> placeList = data['location']['placeName'] ?? [];
      return placeList.whereType<String>().join(', ');
    }
    return '';
  }

  // // Add or update listing
  // Future<void> addListing(Listing listing) async {
  //   await supabase.from('listings').upsert(listing.toMap());
  // }

  /// Get all chats (with optional filter for buyer/seller)
  Stream<List<Map<String, dynamic>>> getChatsStream() {
    return supabase
        .from('chats')
        .stream(primaryKey: ['id'])
        .order('last_message_time', ascending: false)
        .map((data) => data.map((e) => e as Map<String, dynamic>).toList());
  }

  /// Delete chat
  Future<void> deleteChat(String chatId) async {
    await supabase.from('chats').delete().eq('id', chatId);
  }

  /// Mark chat as read → set last_message = null
  Future<void> markChatRead(String chatId) async {
    await supabase.from('chats').update({'last_message': ''}).eq('id', chatId);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await supabase
        .from('users')
        .select()
        .eq('user_role', 'user');
    return (response as List).map((e) => e as Map<String, dynamic>).toList();
  }
}
