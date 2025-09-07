// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:location/location.dart' hide LocationAccuracy;
// import 'dart:async';
// import 'package:geocoding/geocoding.dart' hide Location;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// import '../../../widgets/show_message_widget.dart';
//
// class AuthenticationController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Form fields
//   final name = ''.obs;
//   final email = ''.obs;
//   final number = ''.obs;
//   final password = ''.obs;
//   final confirmPassword = ''.obs;
//   final otpCode = ''.obs;
//   var isPasswordHidden = true.obs;
//
//   // UI State
//   final isLoading = false.obs;
//   final isVerifying = false.obs;
//   final isFetchingLocation = false.obs;
//
//   // Form keys
//   final formKey = GlobalKey<FormState>();
//   final otpFormKey = GlobalKey<FormState>();
//
//   // Input handling
//   final passwordController = TextEditingController();
//   final phoneController = TextEditingController();
//   final loginInput = ''.obs;
//   final RxString location = ''.obs;
//
//   // Country code
//   final selectedCountryDialCode = '+92'.obs;
//   final selectedCountryCode = 'PK'.obs;
//
//   // OTP fields
//   final otpControllers = List.generate(6, (_) => TextEditingController());
//   final otpFocusNodes = List.generate(6, (_) => FocusNode());
//
//   // For both signup/login OTP
//   String? verificationId;
//
//   // For sign up temp storage
//   late String _localName;
//   late String _localEmail;
//   late String _localNumber;
//   late String _localPassword;
//   late String _finalPhoneNumber;
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadUserLocation();
//
//
//   }
//
//   // -------------------- Country Code Handler --------------------
//   void onCountryCodeChanged(String dialCode) {
//     selectedCountryDialCode.value = dialCode;
//   }
//
//   // OTP input handler
//   void onOtpChanged(String value, int index) {
//     if (value.isNotEmpty && index < 5) {
//       otpFocusNodes[index + 1].requestFocus();
//     } else if (value.isEmpty && index > 0) {
//       otpFocusNodes[index - 1].requestFocus();
//     }
//     otpCode.value = otpControllers.map((c) => c.text).join();
//   }
//
//   void setEmailOrPhone(String value) {
//     loginInput.value = value.trim();
//   }
// //------------- SIGNUP CODE -------------------
//   Future<void> onSignupPressed() async {
//     if (!(formKey.currentState?.validate() ?? false)) return;
//
//     if (password.value != confirmPassword.value) {
//       showMessage("Error", "Passwords do not match");
//       return;
//     }
//
//     _localName = name.value.trim();
//     _localEmail = email.value.trim();
//     _localNumber = number.value.trim();
//     _localPassword = password.value;
//     _finalPhoneNumber = '${selectedCountryDialCode.value}$_localNumber';
//
//     isLoading.value = true;
//
//     try {
//       // Create user with email and password
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: _localEmail,
//         password: _localPassword,
//       );
//
//       final uid = userCredential.user?.uid;
//       if (uid == null) throw Exception("User UID is null after signup");
//
//       // Load default profile image
//       ByteData byteData = await rootBundle.load('assets/images/ProfileImage.png');
//       Uint8List imageBytes = byteData.buffer.asUint8List();
//       String base64Image = base64Encode(imageBytes);
//
//       // Save user details to Firestore
//       await _firestore.collection('users').doc(uid).set({
//         'userId': uid,
//         'name': _localName,
//         'email': _localEmail,
//         'phone': _finalPhoneNumber,
//         'location': '',
//         'userRole': 'user',
//         'userStatus': 'active',
//         'profileImage': base64Image,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       print('Signup successful. Navigating to /location');
//
//       // Ensure navigation completes before continuing
//       await Get.toNamed('/location');
//       print('Navigation to /location completed');
//
//     } on FirebaseAuthException catch (e) {
//       showMessage("Signup Failed", e.message ?? "Unable to create account");
//     } catch (e) {
//       showMessage("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//
//
//
//   Future<void> sendPasswordResetEmail() async {
//     if (email.value.isEmpty) {
//       showMessage("Error", "Please enter your registered email.");
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       await _auth.sendPasswordResetEmail(email: email.value);
//       showMessage("Success", "Password reset link sent to ${email.value}");
//       // Clear the email after sending
//       email.value = '';
//     } on FirebaseAuthException catch (e) {
//       showMessage("Error", e.message ?? "Failed to send reset link.");
//     } catch (e) {
//       showMessage("Error", "Something went wrong.");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Future<void> onSignupPressed() async {
//   //   if (!formKey.currentState!.validate()) return;
//   //
//   //   if (password.value != confirmPassword.value) {
//   //     showMessage("Error", "Passwords do not match");
//   //     return;
//   //   }
//   //
//   //   _localName = name.value.trim();
//   //   _localEmail = email.value.trim();
//   //   _localNumber = number.value.trim();
//   //   _localPassword = password.value;
//   //   _finalPhoneNumber = '${selectedCountryDialCode.value}$_localNumber';
//   //
//   //   isLoading.value = true;
//   //
//   //   try {
//   //     /*
//   //     await _auth.verifyPhoneNumber(
//   //       phoneNumber: _finalPhoneNumber,
//   //       timeout: const Duration(seconds: 60),
//   //       verificationCompleted: (PhoneAuthCredential credential) {},
//   //       verificationFailed: (FirebaseAuthException e) {
//   //         showMessage("OTP Failed", e.message ?? "Phone verification error");
//   //       },
//   //       codeSent: (String verId, int? resendToken) {
//   //         verificationId = verId;
//   //         Get.toNamed('/otp_verification'); // signup OTP screen
//   //       },
//   //       codeAutoRetrievalTimeout: (String verId) {
//   //         verificationId = verId;
//   //       },
//   //     );
//   //     */
//   //   } catch (e) {
//   //     showMessage("Error", e.toString());
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//
//   // Future<void> verifyOtpAndRegister() async {
//   //   /*
//   //   if (!otpFormKey.currentState!.validate()) return;
//   //
//   //   final code = otpControllers.map((c) => c.text).join();
//   //   if (code.length != 6) {
//   //     showMessage("Invalid OTP", "Please enter the 6-digit code.");
//   //     return;
//   //   }
//   //
//   //   isVerifying.value = true;
//   //
//   //   try {
//   //     final credential = PhoneAuthProvider.credential(
//   //       verificationId: verificationId!,
//   //       smsCode: code,
//   //     );
//   //
//   //     await _auth.signInWithCredential(credential);
//   //   */
//   //   final userCredential = await _auth.createUserWithEmailAndPassword(
//   //     email: _localEmail,
//   //     password: _localPassword,
//   //   );
//   //
//   //   await _firestore.collection('users').doc(userCredential.user!.uid).set({
//   //     'name': _localName,
//   //     'email': _localEmail,
//   //     'phone': _finalPhoneNumber,
//   //     'createdAt': FieldValue.serverTimestamp(),
//   //   });
//   //
//   //   Get.offAllNamed('/location');
//   //   /*
//   //   } on FirebaseAuthException catch (e) {
//   //     showMessage("Verification Failed", e.message ?? "Invalid OTP");
//   //   } catch (e) {
//   //     showMessage("Error", e.toString());
//   //   } finally {
//   //     isVerifying.value = false;
//   //   }
//   //   */
//   // }
//
//   // -------------------- LOGIN FLOW --------------------
//   Future<void> loginWithDynamicMethod() async {
//     final passwordVal = passwordController.text.trim();
//     if (loginInput.value.isEmpty || passwordVal.isEmpty) {
//       showMessage("Error", "Please enter all required fields.");
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       if (GetUtils.isEmail(loginInput.value)) {
//         await loginWithEmail(loginInput.value, passwordVal);
//       } else {
//         await loginWithPhone(loginInput.value);
//       }
//     } catch (e) {
//       showMessage("Login Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> loginWithEmail(String email, String password) async {
//     try {
//       // Step 1: Sign in with email and password
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Step 2: Fetch user data from Firestore using UID
//       final uid = userCredential.user?.uid;
//       if (uid == null) {
//         showMessage("Login Failed", "User UID is null.");
//         return;
//       }
//
//       final userDoc = await _firestore.collection('users').doc(uid).get();
//       if (!userDoc.exists) {
//         showMessage("Login Failed", "User data not found.");
//         return;
//       }
//
//       final userData = userDoc.data()!;
//       final userRole = userData['userRole'] ?? 'user';
//       final userStatus = userData['userStatus'] ?? 'inactive';
//
//       // Step 3: Check if the user status is active
//       if (userStatus != 'active') {
//         showMessage("Account Suspended", "Your account has been suspended by the admin.");
//         return;
//       }
//
//       // Step 4: Navigate based on user role
//       if (userRole == 'admin') {
//         // Don't navigate immediately to the admin panel, you can add extra steps or checks here if needed
//         Get.offAllNamed('/adminDashboard');
//         // showMessage("Login Successful", "Welcome, Admin. Proceed to the admin dashboard.");
//         // If you want to navigate later, you can call Get.offAllNamed('/adminDashboard') after some processing
//       } else {
//         // Navigate to the regular user dashboard
//         Get.offAllNamed('/home');
//       }
//
//       // Step 5: After navigation, handle location updates
//       Future.delayed(Duration(milliseconds: 500), () async {
//         try {
//           final locationData = await _getCurrentLocation();
//
//           if (locationData != null) {
//             final placeName = await _getPlaceNameFromCoordinates(
//               locationData.latitude!,
//               locationData.longitude!,
//             );
//
//             await _saveUserLocationToFirestore(
//               latitude: locationData.latitude!,
//               longitude: locationData.longitude!,
//               placeName: placeName,
//             );
//           }
//         } catch (e) {
//           // Fail silently - do not update if location fails
//         }
//
//         // Load user location from Firestore (new or existing)
//         await loadUserLocation();
//       });
//     } on FirebaseAuthException catch (e) {
//       showMessage("Login Failed", e.message ?? "Invalid credentials");
//     } catch (e) {
//       showMessage("Login Failed", "An unexpected error occurred");
//     }
//   }
//
//
//
//   // Returns current location or null if not available
//   Future<LocationData?> _getCurrentLocation() async {
//     try {
//       Location location = Location();
//
//       // No need to check service or permission status
//       return await location.getLocation();
//     } catch (e) {
//       // Location not available or error occurred
//       return null;
//     }
//   }
//
// // Converts lat/lng to a human-readable place name
//   Future<String> _getPlaceNameFromCoordinates(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         return "${place.locality}, ${place.country}";
//       }
//       return "Unknown Location";
//     } catch (e) {
//       return "Unknown Location";
//     }
//   }
//
// // Save to Firestore or wherever you keep user location
//   Future<void> _saveUserLocationToFirestore({
//     required double latitude,
//     required double longitude,
//     required String placeName,
//   }) async {
//     final uid = _auth.currentUser?.uid;
//     if (uid == null) return;
//
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
//       'location': {
//         'latitude': latitude,
//         'longitude': longitude,
//         'placeName': placeName,
//         'updatedAt': FieldValue.serverTimestamp(),
//       },
//     });
//   }
//
//
//
//   Future<void> loadUserLocation() async {
//     final user = FirebaseAuth.instance.currentUser;
//
//     if (user == null) {
//       location.value = 'User not logged in';
//       return;
//     }
//
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get()
//           .timeout(const Duration(seconds: 5), onTimeout: () {
//         throw TimeoutException("Firestore fetch timed out");
//       });
//
//       if (!doc.exists) {
//         location.value = 'Location not found';
//         return;
//       }
//
//       final data = doc.data();
//       if (data == null || data['location'] == null) {
//         location.value = 'No location saved';
//         return;
//       }
//
//       final locationData = data['location'];
//
//       if (locationData is Map && locationData['place'] is String) {
//         location.value = locationData['place'];
//       } else {
//         location.value = 'Invalid location format';
//       }
//
//       print("👤 Firebase user: ${user.uid}");
//       print("📦 Firestore doc exists: ${doc.exists}");
//       print("📍 Location data: $locationData");
//       print("✅ Location string: ${location.value}");
//
//     } on TimeoutException {
//       location.value = 'No internet connection';
//     } catch (e) {
//       location.value = 'Error loading location';
//       print("Error loading location: $e");
//     }
//   }
//
//
//   Future<bool> _checkLocationPermissionAndService() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return false;
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return false;
//     }
//
//     if (permission == LocationPermission.deniedForever) return false;
//
//     return true;
//   }
//
//   Future<void> _updateCurrentLocationOnce() async {
//     final position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     final placeName = await _getPlaceName(
//       position.latitude,
//       position.longitude,
//     );
//
//     final uid = _auth.currentUser?.uid;
//     if (uid == null) return;
//
//     await _firestore.collection('users').doc(uid).update({
//       'location': {
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//         'placeName': placeName,
//         'timestamp': FieldValue.serverTimestamp(),
//       },
//     });
//   }
//
//   Future<String> _getPlaceName(double lat, double lng) async {
//     try {
//       final placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         // Customize this string as you want
//         return '${place.locality ?? ''}, ${place.country ?? ''}'
//             .trim()
//             .replaceAll(RegExp(r'(^,)|(,$)'), '');
//       }
//       return 'Unknown Location';
//     } catch (e) {
//       return 'Unknown Location';
//     }
//   }
//
//   // Future<void> _loginWithEmail(String email, String password) async {
//   //   try {
//   //     await _auth.signInWithEmailAndPassword(email: email, password: password);
//   //     // await checkUserLocationAndNavigate();
//   //     Get.offAllNamed('/location');
//   //   } on FirebaseAuthException catch (e) {
//   //     showMessage("Login Failed", e.message ?? "Invalid credentials");
//   //   }
//   // }
//
//   Future<void> loginWithPhone(String phone) async {
//     final fullPhone = '${selectedCountryDialCode.value}$phone';
//
//     try {
//       // Check if phone exists in users collection
//       final snapshot = await _firestore
//           .collection('users')
//           .where('phone', isEqualTo: fullPhone)
//           .limit(1)
//           .get();
//
//       if (snapshot.docs.isEmpty) {
//         // Phone not registered -> navigate to signup
//         Get.toNamed('/singupEmail');
//         return;
//       }
//
//       // Send OTP for registered phone
//       await _auth.verifyPhoneNumber(
//         phoneNumber: fullPhone,
//         timeout: const Duration(seconds: 60),
//
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // Auto sign-in on Android if SMS auto-detected
//           await _auth.signInWithCredential(credential);
//
//           bool locationOk = await _checkLocationPermissionAndService();
//           if (!locationOk) {
//             await Get.defaultDialog(
//               title: 'Location Required',
//               middleText:
//                   'Please enable location services and grant permission.',
//               onConfirm: () => Get.back(),
//               textConfirm: 'OK',
//             );
//             return;
//           }
//
//           await _updateCurrentLocationOnce();
//
//           Get.offAllNamed('/home');
//         },
//
//         verificationFailed: (FirebaseAuthException e) {
//           showMessage(
//             "Verification Failed",
//             e.message ?? "Could not send verification code.",
//           );
//         },
//
//         codeSent: (String verId, int? resendToken) {
//           verificationId = verId;
//           Get.toNamed(
//             '/otp',
//             arguments: {'verificationId': verId, 'phone': fullPhone},
//           );
//         },
//
//         codeAutoRetrievalTimeout: (String verId) {
//           verificationId = verId;
//         },
//       );
//     } catch (e) {
//       showMessage("Error", e.toString());
//     }
//   }
//
//   Future<void> verifyOtpAndLogin(String smsCode) async {
//     /*
//     if (verificationId == null) {
//       showMessage("Error", "Missing verification ID.");
//       return;
//     }
//
//     isVerifying.value = true;
//
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: verificationId!,
//         smsCode: smsCode,
//       );
//
//       await _auth.signInWithCredential(credential);
//
//       await checkUserLocationAndNavigate();
//     } catch (e) {
//       showMessage("OTP Error", e.toString());
//     } finally {
//       isVerifying.value = false;
//     }
//     */
//   }
//
//   // -------------------- Location Handling --------------------
//   // Future<void> checkUserLocationAndNavigate() async {
//   //   final locationService = Location();
//   //
//   //   bool serviceEnabled = await locationService.serviceEnabled();
//   //   if (!serviceEnabled) {
//   //     serviceEnabled = await locationService.requestService();
//   //     if (!serviceEnabled) {
//   //       Get.offAllNamed('/location');
//   //       return;
//   //     }
//   //   }
//   //
//   //   PermissionStatus permission = await locationService.hasPermission();
//   //   if (permission == PermissionStatus.denied) {
//   //     permission = await locationService.requestPermission();
//   //     if (permission != PermissionStatus.granted) {
//   //       Get.offAllNamed('/location');
//   //       return;
//   //     }
//   //   }
//   //
//   //   final currentUser = _auth.currentUser;
//   //   if (currentUser == null) {
//   //     showMessage("Error", "No user is logged in.");
//   //     return;
//   //   }
//   //
//   //   final userSnapshot = await _firestore
//   //       .collection('users')
//   //       .where('email', isEqualTo: currentUser.email)
//   //       .where('phone', isEqualTo: currentUser.phoneNumber)
//   //       .limit(1)
//   //       .get();
//   //
//   //   if (userSnapshot.docs.isEmpty ||
//   //       !(userSnapshot.docs.first.data().containsKey('location'))) {
//   //     Get.offAllNamed('/location');
//   //   } else {
//   //     Get.offAllNamed('/home');
//   //   }
//   // }
//
//   Future<void> storeUserLocation() async {
//     final location = Location();
//
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }
//
//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }
//
//     final locationData = await location.getLocation();
//
//     final user = _auth.currentUser;
//     if (user != null) {
//       final userDoc = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: user.email)
//           .where('phone', isEqualTo: user.phoneNumber)
//           .limit(1)
//           .get();
//
//       if (userDoc.docs.isNotEmpty) {
//         final docId = userDoc.docs.first.id;
//         await _firestore.collection('users').doc(docId).update({
//           'location': {
//             'lat': locationData.latitude,
//             'lng': locationData.longitude,
//             'updatedAt': FieldValue.serverTimestamp(),
//           },
//         });
//         Get.offAllNamed('/home');
//       }
//     }
//   }
//
//   // After successful phone & email sign up OTP verification
//   Future<void> verifyOtpAndRegister() async {
//     /*
//   if (!otpFormKey.currentState!.validate()) return;
//
//   final code = otpControllers.map((c) => c.text).join();
//   if (code.length != 6) {
//     showMessage("Invalid OTP", "Please enter the 6-digit code.");
//     return;
//   }
//
//   isVerifying.value = true;
//
//   try {
//     final credential = PhoneAuthProvider.credential(
//       verificationId: verificationId!,
//       smsCode: code,
//     );
//
//     await _auth.signInWithCredential(credential);
//   */
//     final userCredential = await _auth.createUserWithEmailAndPassword(
//       email: _localEmail,
//       password: _localPassword,
//     );
//
//     final user = userCredential.user!;
//
//     // Check if location permission and service enabled, get current device location
//     final location = Location();
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//     }
//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//     }
//     LocationData? locationData;
//     if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
//       locationData = await location.getLocation();
//     }
//
//     // Prepare user data to save
//     Map<String, dynamic> userData = {
//       'name': _localName,
//       'email': _localEmail,
//       'phone': _finalPhoneNumber,
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//
//     // Add location if available
//     if (locationData != null) {
//       userData['location'] = {
//         'lat': locationData.latitude,
//         'lng': locationData.longitude,
//         'updatedAt': FieldValue.serverTimestamp(),
//       };
//     }
//
//     // Save user data to Firestore with uid as doc id
//     await _firestore.collection('users').doc(user.uid).set(userData);
//
//     // After saving, check and navigate accordingly
//     await checkUserLocationAndNavigate();
//
//     /*
//   } on FirebaseAuthException catch (e) {
//     showMessage("Verification Failed", e.message ?? "Invalid OTP");
//   } catch (e) {
//     showMessage("Error", e.toString());
//   } finally {
//     isVerifying.value = false;
//   }
//   */
//   }
//
//   // After login (email or phone) or signup - decide to navigate home or location screen based on stored and device location
//   Future<void> checkUserLocationAndNavigate() async {
//     final locationService = Location();
//
//     bool serviceEnabled = await locationService.serviceEnabled();
//     if (!serviceEnabled)
//       serviceEnabled = await locationService.requestService();
//
//     PermissionStatus permission = await locationService.hasPermission();
//     if (permission == PermissionStatus.denied)
//       permission = await locationService.requestPermission();
//
//     final currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       showMessage("Error", "No user is logged in.");
//       return;
//     }
//
//     final userDocSnapshot = await _firestore
//         .collection('users')
//         .doc(currentUser.uid)
//         .get();
//     if (!userDocSnapshot.exists) {
//       print('Location document missing — navigating to /location');
//       await Get.offAllNamed('/location');
//       return;
//     }
//
//     final userData = userDocSnapshot.data()!;
//     if (userData.containsKey('location') &&
//         serviceEnabled &&
//         permission == PermissionStatus.granted) {
//       final deviceLocation = await locationService.getLocation();
//       final stored = userData['location'];
//       final double? lat = stored['lat'];
//       final double? lng = stored['lng'];
//
//       bool isSameLocation = false;
//       if (lat != null &&
//           lng != null &&
//           deviceLocation.latitude != null &&
//           deviceLocation.longitude != null) {
//         const double tol = 0.0005;
//         isSameLocation =
//             (lat - deviceLocation.latitude!).abs() < tol &&
//             (lng - deviceLocation.longitude!).abs() < tol;
//       }
//
//       print(
//         isSameLocation
//             ? 'Matching location — going home'
//             : 'Different location — update & go home',
//       );
//
//       if (!isSameLocation) {
//         await _firestore.collection('users').doc(currentUser.uid).update({
//           'location': {
//             'lat': deviceLocation.latitude,
//             'lng': deviceLocation.longitude,
//             'updatedAt': FieldValue.serverTimestamp(),
//           },
//         });
//       }
//
//       await Get.offAllNamed('/home');
//     } else {
//       print('Location missing or permission denied — navigating to /location');
//       await Get.offAllNamed('/location');
//     }
//   }
//
//   @override
//   void onClose() {
//     for (final controller in otpControllers) {
//       controller.dispose();
//     }
//     for (final node in otpFocusNodes) {
//       node.dispose();
//     }
//     passwordController.dispose();
//     phoneController.dispose();
//     super.onClose();
//   }
// }
//
// class LocationController extends GetxController {
//   var isFetchingLocation = false.obs;
//   var locationData = Rxn<LocationData>();
//   var placeName = ''.obs;
//   GoogleMapController? googleMapController;
//
//   final Location _locationService = Location();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//
//
//
//   Future<void> fetchCurrentLocation() async {
//     try {
//       isFetchingLocation.value = true;
//
//       bool serviceEnabled = await _locationService.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await _locationService.requestService();
//         if (!serviceEnabled) {
//           Get.defaultDialog(
//             title: "Location Required",
//             middleText: "Please enable location on your device.",
//             confirm: ElevatedButton(
//               onPressed: () => Get.back(),
//               child: const Text("OK"),
//             ),
//           );
//           return;
//         }
//       }
//
//       PermissionStatus permissionGranted = await _locationService
//           .hasPermission();
//       if (permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await _locationService.requestPermission();
//         if (permissionGranted != PermissionStatus.granted) {
//           showMessage('Error', 'Location permission not granted');
//           return;
//         }
//       }
//
//       final location = await _locationService.getLocation();
//       locationData.value = location;
//
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         location.latitude!,
//         location.longitude!,
//       );
//
//       String name = placemarks.isNotEmpty
//           ? "${placemarks.first.locality}, ${placemarks.first.country}"
//           : "Unknown Location";
//
//       placeName.value = name;
//
//       final uid = _auth.currentUser?.uid;
//       if (uid == null) {
//         showMessage('Error', 'User not logged in');
//         return;
//       }
//
//       await _firestore.collection('users').doc(uid).set({
//         'location': {
//           'lat': location.latitude,
//           'lng': location.longitude,
//           'place': name,
//           'updatedAt': FieldValue.serverTimestamp(),
//         },
//       }, SetOptions(merge: true));
//
//       // Auto navigate to home after 15 seconds
//       Future.delayed(const Duration(seconds: 15), () {
//         Get.offAllNamed('/home');
//       });
//     } catch (e) {
//       showMessage('Error', 'Failed to fetch/store location: $e');
//       print(e);
//     } finally {
//       isFetchingLocation.value = false;
//     }
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/show_message_widget.dart';

