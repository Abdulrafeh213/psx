// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../ads/views/ads_details_view.dart';
// import '../../../ads/views/widgets/no_ads_widget.dart';
// import '../../controllers/admin_dashboard_controller.dart';
//
// class CategoryAdsView extends GetView<AdminDashboardController> {
//   final String categoryId;
//
//   CategoryAdsView({super.key, required this.categoryId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Ads in this Category')),
//       body: SafeArea(
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           final ads = controller.adsInCategory(categoryId);
//           if (ads.isEmpty) {
//             return NoAdsWidget(); // Show this widget if no ads exist in the selected category
//           }
//
//           return ListView.builder(
//             itemCount: ads.length,
//             itemBuilder: (context, index) {
//               final ad = ads[index];
//               return ListTile(
//                 title: Text(ad['name'] ?? ''),
//                 subtitle: Text(ad['price']?.toString() ?? '0'),
//                 onTap: () => Get.to(() => AdsDetailsView(ad)),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }
