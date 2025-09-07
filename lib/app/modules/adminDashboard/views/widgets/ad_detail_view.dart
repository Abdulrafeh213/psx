// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/admin_dashboard_controller.dart';
//
// class AdDetailView extends StatelessWidget {
//   final Map<String, dynamic> ad;
//
//   const AdDetailView({super.key, required this.ad});
//
//   @override
//   Widget build(BuildContext context) {
//     final AdminDashboardController controller = Get.find();
//
//     return Scaffold(
//       appBar: AppBar(title: Text(ad["title"] ?? "Ad Detail")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ad["images"] != null && ad["images"].isNotEmpty
//                 ? Image.network(ad["images"][0], height: 200, fit: BoxFit.cover)
//                 : Image.asset(
//                     "assets/images/no_image.png",
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//             const SizedBox(height: 10),
//             Text(
//               ad["title"] ?? "",
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text("Price: Rs ${ad["price"] ?? ""}"),
//             Text("Condition: ${ad["condition"] ?? ""}"),
//             const SizedBox(height: 20),
//             Text(ad["description"] ?? "No Description"),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   onPressed: () => controller.approveAd(ad["id"], "Approved"),
//                   icon: const Icon(Icons.check_circle, color: Colors.green),
//                 ),
//                 IconButton(
//                   onPressed: () => controller.approveAd(ad["id"], "Rejected"),
//                   icon: const Icon(Icons.cancel, color: Colors.red),
//                 ),
//                 IconButton(
//                   onPressed: () => controller.approveAd(ad["id"], "Pending"),
//                   icon: const Icon(Icons.access_time, color: Colors.orange),
//                 ),
//                 IconButton(
//                   onPressed: () => controller.approveAd(ad["id"], "Featured"),
//                   icon: const Icon(Icons.star, color: Colors.blue),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