class AuthenticationController extends GetxController {
  final supabase = Supabase.instance.client;

  RxBool isVerifyingEmail = false.obs;
  final isLoading = false.obs;
  final isVerifying = false.obs;
  final isFetchingLocation = false.obs;
  Rx<File?> pickedProfileImage = Rx<File?>(null);

  // Form fields
  final name = ''.obs;
  final email = ''.obs;
  final number = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final otpCode = ''.obs;
  var isPasswordHidden = true.obs;

  // Form keys
  final formKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  // Input handling
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final loginInput = ''.obs;
  final RxString location = ''.obs;

  // Country code
  final selectedCountryDialCode = '+92'.obs;
  final selectedCountryCode = 'PK'.obs;

  // OTP fields
  final otpControllers = List.generate(6, (_) => TextEditingController());
  final otpFocusNodes = List.generate(6, (_) => FocusNode());

  // For both signup/login OTP
  String? verificationId;

  // For sign up temp storage
  late String _localName;
  late String _localEmail;
  late String _localNumber;
  late String _localPassword;
  late String _finalPhoneNumber;

  @override
  void onInit() {
    super.onInit();
    loadUserLocation();
  }

  // -------------------- Country Code Handler --------------------
  void onCountryCodeChanged(String dialCode) {
    selectedCountryDialCode.value = dialCode;
  }

