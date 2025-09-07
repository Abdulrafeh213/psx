// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../../widgets/simple_appbar.dart';
// import '../../../ads/views/widgets/no_ads_widget.dart';
// import '../../controllers/admin_dashboard_controller.dart';
// import 'category_ads_view.dart';
//
// class AdminCategoriesView extends GetView<AdminDashboardController> {
//   const AdminCategoriesView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const SimpleAppbar(),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Category View Toggle (Grid/List View)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   // Grid View Icon
//                   IconButton(
//                     icon: Obx(() {
//                       return Icon(
//                         Icons.grid_on,
//                         color: controller.isGridView.value ? Colors.blue : Colors.grey,
//                       );
//                     }),
//                     onPressed: () {
//                       controller.isGridView.value = true; // Switch to Grid view
//                     },
//                   ),
//                   // List View Icon
//                   IconButton(
//                     icon: Obx(() {
//                       return Icon(
//                         Icons.list,
//                         color: !controller.isGridView.value ? Colors.blue : Colors.grey,
//                       );
//                     }),
//                     onPressed: () {
//                       controller.fetchCategories();
//                       controller.isGridView.value = false; // Switch to List view
//                     },
//                   ),
//                 ],
//               ),
//             ),
//
//
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   return Shimmer.fromColors(
//                     baseColor: Colors.grey.shade300,
//                     highlightColor: Colors.grey.shade100,
//                     child: ListView.builder(
//                       itemCount: 6, // Number of loading placeholders
//                       itemBuilder: (context, index) => Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Container(
//                           height: 100,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade300,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//
//                 // Retrieve categories
//                 final categories = controller.categories;
//
//                 // If no categories are available, display a no ads widget
//                 if (categories.isEmpty) {
//                   return NoAdsWidget();
//                 }
//
//                 // Check if GridView is enabled
//                 if (controller.isGridView.value) {
//                   return GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.75,
//                     ),
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       final category = categories[index];
//
//                       return GestureDetector(
//                         child: Card(
//                           elevation: 4,
//                           margin: const EdgeInsets.all(12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             children: [
//                               Image.network(
//                                 category['image_url'] ?? 'default_image_url_here',
//                                 fit: BoxFit.cover,
//                                 height: 100,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   category['category_name'] ?? 'Unknown',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 } else {
//                   return ListView.builder(
//                     padding: const EdgeInsets.only(bottom: 20),
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       final category = categories[index];
//
//                       return ListTile(
//                         leading: Image.network(
//                           category['image_url'] ?? 'default_image_url_here',
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         ),
//                         title: Text(category['category_name'] ?? 'Unknown'),
//                         subtitle: Text('View Ads'),
//                       );
//                     },
//                   );
//                 }
//               }),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
