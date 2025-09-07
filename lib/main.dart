// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'app/routes/app_pages.dart';
// import 'firebase_options.dart';
// import 'services/service_locator.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize the selected service
//   await Services();
//   //
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // );// main.dart
//   // import 'package:flutter/material.dart';
//   // import 'package:get/get.dart';
//   // import 'app/routes/app_pages.dart';
//   // import 'services/service_locator.dart';
//   //
//   // void main() async {
//   //   WidgetsFlutterBinding.ensureInitialized();
//   //
//   //   // 🔄 Switch between Firebase & Supabase with one flag
//   //   await Services.init(useFirebase: true);
//   //
//   //   runApp(
//   //     GetMaterialApp(
//   //       debugShowCheckedModeBanner: false,
//   //       title: "PSX",
//   //       initialRoute: AppPages.initial,
//   //       getPages: AppPages.routes,
//   //     ),
//   //   );
//   // }
//   runApp(
//     GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "PSX",
//       initialRoute: AppPages.initial,
//       getPages: AppPages.routes,
//     ),
//   );
// }

// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Services.init(useFirebase: false);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PSX",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    ),
  );
}
