// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../widgets/show_message_widget.dart';
//
// class ProfileController extends GetxController {
//   final userData = Rxn<Map<String, dynamic>>();
//   final profileImageProvider = Rxn<ImageProvider>();
//
//   final isEditing = false.obs;
//
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//
//   Stream<DocumentSnapshot<Map<String, dynamic>>>? userStream;
//
//   RxString selectedTab = 'All'.obs;
//   RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;
//
//   final authId = FirebaseAuth.instance.currentUser?.uid;
//
//   @override
//   void onInit() {
//     super.onInit();
//     listenToUserData();
//     fetchAds();
//   }
//
//   void listenToUserData() {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     userStream = FirebaseFirestore.instance
//         .collection("users")
//         .doc(uid)
//         .snapshots();
//     userStream!.listen((snapshot) {
//       if (snapshot.exists) {
//         final data = snapshot.data();
//         if (data != null) {
//           userData.value = data;
//
//           // Populate controllers only if data exists
//           if (data["name"] != null) nameController.text = data["name"];
//           if (data["email"] != null) emailController.text = data["email"];
//           if (data["phone"] != null) phoneController.text = data["phone"];
//
//           // Load image if exists
//           final String? base64Image = data["profileImage"];
//           if (base64Image != null && base64Image.isNotEmpty) {
//             try {
//               final bytes = base64Decode(base64Image);
//               profileImageProvider.value = MemoryImage(bytes);
//             } catch (_) {
//               profileImageProvider.value = const AssetImage(
//                 "assets/images/ProfileImage.png",
//               );
//             }
//           } else {
//             profileImageProvider.value = const AssetImage(
//               "assets/images/ProfileImage.png",
//             );
//           }
//         }
//       }
//     });
//   }
//
//   Future<void> updateUserData(Map<String, dynamic> newData) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       final uid = user.uid;
//
//       // Fetch current Firestore data
//       final currentSnapshot = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(uid)
//           .get();
//       final currentData = currentSnapshot.data() ?? {};
//
//       // Only override changed values
//       final updatedData = Map<String, dynamic>.from(currentData);
//       newData.forEach((key, value) {
//         if (value != null && value.toString().trim().isNotEmpty) {
//           updatedData[key] = value;
//         }
//       });
//
//       // Update Firestore
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(uid)
//           .update(updatedData);
//
//       // Handle email update (FirebaseAuth)
//       if (newData.containsKey("email") && newData["email"] != user.email) {
//         try {
//           await user.verifyBeforeUpdateEmail(newData["email"]);
//           await FirebaseAuth.instance.signOut();
//           Get.offAllNamed('/loginEmail');
//           showMessage(
//             "Success",
//             "Email update requested. Please verify the new email before logging in.",
//           );
//           return;
//         } on FirebaseAuthException catch (e) {
//           if (e.code == 'requires-recent-login') {
//             showMessage(
//               "Error",
//               "Please re-authenticate to update your email.",
//             );
//           } else {
//             showMessage("Error", "Email update failed: ${e.message}");
//           }
//           return;
//         }
//       }
//
//       showMessage("Success", "Profile updated successfully.");
//     } catch (e) {
//       showMessage("Error", "Failed to update profile: $e");
//     }
//   }
//
//   Future<void> logout() async {
//     await FirebaseAuth.instance.signOut();
//     Get.offAllNamed('/loginEmail');
//   }
//
//   /// Method to pick image file using file_picker and update profile image
//   Future<void> pickAndUploadProfileImage() async {
//     try {
//       // Pick files (only images)
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         withData: true, // important to get bytes directly
//       );
//
//       if (result == null || result.files.isEmpty) return; // user cancelled
//
//       final fileBytes = result.files.first.bytes;
//       if (fileBytes == null) {
//         showMessage("Error", "Failed to get image data.");
//         return;
//       }
//
//       // Convert to base64 string
//       final base64Image = base64Encode(fileBytes);
//
//       // Update Firestore
//       final uid = FirebaseAuth.instance.currentUser!.uid;
//       await FirebaseFirestore.instance.collection("users").doc(uid).update({
//         "profileImage": base64Image,
//       });
//
//       // Update image provider for immediate UI update
//       profileImageProvider.value = MemoryImage(fileBytes);
//
//       showMessage("Success", "Profile image updated successfully.");
//     } catch (e) {
//       showMessage("Error", "Failed to update profile image: $e");
//     }
//   }
//
//   void changeTab(String tab) {
//     selectedTab.value = tab;
//     fetchAds();
//   }
//
//   void fetchAds() async {
//     final query = FirebaseFirestore.instance.collection('ads');
//     final snapshot = await query.where('authId', isEqualTo: authId).get();
//
//     final filtered = snapshot.docs
//         .where((doc) {
//           final status = doc['status'] ?? '';
//           if (selectedTab.value == 'All') return true;
//           return status == selectedTab.value;
//         })
//         .map((doc) => doc.data())
//         .toList();
//
//     ads.value = filtered;
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/colors.dart';
import '../../../widgets/show_message_widget.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  final userData = Rxn<Map<String, dynamic>>();
  final profileImageProvider = Rxn<ImageProvider>();

  final isEditing = false.obs;
  RxBool isLoading = true.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  RxString selectedTab = 'All'.obs;
  RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;

  String? authId;

  @override
  void onInit() {
    super.onInit();
    authId = supabase.auth.currentUser?.id;
    listenToUserData();
    // fetchAds();
  }

  Future<void> listenToUserData() async {
    if (authId == null) return;

    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('user_id', authId!)
          .maybeSingle();

      final data = response;
      if (data != null) {
        userData.value = data;

        // Populate controllers
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';

        // Load profile image
        final imagePath = data['profile_image'] as String?;
        if (imagePath != null && imagePath.isNotEmpty) {
          final imageUrl = supabase.storage.from('profile_images').getPublicUrl(imagePath);
          profileImageProvider.value = NetworkImage(imageUrl);
        } else {
          profileImageProvider.value = const AssetImage(
            "assets/images/ProfileImage.png",
          );
        }
      }
    } catch (e) {
      showMessage('Error', 'Failed to fetch user data: $e');
    }
  }

  Future<void> updateUserData(Map<String, dynamic> newData) async {
    if (authId == null) return;

    try {
      // Update Supabase users table
      await supabase
          .from('users')
          .update(newData)
          .eq('user_id', authId!);

      // Handle email update
      if (newData.containsKey('email') && newData['email'] != supabase.auth.currentUser?.email) {
        final res = await supabase.auth.updateUser(
          UserAttributes(email: newData['email']),
        );

        if (res.user != null) {
          showMessage('Success', 'Email updated. Please verify your new email.');
          await supabase.auth.signOut();
          Get.offAllNamed('/loginEmail');
          return;
        }
      }

      showMessage('Success', 'Profile updated successfully.');
      listenToUserData(); // Refresh
    } catch (e) {
      showMessage('Error', 'Failed to update profile: $e');
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAllNamed('/authentication');
  }

  Future<void> pickAndUploadProfileImage() async {
    if (authId == null) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final fileBytes = result.files.first.bytes;
      final fileName = '${authId}_${DateTime.now().millisecondsSinceEpoch}.png';

      if (fileBytes == null) {
        showMessage('Error', 'Failed to get image data.');
        return;
      }

      // Upload to Supabase storage
      await supabase.storage.from('profile_images').uploadBinary(fileName, Uint8List.fromList(fileBytes));

      // Update users table with image path
      await supabase.from('users').update({'profile_image': fileName}).eq('user_id', authId!);

      final imageUrl = supabase.storage.from('profile_images').getPublicUrl(fileName);
      profileImageProvider.value = NetworkImage(imageUrl);

      showMessage('Success', 'Profile image updated successfully.');
    } catch (e) {
      showMessage('Error', 'Failed to update profile image: $e');
    }
  }

}

