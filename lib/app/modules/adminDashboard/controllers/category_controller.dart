// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mime/mime.dart';
// import 'package:path/path.dart' as path;
//
// import '../../../widgets/show_message_widget.dart';
//
// class CategoryFormController extends GetxController {
//   final formKey = GlobalKey<FormState>();
//
//   final categoryName = ''.obs;
//   final pickedImagePath = ''.obs;
//   final isLoading = false.obs;
//
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//       'https://www.googleapis.com/auth/drive.file',
//     ],
//   );
//
//   /// Pick an image
//   Future<void> pickImageFile(BuildContext context) async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       withData: false,
//     );
//
//     if (result != null && result.files.single.path != null) {
//       pickedImagePath.value = result.files.single.path!;
//     } else {
//       showMessage("Error", "Failed to load image.");
//     }
//   }
//
//   /// Get access token from Google Sign-In
//   Future<String?> getAccessToken() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       if (account == null) return null;
//
//       final auth = await account.authentication;
//       return auth.accessToken;
//     } catch (e) {
//       print("Google Sign-In error: $e");
//       return null;
//     }
//   }
//
//   /// Upload image to Google Drive and return viewable URL
//   Future<String?> uploadImageToGoogleDrive(String filePath, String fileName) async {
//     final accessToken = await getAccessToken();
//     if (accessToken == null) {
//       showMessage("Error", "Google Sign-In failed.");
//       return null;
//     }
//
//     final file = File(filePath);
//     final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
//
//     final metadata = {
//       'name': fileName,
//     };
//
//     final uri = Uri.parse('https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart');
//
//     final request = http.MultipartRequest('POST', uri)
//       ..headers['Authorization'] = 'Bearer $accessToken'
//       ..fields['metadata'] = jsonEncode(metadata)
//     // Note: contentType omitted here to avoid MediaType dependency
//       ..files.add(await http.MultipartFile.fromPath('file', file.path));
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       final fileId = responseData['id'];
//
//       // Make the file publicly viewable
//       final permissionUri = Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId/permissions');
//       final permissionResponse = await http.post(
//         permissionUri,
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'role': 'reader',
//           'type': 'anyone',
//         }),
//       );
//
//       if (permissionResponse.statusCode == 200) {
//         return "https://drive.google.com/uc?export=view&id=$fileId";
//       } else {
//         print("Failed to make file public: ${permissionResponse.body}");
//       }
//     } else {
//       print("Upload failed: ${response.body}");
//     }
//
//     return null;
//   }
//
//   /// Submit form to Firestore
//   Future<void> submitForm(BuildContext context) async {
//     if (!formKey.currentState!.validate()) return;
//
//     if (pickedImagePath.value.isEmpty) {
//       showMessage("Error", "Please select an image.");
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       final extension = path.extension(pickedImagePath.value); // .jpg/.png
//       final fileName = "category_${DateTime.now().millisecondsSinceEpoch}$extension";
//
//       final imageUrl = await uploadImageToGoogleDrive(pickedImagePath.value, fileName);
//
//       if (imageUrl == null) {
//         showMessage("Error", "Image upload failed.");
//         return;
//       }
//
//       await FirebaseFirestore.instance.collection('categories').add({
//         'category': categoryName.value.trim(),
//         'imageUrl': imageUrl,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       showMessage("Success", "Category added successfully");
//
//       // Clear form
//       categoryName.value = '';
//       pickedImagePath.value = '';
//     } catch (e) {
//       showMessage("Error", "Something went wrong: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../widgets/show_message_widget.dart';


class CategoryFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final categoryName = ''.obs;
  final pickedImagePath = ''.obs;
  final isLoading = false.obs;

  final supabase = Supabase.instance.client;

  /// Pick an image
  Future<void> pickImageFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      pickedImagePath.value = result.files.single.path!;
    } else {
      showMessage("Error", "Failed to load image.");
    }
  }

  /// Upload image to Supabase storage and return public URL
  Future<String?> uploadImageToSupabase(
    String filePath,
    String fileName,
  ) async {
    try {
      final file = File(filePath);

      await supabase.storage
          .from('categories')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      // Get public URL
      final imageUrl = supabase.storage
          .from('categories')
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      showMessage("Error", "Image upload failed: $e");
      return null;
    }
  }

  /// Submit form to Supabase
  Future<void> submitForm(BuildContext context) async {
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
          "category_${DateTime.now().millisecondsSinceEpoch}$extension";

      final imageUrl = await uploadImageToSupabase(
        pickedImagePath.value,
        fileName,
      );

      if (imageUrl == null) return;

      // Insert category into Supabase "categories" table
      await supabase.from('categories').insert({
        'category_name': categoryName.value.trim(),
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      showMessage("Success", "Category added successfully");

      // Clear form
      categoryName.value = '';
      pickedImagePath.value = '';
    } catch (e) {
      showMessage("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
