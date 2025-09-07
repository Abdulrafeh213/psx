// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../constants/apis.dart';
//
// class SellController extends GetxController {
//   final title = ''.obs;
//   final description = ''.obs;
//   final condition = ''.obs;
//   final rating = 1.obs;
//   final warranty = ''.obs;
//   final price = 0.0.obs;
//   final location = Rxn<Map<String, dynamic>>();
//   final categoryId = ''.obs;
//   final pickedImagePath = ''.obs;
//   var categories = <Map<String, dynamic>>[].obs;
//
//   final phoneNumber = ''.obs;
//
//   final formKey = GlobalKey<FormState>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategories();
//     fetchUserPhone();
//   }
//
//   Future<void> fetchCategories() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection("categories")
//         .get();
//     categories.value = snapshot.docs
//         .map((doc) => {"id": doc.id, "category": doc['category'] ?? "category"})
//         .toList();
//     print("Fetched categories: ${categories.value}");
//   }
//
//   Future<void> fetchUserPhone() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     final doc = await FirebaseFirestore.instance
//         .collection("users")
//         .doc(uid)
//         .get();
//     phoneNumber.value = doc.data()?['phone'] ?? '';
//   }
//
//   Future<void> pickImage() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       withData: false, // Don't need bytes, just the file path
//     );
//
//     if (result != null && result.files.isNotEmpty) {
//       final path = result.files.first.path;
//       if (path != null) {
//         pickedImagePath.value = path;
//       }
//     }
//   }
//
//   Future<String?> uploadImageToGoogleDrive(
//     String filePath,
//     String fileName,
//   ) async {
//     final file = File(filePath);
//     final uri = Uri.parse(ApiEndpoints.imageUrl);
//
//     final request = http.MultipartRequest('POST', uri)
//       ..fields['name'] = fileName
//       ..headers.addAll({
//         'Authorization':
//             'Bearer 895249592534-tfqf191poaivhr2p0653vhiukcdhapbp.apps.googleusercontent.com',
//       })
//       ..files.add(await http.MultipartFile.fromPath('file', file.path));
//
//     final response = await request.send();
//
//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final fileId = jsonDecode(responseBody)['id'];
//       return "https://drive.google.com/uc?export=view&id=$fileId";
//     } else {
//       print('Drive upload failed: ${response.statusCode}');
//       return null;
//     }
//   }
//
//   Future<void> submitAd() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     String? imageUrl;
//
//     if (pickedImagePath.value.isNotEmpty) {
//       final fileName = "ad_${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
//       imageUrl = await uploadImageToGoogleDrive(
//         pickedImagePath.value,
//         fileName,
//       );
//     }
//
//     await FirebaseFirestore.instance.collection("ads").add({
//       "title": title.value,
//       "description": description.value,
//       "rating": rating.value,
//       "condition": condition.value,
//       "warranty": warranty.value,
//       "price": price.value,
//       "location": location.value,
//       "categoryId": categoryId.value,
//       "imageUrl": imageUrl, // Store Drive link
//       "authId": uid,
//       "status": 'pending',
//       "adType": 'sell',
//       "phone": phoneNumber.value,
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//
//     Get.offAllNamed('/home');
//   }
//
//   Future<void> fetchLiveLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//
//     if (!serviceEnabled) {
//       await showLocationEnableDialog();
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//
//       if (permission == LocationPermission.denied) {
//         showMessage("Location Error", "Location permission denied.");
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       await showLocationEnableDialog();
//       return;
//     }
//
//     try {
//       // Get coordinates
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       // Get place name using reverse geocoding
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//
//         String address =
//             "${place.locality}, ${place.administrativeArea}, ${place.country}";
//
//         location.value = {
//           'name': address,
//           'lat': position.latitude,
//           'lng': position.longitude,
//         };
//
//         showMessage("Success", "Location: $address");
//       } else {
//         showMessage("Error", "Failed to get location name");
//       }
//     } catch (e) {
//       showMessage("Error", "Failed to fetch location: $e");
//     }
//   }
//
//   void setManualLocation(String name) {
//     location.value = {'name': name};
//     Get.back();
//   }
//
//   Future<void> showLocationEnableDialog() async {
//     await Get.dialog(
//       AlertDialog(
//         title: const Text("Location Disabled"),
//         content: const Text(
//           "Your device location is turned off.\n\nPlease turn it on to continue.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await Geolocator.openLocationSettings(); // open settings page
//               Get.back();
//             },
//             child: const Text("Go to Settings"),
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   }
// }

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../widgets/show_message_widget.dart';
import 'dart:convert';


import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;




class SellController extends GetxController {
  final supabase = Supabase.instance.client;






  final name = ''.obs;
  final description = ''.obs;
  final price = 0.0.obs;
  final condition = ''.obs;
  final warranty = ''.obs;

