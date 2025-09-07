// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../chats/views/chat_detail_view.dart';
//
// class AdminDashboardController extends GetxController {
//   final users = <Map<String, dynamic>>[].obs;
//   final ads = <Map<String, dynamic>>[].obs;
//   final usersRes = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUsers();
//     fetchUserData();
//     fetchAds();
//     fetchStats();
//   }
//
//   final supabase = Supabase.instance.client;
//
//   final dashboardStats = <String, int>{
//     "users": 0,
//     "ads": 0,
//     "categories": 0,
//     "itemsSold": 0,
//     "allItems": 0,
//     "payments": 0,            // number of transactions (rows)
//     "pendingDeliveries": 0,
//     "delivered": 0,
//     "chats": 0,
//   }.obs;
//
//   Future<void> fetchStats() async {
//     try {
//       // final usersRes = await supabase.from('users').select('id').count();
//       final adsRes = await supabase.from('ads').select('id').count();
//       final categoriesRes = await supabase.from('categories').select('id').count();
//       final allItemsRes = await supabase.from('items').select('id').count();
//       final chatsRes = await supabase.from('chats').select('id').count();
//
//       final itemsSoldRes = await supabase
//           .from('items')
//           .select('id')
//           .eq('status', 'sold')
//           .count();
//
//       final pendingDelRes = await supabase
//           .from('deliveries')
//           .select('id')
//           .eq('status', 'pending')
//           .count();
//
//       final deliveredRes = await supabase
//           .from('deliveries')
//           .select('id')
//           .eq('status', 'delivered')
//           .count();
//
//       final paymentsRes = await supabase.from('payments').select('id').count();
//
//       dashboardStats["users"] = usersRes.toInt() ?? 0;
//       dashboardStats["ads"] = adsRes.count ?? 0;
//       dashboardStats["categories"] = categoriesRes.count ?? 0;
//       dashboardStats["itemsSold"] = itemsSoldRes.count ?? 0;
//       dashboardStats["allItems"] = allItemsRes.count ?? 0;
//       dashboardStats["payments"] = paymentsRes.count ?? 0;
//       dashboardStats["pendingDeliveries"] = pendingDelRes.count ?? 0;
//       dashboardStats["delivered"] = deliveredRes.count ?? 0;
//       dashboardStats["chats"] = chatsRes.count ?? 0;
//
//       dashboardStats.refresh();
//     } catch (e) {
//       print("Error fetching dashboard stats: $e");
//     }
//   }
//
//   Future<void> fetchUsers() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection("users")
//         .where("userRole", isEqualTo: "user")
//         .get();
//
//     users.value = snapshot.docs.map((e) => e.data()).toList();
//     usersRes.value = snapshot.size;
//   }
//
//   Future<void> fetchAds() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection("products")
//         .get();
//     ads.value = snapshot.docs.map((e) => e.data()).toList();
//   }
//
//   Future<void> approveAd(String adId, String status) async {
//     await FirebaseFirestore.instance.collection("products").doc(adId).update({
//       "status": status,
//     });
//     fetchAds();
//   }
//
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//
//   final RxString imageUrl = "".obs;
//   final RxBool isLoading = false.obs;
//
//   final user = FirebaseAuth.instance.currentUser;
//
//   Future<void> fetchUserData() async {
//     if (user == null) return;
//     final doc = await FirebaseFirestore.instance
//         .collection("users")
//         .doc(user!.uid)
//         .get();
//     if (doc.exists) {
//       final data = doc.data()!;
//       nameController.text = data["name"] ?? "";
//       emailController.text = data["email"] ?? user!.email ?? "";
//       phoneController.text = data["phone"] ?? "";
//       imageUrl.value = data["image"] ?? "";
//     }
//   }
//
//   Future<void> pickImage() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: false,
//     );
//
//     if (result != null && result.files.isNotEmpty) {
//       final path = result.files.single.path;
//       if (path != null) {
//         final file = File(path);
//
//         try {
//           final ref = FirebaseStorage.instance.ref().child(
//             "profile/${user!.uid}.jpg",
//           );
//           await ref.putFile(file);
//
//           final url = await ref.getDownloadURL();
//           imageUrl.value = url;
//           showMessage(
//             "Success",
//             "Image uploaded",
//             snackPosition: SnackPosition.BOTTOM,
//           );
//         } catch (e) {
//           showMessage(
//             "Error",
//             "Failed to upload image: $e",
//             snackPosition: SnackPosition.BOTTOM,
//           );
//         }
//       }
//     }
//   }
//
//   Future<void> updateProfile() async {
//     if (user == null) return;
//
//     try {
//       isLoading.value = true;
//
//       // // 🔹 Update Firebase Auth Email (if changed)
//       // if (emailController.text.trim() != user!.email) {
//       //   await user!.updateEmail(emailController.text.trim());
//       // }
//
//       // 🔹 Update Firestore User Document
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(user!.uid)
//           .update({
//             "name": nameController.text.trim(),
//             "email": emailController.text.trim(),
//             "phone": phoneController.text.trim(),
//             "image": imageUrl.value,
//           });
//
//       showMessage(
//         "Success",
//         "Profile updated successfully",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       showMessage(
//         "Error",
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   var userData = Rxn<Map<String, dynamic>>();
//   var isEditing = false.obs;
//
//   final auth = FirebaseAuth.instance;
//
//   // 🔹 Load user data
//   Future<void> loadUser(String uid) async {
//     final doc = await FirebaseFirestore.instance
//         .collection("users")
//         .doc(uid)
//         .get();
//     userData.value = doc.data();
//   }
//
//   // 🔹 Update user fields
//   Future<void> updateUserData(Map<String, dynamic> data) async {
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(userData.value!["id"])
//         .update(data);
//     await loadUser(userData.value!["id"]);
//     showMessage("Updated", "User details updated successfully");
//   }
//
//   // 🔹 Delete User
//   Future<void> deleteUser(String uid) async {
//     try {
//       // delete from firestore (user, ads, chats)
//       await FirebaseFirestore.instance.collection("users").doc(uid).delete();
//
//       final products = await FirebaseFirestore.instance
//           .collection("products")
//           .where("userId", isEqualTo: uid)
//           .get();
//       for (var doc in products.docs) {
//         await doc.reference.delete();
//       }
//
//       final chats = await FirebaseFirestore.instance
//           .collection("chats")
//           .where("participants", arrayContains: uid)
//           .get();
//       for (var doc in chats.docs) {
//         await doc.reference.delete();
//       }
//
//       // delete from Firebase Auth
//       await FirebaseAuth.instance.currentUser!.delete();
//
//       Get.back(); // go back
//       showMessage("Deleted", "User and all data deleted");
//     } catch (e) {
//       showMessage("Error", e.toString());
//     }
//   }
//
//   // 🔹 Toggle status
//   Future<void> toggleUserStatus(String uid) async {
//     final userDoc = await FirebaseFirestore.instance
//         .collection("users")
//         .doc(uid)
//         .get();
//     final currentStatus = userDoc["status"] ?? "active";
//     final newStatus = currentStatus == "active" ? "deactive" : "active";
//
//     await FirebaseFirestore.instance.collection("users").doc(uid).update({
//       "status": newStatus,
//     });
//     await loadUser(uid);
//     showMessage("Status Changed", "User is now $newStatus");
//   }
//
//   void startChatWithMessage(
//     String uid,
//     String name,
//     String email,
//     String message,
//   ) async {
//     final currentId = FirebaseAuth.instance.currentUser!.uid;
//     final chatId = [currentId, uid]..sort();
//     final chatDocId = chatId.join("_");
//
//     final chatDoc = FirebaseFirestore.instance
//         .collection("chats")
//         .doc(chatDocId);
//     final exists = await chatDoc.get();
//
//     if (!exists.exists) {
//       await chatDoc.set({
//         "participants": [currentId, uid],
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//     }
//
//     // Send the initial message
//     await chatDoc.collection("messages").add({
//       "text": message,
//       "senderId": currentId,
//       "timestamp": FieldValue.serverTimestamp(),
//     });
//
//     // // Navigate to chat screen
//     // Get.to(() => ChatDetailView(
//     //   userId: uid,
//     //   userName: name,
//     //   userEmail: email,
//     // ));
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constants/colors.dart';
import '../../../widgets/show_message_widget.dart';