  var locationData = Rxn<loc.LocationData>();
  var placeName = ''.obs;
  GoogleMapController? googleMapController;
  final loc.Location _locationService = loc.Location();

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
    otpCode.value = otpControllers.map((c) => c.text).join();
  }

  Future<void> onOtpVerifyPressed() async {
    if (!(otpFormKey.currentState?.validate() ?? false)) return;

    isVerifying.value = true;
    try {
      final code = otpCode.value;
      if (code.length != 6) {
        showMessage("Error", "Please enter a valid 6-digit OTP");
        return;
      }

      // Supabase OTP verification can go here if you use magic link or phone auth
      showMessage("Success", "OTP Verified Successfully");

      Get.offAllNamed('/location');
    } catch (e) {
      showMessage("OTP Verification Failed", e.toString());
    } finally {
      isVerifying.value = false;
    }
  }

  void setEmailOrPhone(String value) {
    loginInput.value = value.trim();
  }

  Future<File> _getTempFileFromAsset(String assetPath, String fileName) async {
    ByteData byteData = await rootBundle.load(assetPath);
    Uint8List bytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  // Future<void> onSignupPressed() async {
  //   if (!(formKey.currentState?.validate() ?? false)) return;
  //
  //   if (password.value != confirmPassword.value) {
  //     showMessage("Error", "Passwords do not match");
  //     return;
  //   }
  //
  //   _localName = name.value.trim();
  //   _localEmail = email.value.trim();
  //   _localNumber = number.value.trim();
  //   _localPassword = password.value;
  //   _finalPhoneNumber = '${selectedCountryDialCode.value}$_localNumber';
  //
  //   isLoading.value = true;
  //
  //   try {
  //     // 1️⃣ Signup via Supabase Auth
  //     final response = await supabase.auth.signUp(
  //       email: _localEmail,
  //       password: _localPassword,
  //       data: {
  //         'name': _localName,
  //         'phone': _finalPhoneNumber,
  //         'userRole': 'user',
  //         'userStatus': 'active',
  //       },
  //     );
  //
  //     final uid = response.user?.id;
  //     if (uid == null) throw Exception("Signup failed");
  //
  //     // 2️⃣ Upload default profile image
  //     File profileImageFile =
  //     await _getTempFileFromAsset('assets/images/ProfileImage.png', 'ProfileImage.png');
  //
  //     await supabase.storage.from('profile-images').upload(
  //       'users/$uid/ProfileImage.png',
  //       profileImageFile,
  //       fileOptions: const FileOptions(upsert: true),
  //     );
  //
  //     final profileImageUrl =
  //     supabase.storage.from('profile-images').getPublicUrl('users/$uid/ProfileImage.png');
  //
  //     // 3️⃣ Insert user into users table
  //     final insertResponse = await supabase.from('users').insert({
  //       'user_id': uid,
  //       'name': _localName,
  //       'email': _localEmail,
  //       'phone': _finalPhoneNumber,
  //       'location': '', // initially empty
  //       'user_role': 'user',
  //       'user_status': 'active',
  //       'profile_image': profileImageUrl,
  //       'created_at': DateTime.now().toIso8601String(),
  //     });
  //
  //     if (insertResponse.error != null) {
  //       // Rollback Auth if table insert fails
  //       await supabase.auth.admin.deleteUser(uid);
  //       throw Exception(insertResponse.error!.message);
  //     }
  //
  //     // 4️⃣ Navigate to Email Verify Screen
  //     Get.toNamed('/emailVerify', arguments: {
  //       'email': _localEmail,
  //       'password': _localPassword,
  //       'message': "Kindly check your email to verify your account."
  //     });
  //
  //   } catch (e) {
  //     showMessage("Signup Failed", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  //
  // /// Signup button pressed
  // Future<void> onSignupPressed() async {
  //   if (!(formKey.currentState?.validate() ?? false)) return;
  //
  //   if (password.value != confirmPassword.value) {
  //     showMessage("Error", "Passwords do not match");
  //     return;
  //   }
  //
  //   _localName = name.value.trim();
  //   _localEmail = email.value.trim();
  //   _localNumber = number.value.trim();
  //   _localPassword = password.value;
  //   _finalPhoneNumber = '${selectedCountryDialCode.value}$_localNumber';
  //
  //   isLoading.value = true;
  //
  //   try {
  //     // 1️⃣ Signup via Supabase Auth
  //     final response = await supabase.auth.signUp(
  //       email: _localEmail,
  //       password: _localPassword,
  //       data: {
  //         'name': _localName,
  //         'phone': _finalPhoneNumber,
  //         'userRole': 'user',
  //         'userStatus': 'active',
  //       },
  //     );
  //
  //     if (response.user == null) throw Exception("Signup failed");
  //     final uid = response.user!.id;
  //
  //     // 2️⃣ Use default profile image URL from public bucket
  //     const profileImageUrl =
  //         'https://jzotfyxetsyliprlbvxh.supabase.co/storage/v1/object/public/profile-images/ProfileImage.png';
  //
  //     // 3️⃣ Insert user into users table directly
  //     await supabase.from('users').upsert({
  //       'user_id': uid,
  //       'name': _localName,
  //       'email': _localEmail,
  //       'phone': _finalPhoneNumber,
  //       'location': '', // initially empty
  //       'user_role': 'user',
  //       'user_status': 'active',
  //       'profile_image': profileImageUrl,
  //       'created_at': DateTime.now().toIso8601String(),
  //     }, onConflict: 'user_id');
  //
  //     // 4️⃣ Automatically login after signup
  //     final loginResponse = await supabase.auth.signInWithPassword(
  //       email: _localEmail,
  //       password: _localPassword,
  //     );
  //
  //     if (loginResponse.user == null) throw Exception("Login failed after signup");
  //
  //     // 5️⃣ Navigate to location screen
  //     Get.offAllNamed('/fetchLocation');
  //
  //   } catch (e) {
  //     showMessage("Signup Failed", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> onSignupPressed() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    // Check if passwords match
    if (password.value != confirmPassword.value) {
      showMessage("Error", "Passwords do not match");
      return;
    }

    _localName = name.value.trim();
    _localEmail = email.value.trim();
    _localNumber = number.value.trim();
    _localPassword = password.value;
    _finalPhoneNumber = '${selectedCountryDialCode.value}$_localNumber';

    // Double check email/password not empty
    if (_localEmail.isEmpty || _localPassword.isEmpty) {
      showMessage("Error", "Email and password cannot be empty");
      return;
    }

    isLoading.value = true;

    try {
      // 1️⃣ Signup via Supabase Auth
      final signUpResponse = await supabase.auth.signUp(
        email: _localEmail,
        password: _localPassword,
        data: {
          'name': _localName,
          'phone': _finalPhoneNumber,
          'userRole': 'user',
          'userStatus': 'pending',
        },
      );

      if (signUpResponse.user == null) throw Exception("Signup failed");

      Get.offAllNamed('/loginEmail');
    } catch (e) {
      showMessage("Signup Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Rx<File?> profileImageFile = Rx<File?>(
    null,
  ); // add this inside your controller

  // Future<void> submitPersonalDetails() async {
  //   isLoading.value = true;
  //
  //   _finalPhoneNumber = '${selectedCountryDialCode.value}$number';
  //
  //
  //   try {
  //     String profileImageUrl;
  //
  //     if (profileImageFile.value != null) {
  //       // Upload picked image to Supabase Storage
  //       final uid = supabase.auth.currentUser!.id;
  //
  //       await supabase.storage
  //           .from('profile-images')
  //           .upload(
  //             'users/$uid/ProfileImage.png',
  //             profileImageFile.value!,
  //             fileOptions: const FileOptions(upsert: true),
  //           );
  //
  //       profileImageUrl = supabase.storage
  //           .from('profile-images')
  //           .getPublicUrl('users/$uid/ProfileImage.png');
  //     } else {
  //       // Use default local asset image
  //       profileImageUrl =
  //           'https://jzotfyxetsyliprlbvxh.supabase.co/storage/v1/object/public/profile-images/ProfileImage.png';
  //     }
  //
  //     // Insert into users table
  //     await supabase.from('users').upsert({
  //       'user_id': supabase.auth.currentUser!.id,
  //       'name': name.value,
  //       'email': supabase.auth.currentUser!.email,
  //       'phone': _finalPhoneNumber,
  //       'location': '',
  //       'user_role': 'user',
  //       'user_status': 'active',
  //       'profile_image': profileImageUrl,
  //       'created_at': DateTime.now().toIso8601String(),
  //     }, onConflict: 'user_id');
  //
  //     Get.offAllNamed('/location'); // Navigate after submit
  //   } catch (e) {
  //     showMessage("Error", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> submitPersonalDetails() async {
    isLoading.value = true;

    _finalPhoneNumber = '${selectedCountryDialCode.value}$number';

    try {
      String profileImageUrl;

      // Upload profile image if exists
      if (profileImageFile.value != null) {
        final uid = supabase.auth.currentUser!.id;

        await supabase.storage
            .from('profile-images')
            .upload(
          'users/$uid/ProfileImage.png',
          profileImageFile.value!,
          fileOptions: const FileOptions(upsert: true),
        );

        profileImageUrl = supabase.storage
            .from('profile-images')
            .getPublicUrl('users/$uid/ProfileImage.png');
      } else {
        // Use default image if no profile image provided
        profileImageUrl =
        'https://jzotfyxetsyliprlbvxh.supabase.co/storage/v1/object/public/profile-images/ProfileImage.png';
      }

      // Insert user data into 'users' table
      final userResponse = await supabase.from('users').upsert({
        'user_id': supabase.auth.currentUser!.id,
        'name': name.value,
        'email': supabase.auth.currentUser!.email,
        'phone': _finalPhoneNumber,
        'location': '',
        'user_role': 'user',
        'user_status': 'active',
        'profile_image': profileImageUrl,
        'created_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');

      if (userResponse.error != null) {
        throw userResponse.error!.message;
      }

      // Send OTP for phone number verification after email signup
      await sendOtp();

      // No need to navigate to location here because we handle navigation after OTP verification
    } catch (e) {
      showMessage("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtp() async {
    if (number.value.isEmpty) {
      showMessage("Error", "Please enter a valid phone number.");
      return;
    }

    final phoneNumber = '${selectedCountryDialCode.value}${number.value}';

    isLoading.value = true;

    try {
      // Send OTP
      await supabase.auth.signInWithOtp(phone: phoneNumber);

      // Notify the user
      showMessage("OTP Sent", "Please check your SMS for the OTP.");

      // Navigate to OTP verification screen
      Get.toNamed('/loginOtpVerification');
    } catch (e) {
      showMessage("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length != 6) {
      showMessage("Error", "Invalid OTP");
      return;
    }

    isLoading.value = true;

    try {
      // Query the users table to check if the phone number exists
      final userResponse = await supabase.from('users').select().eq('phone', _finalPhoneNumber).maybeSingle();

      // For now, we use OtpType.signup for both login and signup
      OtpType otpType = (userResponse != null && userResponse['user_id'] != null)
          ? OtpType.signup // Treat it as signup even if it's login
          : OtpType.signup; // Treat it as signup for new users as well

      // Perform OTP verification
      final response = await supabase.auth.verifyOTP(
        phone: _finalPhoneNumber,  // Full phone number including country code
        token: otp,                // The OTP entered by the user
        type: otpType,             // OtpType.signup for both login and signup
      );

      // Check if the user is authenticated
      if (response.user == null) {
        showMessage("Error", "OTP verification failed.");
        return;
      }

      // OTP successfully verified
      showMessage("Success", "Phone number verified successfully.");

      // Navigate based on OTP type (though both are handled as signup here)
      if (userResponse != null && userResponse['user_id'] != null) {
        // If user exists (login), navigate to home
        Get.offAllNamed('/home');
      } else {
        // If it's a new user (signup), navigate to location page
        Get.offAllNamed('/location');
      }
    } catch (e) {
      showMessage("OTP Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }







  //
  // Future<void> verifyPhoneNumber() async {
  //   try {
  //     // Get the OTP entered by the user
  //     final otp = otpCode.value;
  //
  //     if (otp.isEmpty || otp.length != 6) {
  //       showMessage("Error", "Invalid OTP");
  //       return;
  //     }
  //
  //     // Perform OTP verification with Supabase Auth
  //     final response = await supabase.auth.signInWithOtp(
  //       phone: _finalPhoneNumber,  // Phone number including country code
  //
  //     );
  //
  //     if (response.user == null) {
  //       showMessage("Error", "OTP verification failed.");
  //       return;
  //     }
  //
  //     // OTP verified successfully, navigate to the next screen
  //     showMessage("Success", "Phone number verified successfully.");
  //     Get.offAllNamed('/location');
  //   } catch (e) {
  //     showMessage("OTP Error", e.toString());
  //   }
  // }
  //
  //
  // Future<void> loginWithPhoneOTP() async {
  //   if (number.value.isEmpty) {
  //     showMessage("Error", "Please enter a valid phone number.");
  //     return;
  //   }
  //
  //   final phoneNumber = '${selectedCountryDialCode.value}${number.value}';
  //
  //   isLoading.value = true;
  //
  //   try {
  //     // Send OTP (Supabase handles verification internally)
  //     final response = await supabase.auth.signInWithOtp(
  //       phone: phoneNumber,
  //     );
  //
  //     // Show message indicating OTP is sent
  //     showMessage("OTP Sent", "Please check your SMS for the OTP.");
  //
  //     // Go to OTP Verification screen
  //     Get.toNamed('/otpVerification');
  //   } catch (e) {
  //     showMessage("Error", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // Future<void> onPhoneOtpVerifyPressed() async {
  //   if (!(otpFormKey.currentState?.validate() ?? false)) return;
  //
  //   isVerifying.value = true;
  //
  //   try {
  //     final code = otpCode.value;
  //     if (code.length != 6) {
  //       showMessage("Error", "Please enter a valid 6-digit OTP");
  //       return;
  //     }
  //
  //
  //     // Verify OTP with Supabase Auth
  //     final response = await supabase.auth.verifyOtp(
  //       verificationId: verificationId!,
  //       otpCode: otpCode.value,
  //     );
  //
  //     if (response.user == null) {
  //       showMessage("Error", "Invalid OTP");
  //       return;
  //     }
  //
  //     // OTP Verified, proceed with login/signup
  //     showMessage("Success", "OTP Verified Successfully");
  //
  //     // Now, proceed to personal details screen (if it's a new user or existing login)
  //     Get.offAllNamed('/location');
  //   } catch (e) {
  //     showMessage("OTP Verification Failed", e.toString());
  //   } finally {
  //     isVerifying.value = false;
  //   }
  // }


  Future<void> checkEmailVerifiedAndProceed() async {
    isLoading.value = true;

    try {
      // 1️⃣ Get current user from Supabase
      final user = supabase.auth.currentUser;

      if (user == null) {
        // No user logged in → cannot check verification
        showMessage("Error", "No user session found. Please login first.");
        return;
      }

      // 2️⃣ Refresh session to make sure emailConfirmedAt is up-to-date
      final sessionResponse = await supabase.auth.refreshSession();
      final refreshedUser = supabase.auth.currentUser;

      if (refreshedUser == null) {
        showMessage("Error", "Failed to refresh user session.");
        return;
      }

      // 3️⃣ Check if email is verified
      if (refreshedUser.emailConfirmedAt != null) {
        // Email verified → navigate to personal details screen
        Get.offAllNamed(
          '/personalDetailsView',
          arguments: {'uid': refreshedUser.id, 'email': refreshedUser.email},
        );
      } else {
        // Email not verified → show alert/snackbar
        showMessage(
          "Email not verified",
          "Please verify your email to continue.\nCheck your inbox or spam folder.",

        );
      }
    } catch (e) {
      showMessage("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //
  // /// Login button pressed
  // Future<void> loginWithDynamicMethod() async {
  //   final passwordVal = passwordController.text.trim();
  //   if (loginInput.value.isEmpty || passwordVal.isEmpty) {
  //     showMessage("Error", "Please enter all required fields.");
  //     return;
  //   }
  //
  //   isLoading.value = true;
  //
  //   try {
  //     final response = await supabase.auth.signInWithPassword(
  //       email: loginInput.value,
  //       password: passwordVal,
  //     );
  //
  //     if (response.user == null) throw Exception("Invalid credentials");
  //     final uid = response.user!.id;
  //
  //     // Fetch user data safely
  //     final userData = await supabase
  //         .from('users')
  //         .select()
  //         .eq('user_id', uid)
  //         .maybeSingle();
  //
  //     if (userData == null) {
  //       showMessage("Error", "User data not found. Complete signup first.");
  //       return;
  //     }
  //
  //     if (userData['user_status'] != 'active') {
  //       showMessage("Account Suspended", "Your account has been suspended");
  //       return;
  //     }
  //
  //     // Check if location exists
  //     if (userData['location'] == null || userData['location'].toString().isEmpty) {
  //       Get.offAllNamed('/fetchLocation'); // Go to Fetch Location Screen
  //     } else if (userData['user_role'] == 'admin') {
  //       Get.offAllNamed('/adminDashboard');
  //     } else {
  //       Get.offAllNamed('/home');
  //     }
  //
  //   } catch (e) {
  //     showMessage("Login Error", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  //
  Future<void> loginWithDynamicMethod() async {
    final passwordVal = passwordController.text.trim();
    final emailVal = loginInput.value.trim();

    if (emailVal.isEmpty || passwordVal.isEmpty) {
      showMessage("Error", "Please enter all required fields.");
      return;
    }

    isLoading.value = true;

    try {
      // 1️⃣ Sign in with Supabase Auth
      final response = await supabase.auth.signInWithPassword(
        email: emailVal,
        password: passwordVal,
      );

      if (response.user == null) {
        showMessage("Login Error", "Invalid credentials");
        return;
      }

      final uid = response.user!.id;

      // 2️⃣ Check email verification
      if (response.user!.emailConfirmedAt == null) {
        showMessage(
          "Email Not Verified",
          "Please check your inbox/spam folder and verify your email to continue.",
        );
        return;
      }

      // 3️⃣ Fetch users table record
      final userData = await supabase
          .from('users')
          .select()
          .eq('user_id', uid)
          .maybeSingle();

      if (userData == null) {
        Get.offAllNamed(
          '/personalDetailsView',
          arguments: {'uid': uid, 'email': emailVal},
        );
        return;
      }

      if (userData['user_status'] != 'active') {
        showMessage("Account Suspended", "Your account has been suspended");
        return;
      }

      // 4️⃣ Route based on user data
      if (userData['location'] == null ||
          userData['location'].toString().isEmpty) {
        Get.offAllNamed('/location');
      } else if (userData['user_role'] == 'admin') {
        Get.offAllNamed('/adminDashboard');
      } else {
        Get.offAllNamed('/home');
      }
    } on AuthException catch (e) {
      // Supabase-specific errors (invalid password, invalid email, etc.)
      showMessage("Login Error", e.message);
    } catch (e) {
      // Other unexpected errors
      showMessage("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail() async {
    if (email.value.isEmpty) {
      showMessage("Error", "Please enter your registered email.");
      return;
    }

    isLoading.value = true;
    try {
      await supabase.auth.resetPasswordForEmail(email.value);
      showMessage("Success", "Password reset link sent to ${email.value}");
      email.value = '';
    } catch (e) {
      showMessage("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }






  // Future<void> loginWithDynamicMethod() async {
  //   final passwordVal = passwordController.text.trim();
  //   if (loginInput.value.isEmpty || passwordVal.isEmpty) {
  //     showMessage("Error", "Please enter all required fields.");
  //     return;
  //   }
  //
  //   isLoading.value = true;
  //
  //   try {
  //     final response = await supabase.auth.signInWithPassword(
  //       email: loginInput.value,
  //       password: passwordVal,
  //     );
  //
  //     final uid = response.user?.id;
  //     if (uid == null) throw Exception("Invalid credentials");
  //
  //     final userData = await supabase
  //         .from('users')
  //         .select()
  //         .eq('user_id', uid)
  //         .single();
  //
  //     if (userData['user_status'] != 'active') {
  //       showMessage("Account Suspended", "Your account has been suspended");
  //       return;
  //     }
  //
  //     // Check if location is null/empty
  //     if (userData['location'] == null || userData['location'].toString().isEmpty) {
  //       Get.offAllNamed('/fetchLocation'); // Go to Fetch Location Screen
  //     } else if (userData['user_role'] == 'admin') {
  //       Get.offAllNamed('/adminDashboard');
  //     } else {
  //       Get.offAllNamed('/home');
  //     }
  //   } catch (e) {
  //     showMessage("Login Error", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> loadUserLocation() async {
    try {
      final user = supabase.auth.currentUser;
      final uid = user?.id;
      if (uid == null) {
        location.value = 'User not logged in';
        return;
      }

      final locData = await supabase
          .from('users')
          .select('location')
          .eq('user_id', uid)
          .single();
      location.value = locData['location'] ?? 'No location saved';
    } catch (e) {
      location.value = 'Error loading location';
    }
  }

  @override
  void onClose() {
    for (final controller in otpControllers) controller.dispose();
    for (final node in otpFocusNodes) node.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // /// Verify Email using Supabase OTP
  // Future<void> verifyEmail(String otpCode) async {
  //   isVerifyingEmail.value = true;
  //
  //   try {
  //     final session = await supabase.auth.verifyOTP(
  //       token: otpCode,
  //       type: OtpType.signup,
  //     );
  //
  //     if (session.user == null) throw Exception("Invalid OTP");
  //     final uid = session.user!.id;
  //
  //     // Upload default profile image
  //     File profileImageFile =
  //     await _getTempFileFromAsset('assets/images/ProfileImage.png', 'ProfileImage.png');
  //
  //     await supabase.storage.from('profile-images').upload(
  //       'users/$uid/ProfileImage.png',
  //       profileImageFile,
  //       fileOptions: const FileOptions(upsert: true),
  //     );
  //
  //     // Get public URL of the profile image
  //     final profileImageUrl =
  //     supabase.storage.from('profile-images').getPublicUrl('users/$uid/ProfileImage.png');
  //
  //     // Optional: update the profile image field only
  //     await supabase.from('users').update({'profile_image': profileImageUrl}).eq('user_id', uid);
  //
  //     // Log in the user
  //     await loginWithDynamicMethod(_localEmail, _localPassword);
  //   } catch (e) {
  //     showMessage("Verification Failed", e.toString());
  //   } finally {
  //     isVerifyingEmail.value = false;
  //   }
  // }

  Future<void> fetchCurrentLocation() async {
    try {
      isFetchingLocation.value = true;

      // Check if location service is enabled
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          showMessage("Location Required", "Please enable location services.");
          return;
        }
      }

      // Check permission
      loc.PermissionStatus permissionGranted = await _locationService
          .hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          showMessage("Error", "Location permission not granted.");
          return;
        }
      }

      // Get current location
      final currentLocation = await _locationService.getLocation();

      // Reverse geocoding for full address
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );

      String fullAddress = placemarks.isNotEmpty
          ? "${placemarks.first.subThoroughfare != null ? placemarks.first.subThoroughfare! + ', ' : ''}"
                "${placemarks.first.thoroughfare != null ? placemarks.first.thoroughfare! + ', ' : ''}"
                "${placemarks.first.subLocality != null ? placemarks.first.subLocality! + ', ' : ''}"
                "${placemarks.first.locality != null ? placemarks.first.locality! + ', ' : ''}"
                "${placemarks.first.subAdministrativeArea != null ? placemarks.first.subAdministrativeArea! + ', ' : ''}"
                "${placemarks.first.administrativeArea != null ? placemarks.first.administrativeArea! + ', ' : ''}"
                "${placemarks.first.postalCode != null ? placemarks.first.postalCode! + ', ' : ''}"
                "${placemarks.first.country ?? ''}"
          : "Unknown Location";

      placeName.value = fullAddress;

      // Update Supabase users table
      final user = supabase.auth.currentUser;
      if (user == null) {
        showMessage("Error", "User not logged in");
        return;
      }

      await supabase
          .from('users')
          .update({'location': fullAddress})
          .eq('user_id', user.id);

      Get.offAllNamed('/home');
    } catch (e) {
      showMessage("Error", "Failed to fetch/store location: $e");
    } finally {
      isFetchingLocation.value = false;
    }
  }
}
