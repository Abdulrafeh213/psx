// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // //
// // // class AuthenticationController extends GetxController {
// // //   // final name = ''.obs;
// // //   // final email = ''.obs;
// // //   // final number = ''.obs;
// // //   // final password = ''.obs;
// // //   // final confirmPassword = ''.obs;
// // //   // final isLoading = false.obs;
// // //   //
// // //   // final formKey = GlobalKey<FormState>();
// // //
// // //   // Future<void> registerUser() async {
// // //   //   if (!formKey.currentState!.validate()) return;
// // //   //
// // //   //   if (password.value != confirmPassword.value) {
// // //   //     showMessage("Error", "Passwords do not match");
// // //   //     return;
// // //   //   }
// // //   //
// // //   //   try {
// // //   //     isLoading.value = true;
// // //   //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
// // //   //       email: email.value,
// // //   //       password: password.value,
// // //   //     );
// // //   //
// // //   //     Get.offAllNamed('/home');
// // //   //   } on FirebaseAuthException catch (e) {
// // //   //     showMessage("Registration Failed", e.message ?? "Unknown error");
// // //   //   } finally {
// // //   //     isLoading.value = false;
// // //   //   }
// // //   // }
// // //
// // //   // Observable form fields (keep these for input binding)
// // //   final name = ''.obs;
// // //   final email = ''.obs;
// // //   final number = ''.obs;
// // //   final password = ''.obs;
// // //   final confirmPassword = ''.obs;
// // //   final otpCode = ''.obs;
// // //
// // //   // Local variables to hold form data after submit and before user creation
// // //   late String _localName;
// // //   late String _localEmail;
// // //   late String _localNumber;
// // //   late String _finalLocalNumber;
// // //   late String _localPassword;
// // //
// // //   // UI state
// // //   final isLoading = false.obs;
// // //   final isVerifyingOtp = false.obs;
// // //
// // //   final formKey = GlobalKey<FormState>();
// // //   final otpFormKey = GlobalKey<FormState>();
// // //
// // //   String? verificationId;
// // //   final selectedCountryDialCode = '+92'.obs; // dial code for phone number
// // //   final selectedCountryCode = 'PK'.obs; // country ISO code for initialSelection
// // //
// // //   void onCountryCodeChanged(String dialCode) {
// // //     selectedCountryDialCode.value = dialCode;
// // //   }
// // //
// // //
// // //   /// Called when user taps "Sign Up" button:
// // //   /// validate form, save values locally, send OTP & navigate to OTP screen
// // //   Future<void> onSignupPressed() async {
// // //     if (!formKey.currentState!.validate()) return;
// // //
// // //     if (password.value != confirmPassword.value) {
// // //       showMessage("Error", "Passwords do not match");
// // //       return;
// // //     }
// // //
// // //     // Store values locally
// // //     _localName = name.value.trim();
// // //     _localEmail = email.value.trim();
// // //     _localNumber = number.value.trim();
// // //     _finalLocalNumber = '+92$_localNumber';
// // //     _localPassword = password.value;
// // //     print(_finalLocalNumber);
// // //     isLoading.value = true;
// // //
// // //     try {
// // //       // Send OTP to phone number (before user creation)
// // //       await FirebaseAuth.instance.verifyPhoneNumber(
// // //         phoneNumber: _finalLocalNumber,
// // //
// // //         timeout: const Duration(seconds: 60),
// // //         verificationCompleted: (PhoneAuthCredential credential) async {
// // //           // Optional: handle auto-verification here
// // //         },
// // //         verificationFailed: (FirebaseAuthException e) {
// // //           showMessage("OTP Failed", e.message ?? "Verification error");
// // //         },
// // //         codeSent: (String verId, int? resendToken) {
// // //           verificationId = verId;
// // //           // Navigate to OTP verification screen
// // //           Get.toNamed('/otp_verification');
// // //         },
// // //         codeAutoRetrievalTimeout: (String verId) {
// // //           verificationId = verId;
// // //         },
// // //       );
// // //     } finally {
// // //       isLoading.value = false;
// // //     }
// // //   }
// // //
// // //   /// Called on OTP screen when user submits OTP
// // //   Future<void> verifyOtpAndRegister() async {
// // //     if (!otpFormKey.currentState!.validate()) return;
// // //
// // //     isVerifyingOtp.value = true;
// // //
// // //     try {
// // //       final credential = PhoneAuthProvider.credential(
// // //         verificationId: verificationId!,
// // //         smsCode: otpCode.value.trim(),
// // //       );
// // //
// // //       // Sign in with phone credential to verify OTP
// // //       await FirebaseAuth.instance.signInWithCredential(credential);
// // //
// // //       // Create user with email/password after successful OTP verification
// // //       UserCredential userCredential = await FirebaseAuth.instance
// // //           .createUserWithEmailAndPassword(email: _localEmail, password: _localPassword);
// // //
// // //       // Save user data in Firestore
// // //       await FirebaseFirestore.instance
// // //           .collection('users')
// // //           .doc(userCredential.user!.uid)
// // //           .set({
// // //         'name': _localName,
// // //         'email': _localEmail,
// // //         'phone': _finalLocalNumber,
// // //         'createdAt': FieldValue.serverTimestamp(),
// // //       });
// // //
// // //       Get.offAllNamed('/home');
// // //     } on FirebaseAuthException catch (e) {
// // //       showMessage("Registration Failed", e.message ?? e.toString());
// // //     } finally {
// // //       isVerifyingOtp.value = false;
// // //     }
// // //   }
// // //   // // Form fields
// // //   // final name = ''.obs;
// // //   // final email = ''.obs;
// // //   // final number = ''.obs;
// // //   // final password = ''.obs;
// // //   // final confirmPassword = ''.obs;
// // //   // final otpCode = ''.obs;
// // //   //
// // //   // // UI state
// // //   // final isLoading = false.obs;
// // //   // final isVerifyingOtp = false.obs;
// // //   //
// // //   // final formKey = GlobalKey<FormState>();
// // //   // final otpFormKey = GlobalKey<FormState>();
// // //   //
// // //   // // Firebase
// // //   // String? verificationId;
// // //   //
// // //   // /// Register user with email and password, then send OTP to phone number
// // //   // Future<void> registerUser() async {
// // //   //   if (!formKey.currentState!.validate()) return;
// // //   //
// // //   //   if (password.value != confirmPassword.value) {
// // //   //     showMessage("Error", "Passwords do not match");
// // //   //     return;
// // //   //   }
// // //   //
// // //   //   try {
// // //   //     isLoading.value = true;
// // //   //
// // //   //     // 1. Create user with email/password
// // //   //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
// // //   //       email: email.value,
// // //   //       password: password.value,
// // //   //     );
// // //   //
// // //   //     // 2. Send OTP to phone
// // //   //     await FirebaseAuth.instance.verifyPhoneNumber(
// // //   //       phoneNumber: number.value,
// // //   //       timeout: const Duration(seconds: 60),
// // //   //       verificationCompleted: (PhoneAuthCredential credential) async {
// // //   //         // Optional: auto verification
// // //   //       },
// // //   //       verificationFailed: (FirebaseAuthException e) {
// // //   //         showMessage("OTP Failed", e.message ?? "Verification error");
// // //   //       },
// // //   //       codeSent: (String verId, int? resendToken) {
// // //   //         verificationId = verId;
// // //   //
// // //   //         // Navigate to OTP screen
// // //   //         Get.toNamed('/otp_verification');
// // //   //       },
// // //   //       codeAutoRetrievalTimeout: (String verId) {
// // //   //         verificationId = verId;
// // //   //       },
// // //   //     );
// // //   //   } on FirebaseAuthException catch (e) {
// // //   //     showMessage("Registration Failed", e.message ?? "Unknown error");
// // //   //   } finally {
// // //   //     isLoading.value = false;
// // //   //   }
// // //   // }
// // //   //
// // //   // /// Verify OTP and link phone number with the current Firebase user
// // //   // Future<void> verifyOtp() async {
// // //   //   if (!otpFormKey.currentState!.validate()) return;
// // //   //
// // //   //   try {
// // //   //     isVerifyingOtp.value = true;
// // //   //
// // //   //     final credential = PhoneAuthProvider.credential(
// // //   //       verificationId: verificationId!,
// // //   //       smsCode: otpCode.value,
// // //   //     );
// // //   //
// // //   //     // Link phone number to current signed-in user
// // //   //     await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
// // //   //
// // //   //     Get.offAllNamed('/home');
// // //   //   } catch (e) {
// // //   //     showMessage("OTP Verification Failed", e.toString());
// // //   //   } finally {
// // //   //     isVerifyingOtp.value = false;
// // //   //   }
// // //   // }
// // //
// // //
// // //
// // //   // 6 controllers and focus nodes for OTP boxes
// // //   final otpControllers = List.generate(6, (_) => TextEditingController());
// // //   final otpFocusNodes = List.generate(6, (_) => FocusNode());
// // //
// // //
// // //   final isVerifying = false.obs;
// // //
// // //   void onOtpChanged(String value, int index) {
// // //     if (value.isNotEmpty && index < 5) {
// // //       otpFocusNodes[index + 1].requestFocus();
// // //     } else if (value.isEmpty && index > 0) {
// // //       otpFocusNodes[index - 1].requestFocus();
// // //     }
// // //
// // //     otpCode.value = otpControllers.map((c) => c.text).join();
// // //   }
// // //
// // //   void verifyOtp() {
// // //     if (formKey.currentState!.validate()) {
// // //       final enteredCode = otpControllers.map((c) => c.text).join();
// // //       if (enteredCode.length == 6) {
// // //         isVerifying.value = true;
// // //
// // //         // TODO: Implement your OTP verification logic here (Firebase, API, etc.)
// // //         Future.delayed(const Duration(seconds: 2), () {
// // //           isVerifying.value = false;
// // //           showMessage("Success", "OTP Verified Successfully");
// // //           // Navigate to next screen here if needed
// // //         });
// // //       } else {
// // //         showMessage("Invalid OTP", "Please enter a 6-digit code.");
// // //       }
// // //     }
// // //   }
// // //
// // //   @override
// // //   void onClose() {
// // //     for (final controller in otpControllers) {
// // //       controller.dispose();
// // //     }
// // //     for (final node in otpFocusNodes) {
// // //       node.dispose();
// // //     }
// // //     super.onClose();
// // //   }
// // // }
// //
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// //
// // class AuthenticationController extends GetxController {
// //   // -------------------- Form Controllers --------------------
// //   final name = ''.obs;
// //   final email = ''.obs;
// //   final number = ''.obs;
// //   final password = ''.obs;
// //   final confirmPassword = ''.obs;
// //   final otpCode = ''.obs;
// //
// //   final isLoading = false.obs;
// //   final isVerifying = false.obs;
// //
// //   final formKey = GlobalKey<FormState>();
// //   final otpFormKey = GlobalKey<FormState>();
// //
// //   final selectedCountryDialCode = '+92'.obs;
// //   final selectedCountryCode = 'PK'.obs;
// //
// //   // 6-digit OTP input fields
// //   final otpControllers = List.generate(6, (_) => TextEditingController());
// //   final otpFocusNodes = List.generate(6, (_) => FocusNode());
// //
// //   String? verificationId;
// //
// //   // Local temp storage before Firebase registration
// //   late String _localName;
// //   late String _localEmail;
// //   late String _localNumber;
// //   late String _localPassword;
// //   late String _finalPhoneNumber;
// //
// //   // -------------------- Country Code Handler --------------------
// //   void onCountryCodeChanged(String dialCode) {
// //     selectedCountryDialCode.value = dialCode;
// //   }
// //
// //   // -------------------- OTP Input Handler --------------------
// //   void onOtpChanged(String value, int index) {
// //     if (value.isNotEmpty && index < 5) {
// //       otpFocusNodes[index + 1].requestFocus();
// //     } else if (value.isEmpty && index > 0) {
// //       otpFocusNodes[index - 1].requestFocus();
// //     }
// //     otpCode.value = otpControllers.map((c) => c.text).join();
// //   }
// //
// //   // -------------------- Sign Up Flow --------------------
// //   Future<void> onSignupPressed() async {
// //     if (!formKey.currentState!.validate()) return;
// //
// //     if (password.value != confirmPassword.value) {
// //       showMessage("Error", "Passwords do not match");
// //       return;
// //     }
// //
// //     // Store data locally for later use
// //     _localName = name.value.trim();
// //     _localEmail = email.value.trim();
// //     _localNumber = number.value.trim();
// //     _localPassword = password.value;
// //     _finalPhoneNumber = '${selectedCountryDialCode.value}$_localNumber';
// //
// //     isLoading.value = true;
// //
// //     try {
// //       await FirebaseAuth.instance.verifyPhoneNumber(
// //         phoneNumber: _finalPhoneNumber,
// //         timeout: const Duration(seconds: 60),
// //         verificationCompleted: (PhoneAuthCredential credential) {},
// //         verificationFailed: (FirebaseAuthException e) {
// //           showMessage("OTP Failed", e.message ?? "Phone verification error");
// //         },
// //         codeSent: (String verId, int? resendToken) {
// //           verificationId = verId;
// //           Get.toNamed('/otp_verification'); // Navigate to OTP screen
// //         },
// //         codeAutoRetrievalTimeout: (String verId) {
// //           verificationId = verId;
// //         },
// //       );
// //     } catch (e) {
// //       showMessage("Error", e.toString());
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   // -------------------- OTP Verification & Registration --------------------
// //   Future<void> verifyOtpAndRegister() async {
// //     if (!otpFormKey.currentState!.validate()) return;
// //
// //     final code = otpControllers.map((c) => c.text).join();
// //     if (code.length != 6) {
// //       showMessage("Invalid OTP", "Please enter the 6-digit code.");
// //       return;
// //     }
// //
// //     isVerifying.value = true;
// //
// //     try {
// //       // Verify OTP with Firebase
// //       final credential = PhoneAuthProvider.credential(
// //         verificationId: verificationId!,
// //         smsCode: code,
// //       );
// //
// //       await FirebaseAuth.instance.signInWithCredential(credential);
// //
// //       // Create user with email/password
// //       UserCredential userCredential = await FirebaseAuth.instance
// //           .createUserWithEmailAndPassword(
// //         email: _localEmail,
// //         password: _localPassword,
// //       );
// //
// //       // Save user data to Firestore
// //       await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(userCredential.user!.uid)
// //           .set({
// //         'name': _localName,
// //         'email': _localEmail,
// //         'phone': _finalPhoneNumber,
// //         'createdAt': FieldValue.serverTimestamp(),
// //       });
// //
// //       Get.offAllNamed('/home'); // Navigate to home on success
// //     } on FirebaseAuthException catch (e) {
// //       showMessage("Verification Failed", e.message ?? "Invalid OTP");
// //     } finally {
// //       isVerifying.value = false;
// //     }
// //   }
// //
// //   // -------------------- Cleanup --------------------
// //   @override
// //   void onClose() {
// //     for (final controller in otpControllers) {
// //       controller.dispose();
// //     }
// //     for (final node in otpFocusNodes) {
// //       node.dispose();
// //     }
// //     super.onClose();
// //   }
// // }
// //
// //
// // class LoginController extends GetxController {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //
// //   final isLoading = false.obs;
// //   final isVerifying = false.obs;
// //
// //   final passwordController = TextEditingController();
// //   final phoneController = TextEditingController();
// //
// //   final selectedCountryDialCode = '+92'.obs;
// //   final selectedCountryCode = 'PK'.obs;
// //
// //   String? verificationId;
// //
// //   String loginInput = ""; // dynamic input for phone or email
// //
// //   void setEmailOrPhone(String value) {
// //     loginInput = value.trim();
// //   }
// //
// //   void onCountryCodeChanged(String code) {
// //     selectedCountryDialCode.value = code;
// //   }
// //
// //   /// Dynamically detect email or phone and login accordingly
// //   Future<void> loginWithDynamicMethod() async {
// //     final password = passwordController.text.trim();
// //
// //     if (loginInput.isEmpty || password.isEmpty) {
// //       showMessage("Error", "Please enter all required fields.");
// //       return;
// //     }
// //
// //     isLoading.value = true;
// //
// //     // Check if email
// //     if (GetUtils.isEmail(loginInput)) {
// //       await _loginWithEmail(loginInput, password);
// //     } else {
// //       await _loginWithPhone(loginInput, password);
// //     }
// //
// //     isLoading.value = false;
// //   }
// //
// //   /// Login via Email/Password
// //   Future<void> _loginWithEmail(String email, String password) async {
// //     try {
// //       await _auth.signInWithEmailAndPassword(email: email, password: password);
// //       Get.offAllNamed('/home');
// //     } on FirebaseAuthException catch (e) {
// //       showMessage("Login Failed", e.message ?? "Invalid credentials");
// //     }
// //   }
// //
// //   /// Login via Phone Number with OTP verification
// //   Future<void> _loginWithPhone(String phone, String password) async {
// //     final fullPhone = '${selectedCountryDialCode.value}$phone';
// //
// //     try {
// //       final snapshot = await _firestore
// //           .collection('users')
// //           .where('phone', isEqualTo: fullPhone)
// //           .limit(1)
// //           .get();
// //
// //       if (snapshot.docs.isEmpty) {
// //         showMessage("User Not Found", "This phone number is not registered.");
// //         Get.toNamed('/register');
// //         return;
// //       }
// //
// //       final userData = snapshot.docs.first.data();
// //
// //       if (userData['password'] != password) {
// //         showMessage("Error", "Incorrect password.");
// //         return;
// //       }
// //
// //       await _auth.verifyPhoneNumber(
// //         phoneNumber: fullPhone,
// //         timeout: const Duration(seconds: 60),
// //         verificationCompleted: (PhoneAuthCredential credential) {},
// //         verificationFailed: (FirebaseAuthException e) {
// //           showMessage("OTP Failed", e.message ?? "Could not send OTP.");
// //         },
// //         codeSent: (String verId, int? resendToken) {
// //           verificationId = verId;
// //
// //           Get.toNamed('/otp', arguments: {
// //             'verificationId': verId,
// //             'phone': fullPhone,
// //           });
// //         },
// //         codeAutoRetrievalTimeout: (String verId) {
// //           verificationId = verId;
// //         },
// //       );
// //     } catch (e) {
// //       showMessage("Error", e.toString());
// //     }
// //   }
// //
// //   /// Final OTP Verification (called from OTP screen)
// //   Future<void> verifyOtpAndLogin(String smsCode) async {
// //     if (verificationId == null) {
// //       showMessage("Error", "Missing verification ID.");
// //       return;
// //     }
// //
// //     isVerifying.value = true;
// //
// //     try {
// //       final credential = PhoneAuthProvider.credential(
// //         verificationId: verificationId!,
// //         smsCode: smsCode,
// //       );
// //
// //       await _auth.signInWithCredential(credential);
// //
// //       Get.offAllNamed('/home');
// //     } catch (e) {
// //       showMessage("OTP Error", e.toString());
// //     } finally {
// //       isVerifying.value = false;
// //     }
// //   }
// //
// //   @override
// //   void onClose() {
// //     passwordController.dispose();
// //     phoneController.dispose();
// //     super.onClose();
// //   }
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:location/location.dart';
//
// class AuthenticationController1 extends GetxController {
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
//
//   // -------------------- SIGN UP FLOW --------------------
//   Future<void> onSignupPressed() async {
//     if (!formKey.currentState!.validate()) return;
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
//       await _auth.verifyPhoneNumber(
//         phoneNumber: _finalPhoneNumber,
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: (PhoneAuthCredential credential) {},
//         verificationFailed: (FirebaseAuthException e) {
//           showMessage("OTP Failed", e.message ?? "Phone verification error");
//         },
//         codeSent: (String verId, int? resendToken) {
//           verificationId = verId;
//           Get.toNamed('/otp_verification'); // signup OTP screen
//         },
//         codeAutoRetrievalTimeout: (String verId) {
//           verificationId = verId;
//         },
//       );
//     } catch (e) {
//       showMessage("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> verifyOtpAndRegister() async {
//     if (!otpFormKey.currentState!.validate()) return;
//
//     final code = otpControllers.map((c) => c.text).join();
//     if (code.length != 6) {
//       showMessage("Invalid OTP", "Please enter the 6-digit code.");
//       return;
//     }
//
//     isVerifying.value = true;
//
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: verificationId!,
//         smsCode: code,
//       );
//
//       await _auth.signInWithCredential(credential);
//
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: _localEmail,
//         password: _localPassword,
//       );
//
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'name': _localName,
//         'email': _localEmail,
//         'phone': _finalPhoneNumber,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       Get.offAllNamed('/home');
//     } on FirebaseAuthException catch (e) {
//       showMessage("Verification Failed", e.message ?? "Invalid OTP");
//     } catch (e) {
//       showMessage("Error", e.toString());
//     } finally {
//       isVerifying.value = false;
//     }
//   }
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
//         await _loginWithEmail(loginInput.value, passwordVal);
//       } else {
//         await _loginWithPhone(loginInput.value, passwordVal);
//       }
//     } catch (e) {
//       showMessage("Login Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> _loginWithEmail(String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       await checkUserLocationAndNavigate();
//     } on FirebaseAuthException catch (e) {
//       showMessage("Login Failed", e.message ?? "Invalid credentials");
//     }
//   }
//
//   Future<void> _loginWithPhone(String phone, String password) async {
//     final fullPhone = '${selectedCountryDialCode.value}$phone';
//
//     try {
//       final snapshot = await _firestore
//           .collection('users')
//           .where('phone', isEqualTo: fullPhone)
//           .limit(1)
//           .get();
//
//       if (snapshot.docs.isEmpty) {
//         showMessage("User Not Found", "This phone number is not registered.");
//         Get.toNamed('/register');
//         return;
//       }
//
//       final userData = snapshot.docs.first.data();
//
//       if (userData['password'] != password) {
//         showMessage("Error", "Incorrect password.");
//         return;
//       }
//
//       await _auth.verifyPhoneNumber(
//         phoneNumber: fullPhone,
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: (PhoneAuthCredential credential) {},
//         verificationFailed: (FirebaseAuthException e) {
//           showMessage("OTP Failed", e.message ?? "Could not send OTP.");
//         },
//         codeSent: (String verId, int? resendToken) {
//           verificationId = verId;
//           Get.toNamed(
//             '/otp',
//             arguments: {'verificationId': verId, 'phone': fullPhone},
//           );
//         },
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
//   }
//
//
//   // -------------------- Location Handling --------------------
//   Future<void> checkUserLocationAndNavigate() async {
//     final locationService = Location();
//
//     bool serviceEnabled = await locationService.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await locationService.requestService();
//       if (!serviceEnabled) {
//         Get.offAllNamed('/location');
//         return;
//       }
//     }
//
//     PermissionStatus permission = await locationService.hasPermission();
//     if (permission == PermissionStatus.denied) {
//       permission = await locationService.requestPermission();
//       if (permission != PermissionStatus.granted) {
//         Get.offAllNamed('/location');
//         return;
//       }
//     }
//
//     final currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       showMessage("Error", "No user is logged in.");
//       return;
//     }
//
//     final userSnapshot = await _firestore
//         .collection('users')
//         .where('email', isEqualTo: currentUser.email)
//         .where('phone', isEqualTo: currentUser.phoneNumber)
//         .limit(1)
//         .get();
//
//     if (userSnapshot.docs.isEmpty ||
//         !(userSnapshot.docs.first.data().containsKey('location'))) {
//       Get.offAllNamed('/location');
//     } else {
//       Get.offAllNamed('/home');
//     }
//   }
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
//           }
//         });
//         Get.offAllNamed('/home');
//       }
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
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// //
// // class AuthenticationController extends GetxController {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //
// //   // Form fields
// //   final name = ''.obs;
// //   final email = ''.obs;
// //   final number = ''.obs;
// //   final password = ''.obs;
// //   final confirmPassword = ''.obs;
// //   final otpCode = ''.obs;
// //
// //   // UI State
// //   final isLoading = false.obs;
// //   final isVerifying = false.obs;
// //
// //   // Form keys
// //   final formKey = GlobalKey<FormState>();
// //   final otpFormKey = GlobalKey<FormState>();
// //
// //   // Input handling
// //   final passwordController = TextEditingController();
// //   final phoneController = TextEditingController();
// //   final loginInput = ''.obs;
// //
// //   // Country code
// //   final selectedCountryDialCode = '+92'.obs;
// //   final selectedCountryCode = 'PK'.obs;
// //
// //   // OTP fields
// //   final otpControllers = List.generate(6, (_) => TextEditingController());
// //   final otpFocusNodes = List.generate(6, (_) => FocusNode());
// //
// //   // For both signup/login OTP
// //   String? verificationId;
// //
// //   // For sign up temp storage
// //   late String _localName;
// //   late String _localEmail;
// //   late String _localNumber;
// //   late String _localPassword;
// //   late String _finalPhoneNumber;
// //
// //   // Country Code Handler
// //   void onCountryCodeChanged(String dialCode) {
// //     selectedCountryDialCode.value = dialCode;
// //   }
// //
// //   // OTP input handler
// //   void onOtpChanged(String value, int index) {
// //     if (value.isNotEmpty && index < 5) {
// //       otpFocusNodes[index + 1].requestFocus();
// //     } else if (value.isEmpty && index > 0) {
// //       otpFocusNodes[index - 1].requestFocus();
// //     }
// //     otpCode.value = otpControllers.map((c) => c.text).join();
// //   }
// //
// //   // Email/Phone input setter
// //   void setEmailOrPhone(String value) {
// //     loginInput.value = value.trim();
// //   }
// //
// //   // -------------------- SIGN UP FLOW --------------------
// //   Future<void> onSignupPressed() async {
// //     if (!formKey.currentState!.validate()) return;
// //
// //     if (password.value != confirmPassword.value) {
// //       showMessage("Error", "Passwords do not match");
// //       return;
// //     }
// //
// //     _localName = name.value.trim();
// //     _localEmail = email.value.trim();
// //     _localNumber = number.value.trim();
// //     _localPassword = password.value;
// //     _finalPhoneNumber = '${selectedCountryDialCode.value}$_localNumber';
// //
// //     isLoading.value = true;
// //
// //     try {
// //       await _auth.verifyPhoneNumber(
// //         phoneNumber: _finalPhoneNumber,
// //         timeout: const Duration(seconds: 60),
// //         verificationCompleted: (PhoneAuthCredential credential) {},
// //         verificationFailed: (FirebaseAuthException e) {
// //           showMessage("OTP Failed", e.message ?? "Phone verification error");
// //         },
// //         codeSent: (String verId, int? resendToken) {
// //           verificationId = verId;
// //           Get.toNamed('/otp_verification'); // signup OTP screen
// //         },
// //         codeAutoRetrievalTimeout: (String verId) {
// //           verificationId = verId;
// //         },
// //       );
// //     } catch (e) {
// //       showMessage("Error", e.toString());
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   Future<void> verifyOtpAndRegister() async {
// //     if (!otpFormKey.currentState!.validate()) return;
// //
// //     final code = otpControllers.map((c) => c.text).join();
// //     if (code.length != 6) {
// //       showMessage("Invalid OTP", "Please enter the 6-digit code.");
// //       return;
// //     }
// //
// //     isVerifying.value = true;
// //
// //     try {
// //       final credential = PhoneAuthProvider.credential(
// //         verificationId: verificationId!,
// //         smsCode: code,
// //       );
// //
// //       await _auth.signInWithCredential(credential);
// //
// //       final userCredential = await _auth.createUserWithEmailAndPassword(
// //         email: _localEmail,
// //         password: _localPassword,
// //       );
// //
// //       await _firestore.collection('users').doc(userCredential.user!.uid).set({
// //         'name': _localName,
// //         'email': _localEmail,
// //         'phone': _finalPhoneNumber,
// //         'createdAt': FieldValue.serverTimestamp(),
// //       });
// //
// //       Get.offAllNamed('/home');
// //     } on FirebaseAuthException catch (e) {
// //       showMessage("Verification Failed", e.message ?? "Invalid OTP");
// //     } catch (e) {
// //       showMessage("Error", e.toString());
// //     } finally {
// //       isVerifying.value = false;
// //     }
// //   }
// //
// //   // -------------------- LOGIN FLOW --------------------
// //   Future<void> loginWithDynamicMethod() async {
// //     final passwordVal = passwordController.text.trim();
// //     if (loginInput.value.isEmpty || passwordVal.isEmpty) {
// //       showMessage("Error", "Please enter all required fields.");
// //       return;
// //     }
// //
// //     isLoading.value = true;
// //
// //     try {
// //       if (GetUtils.isEmail(loginInput.value)) {
// //         await _loginWithEmail(loginInput.value, passwordVal);
// //       } else {
// //         await _loginWithPhone(loginInput.value, passwordVal);
// //       }
// //     } catch (e) {
// //       showMessage("Login Error", e.toString());
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   Future<void> _loginWithEmail(String email, String password) async {
// //     try {
// //       await _auth.signInWithEmailAndPassword(email: email, password: password);
// //       Get.offAllNamed('/locaion');
// //     } on FirebaseAuthException catch (e) {
// //       showMessage("Login Failed", e.message ?? "Invalid credentials");
// //     }
// //   }
// //
// //   Future<void> _loginWithPhone(String phone, String password) async {
// //     final fullPhone = '${selectedCountryDialCode.value}$phone';
// //
// //     try {
// //       final snapshot = await _firestore
// //           .collection('users')
// //           .where('phone', isEqualTo: fullPhone)
// //           .limit(1)
// //           .get();
// //
// //       if (snapshot.docs.isEmpty) {
// //         showMessage("User Not Found", "This phone number is not registered.");
// //         Get.toNamed('/register');
// //         return;
// //       }
// //
// //       final userData = snapshot.docs.first.data();
// //
// //       if (userData['password'] != password) {
// //         showMessage("Error", "Incorrect password.");
// //         return;
// //       }
// //
// //       await _auth.verifyPhoneNumber(
// //         phoneNumber: fullPhone,
// //         timeout: const Duration(seconds: 60),
// //         verificationCompleted: (PhoneAuthCredential credential) {},
// //         verificationFailed: (FirebaseAuthException e) {
// //           showMessage("OTP Failed", e.message ?? "Could not send OTP.");
// //         },
// //         codeSent: (String verId, int? resendToken) {
// //           verificationId = verId;
// //           Get.toNamed(
// //             '/otp',
// //             arguments: {'verificationId': verId, 'phone': fullPhone},
// //           ); // login OTP screen
// //         },
// //         codeAutoRetrievalTimeout: (String verId) {
// //           verificationId = verId;
// //         },
// //       );
// //     } catch (e) {
// //       showMessage("Error", e.toString());
// //     }
// //   }
// //
// //   Future<void> verifyOtpAndLogin(String smsCode) async {
// //     if (verificationId == null) {
// //       showMessage("Error", "Missing verification ID.");
// //       return;
// //     }
// //
// //     isVerifying.value = true;
// //
// //     try {
// //       final credential = PhoneAuthProvider.credential(
// //         verificationId: verificationId!,
// //         smsCode: smsCode,
// //       );
// //
// //       await _auth.signInWithCredential(credential);
// //
// //       Get.offAllNamed('/home');
// //     } catch (e) {
// //       showMessage("OTP Error", e.toString());
// //     } finally {
// //       isVerifying.value = false;
// //     }
// //   }
// //
// //   @override
// //   void onClose() {
// //     for (final controller in otpControllers) {
// //       controller.dispose();
// //     }
// //     for (final node in otpFocusNodes) {
// //       node.dispose();
// //     }
// //     passwordController.dispose();
// //     phoneController.dispose();
// //     super.onClose();
// //   }
// // }