class AdminDashboardController extends GetxController {
  final supabase = Supabase.instance.client;
  String? get userId => supabase.auth.currentUser?.id;
  final selectedTab = 'All'.obs;

  final users = <Map<String, dynamic>>[].obs;
  final ads = <Map<String, dynamic>>[].obs;

  final categories = <Map<String, dynamic>>[].obs;

  final allAds = <Map<String, dynamic>>[].obs;
  final usersRes = 0.obs;
  // Store emails separately
  final userEmails = <String>[].obs;
  final dashboardStats = <String, int>{
    "users": 0,
    "ads": 0,
    "categories": 0,
    "itemsSold": 0,
    "allItems": 0,
    "payments": 0,
    "pendingDeliveries": 0,
    "delivered": 0,
    "chats": 0,
  }.obs;

  var usersList = <Map<String, dynamic>>[].obs;
  var userData = Rxn<Map<String, dynamic>>();
  var isEditing = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final RxString imageUrl = "".obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchUserData();
    fetchAds();
    fetchStats();
    loadAllUsers();
    _listenForAdsChanges();
    fetchCategories();
  }

  /// ===================== DASHBOARD STATS =====================

  // Controller

  // void fetchCategories() async {
  //   try {
  //     isLoading(true); // Start loading
  //     final response = await supabase.from('categories').select();
  //
  //     final data = (response as List)
  //         .map((e) => e as Map<String, dynamic>)
  //         .toList();
  //
  //     // Save full user maps if you still need them
  //     categories.value = data;
  //
  //     // categories.value = List<Map<String, dynamic>>.from(response);
  //     // Assuming response is a List<Map<String, dynamic>>
  //   } catch (e) {
  //     print("Error fetching categories: $e");
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> fetchCategories() async {

    try {
      isLoading.value = true;
      final response = await supabase.from('categories').select();
      categories.value = (response as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      print(categories);
    } catch (e) {
      print("Error fetching ads: $e");
      ads.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchCategories() async {
  //   try {
  //     isLoading.value = true;
  //
  //     final response = await Supabase.instance.client
  //         .from('categories')
  //         .select('*'); // Get all ads
  //
  //     final fetchedCategories = (response as List<dynamic>)
  //         .map((e) => Map<String, dynamic>.from(e))
  //         .toList();
  //
  //     // ✅ Assign to allAds so filtering works
  //     categories.assignAll(fetchedCategories);
  //
  //
  //     print("🛒 Total categories fetched (all statuses): ${fetchedCategories.length}");
  //   } catch (e) {
  //     print("❌ Error fetching products: $e");
  //     ads.clear();
  //   } finally {
  //     isLoading.value = false;
  //     print("✅ Loading finished");
  //   }
  // }


  // Fetch ads based on category ID
  List<dynamic> adsInCategory(String categoryId) {
    return ads.where((ad) => ad['category_id'] == categoryId).toList();
  }

  Future<void> fetchStats() async {
    try {
      // final usersRes = usersList.length;
      final adsRes = await supabase.from('ads').select('id');
      final categoriesRes = await supabase.from('categories').select('id');
      final allItemsRes = await supabase.from('items').select('id');
      final chatsRes = await supabase.from('chats').select('id');

      final itemsSoldRes = await supabase
          .from('items')
          .select('id')
          .eq('status', 'sold');

      final pendingDelRes = await supabase
          .from('deliveries')
          .select('id')
          .eq('status', 'pending');

      final deliveredRes = await supabase
          .from('deliveries')
          .select('id')
          .eq('status', 'delivered');

      final paymentsRes = await supabase.from('payments').select('id');

      // update stats
      dashboardStats["users"] = usersList.length;
      dashboardStats["ads"] = adsRes.length;
      dashboardStats["categories"] = categoriesRes.length;
      dashboardStats["itemsSold"] = itemsSoldRes.length;
      dashboardStats["allItems"] = allItemsRes.length;
      dashboardStats["payments"] = paymentsRes.length;
      dashboardStats["pendingDeliveries"] = pendingDelRes.length;
      dashboardStats["delivered"] = deliveredRes.length;
      dashboardStats["chats"] = chatsRes.length;

      dashboardStats.refresh(); // trigger UI update
    } catch (e) {
      print("Error fetching dashboard stats: $e");
    }
  }

  /// ===================== USERS =====================
  Future<void> fetchUsers() async {
    final response = await supabase
        .from("users")
        .select("user_id, email")
        .eq("user_role", "user");

    final data = (response as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    // Save full user maps if you still need them
    users.value = data;

    // Extract only emails
    userEmails.value = data
        .map((e) => e["email"]?.toString() ?? "")
        .where((email) => email.isNotEmpty)
        .toList();

    // Count stays for dashboard
    usersRes.value = users.length;
  }

  Future<void> fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from("users")
        .select()
        .eq("user_id", user.id)
        .maybeSingle();

    if (response != null) {
      userData.value = response;
      nameController.text = response["name"] ?? "";
      emailController.text = response["email"] ?? user.email ?? "";
      phoneController.text = response["phone"] ?? "";
      imageUrl.value = response["profile_image"] ?? "";
    }
  }

  Future<void> updateProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      isLoading.value = true;

      await supabase
          .from("users")
          .update({
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "phone": phoneController.text.trim(),
            "profile_image": imageUrl.value,
          })
          .eq("user_id", user.id);

      showMessage("Success", "Profile updated successfully");
    } catch (e) {
      showMessage("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) {
        final file = File(path);

        try {
          final fileName = "profile/${supabase.auth.currentUser!.id}.jpg";
          await supabase.storage
              .from("avatars")
              .upload(
                fileName,
                file,
                fileOptions: const FileOptions(upsert: true),
              );

          final url = supabase.storage.from("avatars").getPublicUrl(fileName);

          imageUrl.value = url;
          showMessage("Success", "Image uploaded");
        } catch (e) {
          showMessage("Error", "Failed to upload image: $e");
        }
      }
    }
  }

  // Future<void> loadUser(String uid) async {
  //   final response = await supabase.from("users").select().eq("id", uid).maybeSingle();
  //   if (response != null) {
  //     userData.value = response;
  //   }
  // }

  // Future<void> updateUserData(Map<String, dynamic> data) async {
  //   await supabase.from("users").update(data).eq("id", userData.value!["id"]);
  //   await loadUser(userData.value!["id"]);
  //   showMessage("Updated", "User details updated successfully");
  // }

  // Future<void> deleteUser(String uid) async {
  //   try {
  //     await supabase.from("users").delete().eq("id", uid);
  //     await supabase.from("products").delete().eq("userId", uid);
  //     await supabase.from("chats").delete().contains("participants", [uid]);
  //
  //     Get.back();
  //     showMessage("Deleted", "User and all data deleted");
  //   } catch (e) {
  //     showMessage("Error", e.toString());
  //   }
  // }

  // Future<void> toggleUserStatus(String uid) async {
  //   final response =
  //   await supabase.from("users").select("status").eq("id", uid).maybeSingle();
  //
  //   if (response != null) {
  //     final currentStatus = response["status"] ?? "active";
  //     final newStatus = currentStatus == "active" ? "deactive" : "active";
  //
  //     await supabase.from("users").update({"status": newStatus}).eq("id", uid);
  //     await loadUser(uid);
  //     showMessage("Status Changed", "User is now $newStatus");
  //   }
  // }

  /// ===================== ADS =====================
  Future<void> fetchAds() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client
          .from('products')
          .select('*'); // Get all ads

      final fetchedAds = (response as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      // ✅ Assign to allAds so filtering works
      allAds.assignAll(fetchedAds);

      // ✅ Apply selected tab filter
      _applyFilter();

      print("🛒 Total products fetched (all statuses): ${fetchedAds.length}");
    } catch (e) {
      print("❌ Error fetching products: $e");
      ads.clear();
    } finally {
      isLoading.value = false;
      print("✅ Loading finished");
    }
  }

  void _applyFilter() {
    final filter = selectedTab.value.toLowerCase();
    ads.value = allAds.where((ad) {
      final status = (ad['ads_status'] ?? '').toString().toLowerCase();
      if (filter == 'all') return true;
      return status == filter;
    }).toList();
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    _applyFilter();
  }

  void _listenForAdsChanges() {
    final uid = userId;
    if (uid == null) return;

    // Supabase stream returns initial data + updates
    _subscription = supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .listen(
          (liveData) {
            print('Realtime update received: ${liveData.length} records');
            allAds.assignAll(liveData.map((e) => Map<String, dynamic>.from(e)));
            _applyFilter();
          },
          onError: (err) {
            print('Realtime stream error: $err');
          },
        );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Color getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
        return Colors.green;
      case 'used':
        return Colors.orange;
      case 'refurbished':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'inactive':
        return Colors.red;
      default:
        return AppColors.textColor;
    }
  }

  Future<void> approveAd(String adId, String status) async {
    await supabase.from("ads").update({"status": status}).eq("id", adId);
    fetchAds();
  }

  /// Fetch all users
  Future<void> loadAllUsers() async {
    try {
      final response = await supabase
          .from('users')
          .select(
            'user_id, name, email, phone, location, user_role, user_status, profile_image, created_at',
          )
          .eq('user_role', 'user');

      // Ensure correct type casting
      final data = (response as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      usersList.value = data;
    } catch (e) {
      print("Error loading users: $e");
      usersList.value = [];
    }
  }

  /// Load single user by ID
  Future<void> loadUser(String userId) async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        userData.value = response;
        nameController.text = response['name'] ?? '';
        emailController.text = response['email'] ?? '';
        phoneController.text = response['phone'] ?? '';
        locationController.text = response['location'] ?? '';
      }
    } catch (e) {
      showMessage("Error", "Failed to load user: $e");
    }
  }

  /// Update user
  Future<void> updateUserData(
    String userId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await supabase.from('users').update(updatedData).eq('user_id', userId);
      await loadUser(userId);
      await loadAllUsers();
      showMessage("Success", "User updated successfully");
    } catch (e) {
      showMessage("Error", "Failed to update user: $e");
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await supabase.from('users').delete().eq('user_id', userId);
      await loadAllUsers();
      Get.back();
      showMessage("Deleted", "User has been deleted");
    } catch (e) {
      showMessage("Error", "Failed to delete user: $e");
    }
  }

  /// Toggle status (active / inactive)
  Future<void> toggleUserStatus(String userId) async {
    try {
      final current = userData.value?['user_status'] ?? 'inactive';
      final newStatus = current == 'active' ? 'inactive' : 'active';

      await supabase
          .from('users')
          .update({'user_status': newStatus})
          .eq('user_id', userId);

      await loadUser(userId);
      await loadAllUsers();
      showMessage("Status Updated", "User status set to $newStatus");
    } catch (e) {
      showMessage("Error", "Failed to update status: $e");
    }
  }

  var isGridView = false.obs; // Track view mode (grid or list)

  void toggleViewMode(bool isGrid) {
    isGridView.value = isGrid;
  }
}