  final sellerRating = 1.obs;
  final avgUserRating = 0.0.obs;
  final totalReviews = 0.obs;
  final categoryId = ''.obs;
  final isLoading = false.obs;


  final location = Rxn<Map<String, dynamic>>(); // {name, lat, lng}
  final phoneNumber = ''.obs;
  final pickedImagePath = ''.obs;
  final locationController = TextEditingController();
  var categories = <Map<String, dynamic>>[].obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchUserPhone();
  }

  @override
  void onClose() {
    locationController.dispose();
    super.onClose();
  }

  /// Fetch user's phone from Supabase
  Future<void> fetchUserPhone() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await supabase
          .from('users')
          .select('phone')
          .eq('user_id', userId)
          .single();

      if (response != null && response['phone'] != null) {
        phoneNumber.value = response['phone'];
      }
    } catch (e) {
      print('Error fetching phone: $e');
    }
  }

  /// Fetch categories
  Future<void> fetchCategories() async {
    final response = await supabase.from('categories').select();
    final data = response as List<dynamic>;
    categories.value = data
        .map((cat) => {
      'id': cat['id'].toString(),
      'category_name': cat['category_name'] ?? 'category_name',
    })
        .toList();
  }


  // /// Pick image (allow all image formats)
  // Future<void> pickImage() async {
  //   final result = await FilePicker.platform.pickFiles(type: FileType.image);
  //   if (result != null && result.files.isNotEmpty) {
  //     pickedImagePath.value = result.files.first.path ?? '';
  //   }
  // }
  //
  // /// Upload image to Supabase storage
  // Future<String?> uploadImageToStorage(String path) async {
  //   try {
  //     final file = File(path);
  //     final ext = path.split('.').last.toLowerCase();
  //
  //     // Validate extension to be an image format (optional, you can skip this if you want)
  //     final allowedExt = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
  //     if (!allowedExt.contains(ext)) {
  //       print('❌ Unsupported image format');
  //       return null;
  //     }
  //
  //     final fileName = 'ad_${DateTime.now().millisecondsSinceEpoch}.$ext';
  //
  //     await supabase.storage.from('products').upload(fileName, file);
  //
  //     final publicUrl = supabase.storage.from('products').getPublicUrl(fileName);
  //     return publicUrl;
  //   } catch (e) {
  //     print('Upload exception: $e');
  //     return null;
  //   }
  // }

  /// Pick an image
  Future<void> pickImage(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      pickedImagePath.value = result.files.single.path!;
    } else {
      showMessage("Error", "Failed to load image.");
    }
  }

  /// Upload image to Supabase storage and return public URL
  Future<String?> uploadImageToStorage(
      String filePath,
      String fileName,
      ) async {
    try {
      final file = File(filePath);

      await supabase.storage
          .from('products')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      // Get public URL
      final imageUrl = supabase.storage
          .from('products')
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      showMessage("Error", "Image upload failed: $e");
      return null;
    }
  }

  /// Submit Ad only if image is picked and valid

   Future<void> submitAd(BuildContext context) async {

     final userId = supabase.auth.currentUser?.id;
     if (userId == null) {
       print('User not logged in');
       return;
     }
      // Safe validation
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }

      if (pickedImagePath.value.isEmpty) {
        showMessage("Error", "Please select an image.");
        return;
      }

      isLoading.value = true;

      try {
        final extension = path.extension(pickedImagePath.value); // .jpg/.png
        final fileName =
            "products_${DateTime.now().millisecondsSinceEpoch}$extension";

        final imageUrl = await uploadImageToStorage(
          pickedImagePath.value,
          fileName,
        );

        if (imageUrl == null) return;

        // Insert products into Supabase "categories" table
        await supabase.from('products').insert({
          "seller_id": userId,
          "name": name.value,
          "description": description.value,
          "price": price.value,
          "seller_rating": sellerRating.value,
          "average_user_rating": avgUserRating.value,
          "total_reviews": totalReviews.value,
          "condition": condition.value,
          "warranty": warranty.value,
          "ads_status": 'pending',
          "full_address": location.value?['full_address'] ?? '',
          "latitude": location.value?['latitude'],
          "longitude": location.value?['longitude'],
          "category_id": categoryId.value,
          "image_url": imageUrl,
          "created_at": DateTime.now().toIso8601String(),
        });

        showMessage("Success", "Product posted successfully");
        Get.offAllNamed('/ads');
      } catch (e) {
        showMessage("Error", "Failed to post ad: $e");
      }
    }
  // Future<void> submitAd() async {
  //   final userId = supabase.auth.currentUser?.id;
  //   if (userId == null) {
  //     print('User not logged in');
  //     return;
  //   }
  //
  //   if (pickedImagePath.value.isEmpty) {
  //     Get.snackbar('Error', 'Please pick an image before submitting');
  //     return; // Don't submit if image is not picked
  //   }
  //
  //   // Upload picked image
  //   final imageUrl = await uploadImageToStorage(pickedImagePath.value);
  //
  //   if (imageUrl == null || imageUrl.isEmpty) {
  //     Get.snackbar('Error', 'Failed to upload image. Please try again.');
  //     return; // Don't submit if upload failed
  //   }
  //
  //   try {
  //     await supabase.from('products').insert({
  //       "seller_id": userId,
  //       "name": name.value,
  //       "description": description.value,
  //       "price": price.value,
  //       "seller_rating": sellerRating.value,
  //       "average_user_rating": avgUserRating.value,
  //       "total_reviews": totalReviews.value,
  //       "condition": condition.value,
  //       "warranty": warranty.value,
  //       "ads_status": 'pending',
  //       "full_address": location.value?['full_address'] ?? '',
  //       "latitude": location.value?['latitude'],
  //       "longitude": location.value?['longitude'],
  //       "category_id": categoryId.value,
  //       "image_url": imageUrl,
  //       "created_at": DateTime.now().toIso8601String(),
  //     });
  //
  //     Get.snackbar('Success', 'Product posted successfully');
  //     Get.offAllNamed('/ads');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to post ad: $e');
  //   }
  // }


  // /// Pick image
  // Future<void> pickImage() async {
  //   final result = await FilePicker.platform.pickFiles(type: FileType.image);
  //   if (result != null && result.files.isNotEmpty) {
  //     pickedImagePath.value = result.files.first.path ?? '';
  //   }
  // }
  //
  // /// Upload image
  // Future<String?> uploadImageToStorage(String path) async {
  //   try {
  //     final file = File(path);
  //     final ext = path.split('.').last;
  //     final fileName = 'ad_${DateTime.now().millisecondsSinceEpoch}.$ext';
  //
  //     await supabase.storage.from('products').upload(fileName, file);
  //
  //     final publicUrl =
  //     supabase.storage.from('products').getPublicUrl(fileName);
  //     return publicUrl;
  //   } catch (e) {
  //     print('Upload exception: $e');
  //     return null;
  //   }
  // }
  //
  // /// Submit Ad
  // Future<void> submitAd() async {
  //   final userId = supabase.auth.currentUser?.id;
  //   if (userId == null) return;
  //
  //   String? imageUrl;
  //
  //   if (pickedImagePath.value.isNotEmpty) {
  //     // Upload picked image
  //     imageUrl = await uploadImageToStorage(pickedImagePath.value);
  //   } else {
  //     // Use pre-stored bucket image if no image selected
  //     imageUrl =
  //     "https://jzotfyxetsyliprlbvxh.supabase.co/storage/v1/object/public/products/pngtree-shiny-and-powerful-best-glossy-laptop-png-image_15763174.png";
  //   }
  //
  //   try {
  //     await supabase.from('products').insert({
  //       "seller_id": userId,
  //       "name": name.value,
  //       "description": description.value,
  //       "price": price.value,
  //       "seller_rating": sellerRating.value,
  //       "average_user_rating": avgUserRating.value,
  //       "total_reviews": totalReviews.value,
  //       "condition": condition.value,
  //       "warranty": warranty.value,
  //       "ads_status": 'pending',
  //       "full_address": location.value?['full_address'] ?? '',
  //       "latitude": location.value?['latitude'],
  //       "longitude": location.value?['longitude'],
  //       "category_id": categoryId.value,
  //       "image_url": imageUrl,
  //       "created_at": DateTime.now().toIso8601String(),
  //     });
  //
  //     showMessage("Success", "Product posted successfully");
  //     Get.offAllNamed('/ads');
  //   } catch (e) {
  //     showMessage("Error", "Failed to post ad: $e");
  //   }
  // }
  //



  /// Fetch live location
  Future<void> fetchLiveLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await showLocationEnableDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showMessage("Location Error", "Location permission denied.");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await showLocationEnableDialog();
      return;
    }

    try {
      Position position =
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final fullAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";

        location.value = {
          'full_address': fullAddress,
          'latitude': position.latitude,
          'longitude': position.longitude
        };
        locationController.text = fullAddress;

        showMessage("Success", "Location fetched!");
      }
    } catch (e) {
      showMessage("Error", "Failed to fetch location: $e");
    }
  }

  /// Manual location
  void setManualLocation(String name) {
    location.value = {'full_address': name};
    locationController.text = name;
  }

  Future<void> showLocationEnableDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text("Location Disabled"),
        content: const Text(
          "Your device location is turned off.\n\nPlease turn it on to continue.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              Get.back();
            },
            child: const Text("Go to Settings"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
