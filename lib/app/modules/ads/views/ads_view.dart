// import 'package:flutter/material.dart';
//
// import 'package:get/get.dart';
// import '../../../constants/colors.dart';
// import '../../../widgets/custom_nav_bar.dart';
// import '../../../widgets/simple_appbar.dart';
// import '../controllers/ads_controller.dart';
// import 'ads_details_view.dart';
// import 'widgets/ads_tile.dart';
// // import 'widgets/detail_page_widget.dart';
// import 'widgets/no_ads_widget.dart';
//
// class AdsView extends GetView<AdsController> {
//   AdsView({super.key});
//   final AdsController controller = Get.put(AdsController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const SimpleAppbar(),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Tab bar
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16.0,
//                 vertical: 10,
//               ),
//               child: Row(
//                 children: ['All', 'Active', 'Pending', 'Inactive'].map((tab) {
//                   return Expanded(
//                     child: Obx(() {
//                       final isSelected = controller.selectedTab.value == tab;
//                       return GestureDetector(
//                         onTap: () => controller.changeTab(tab),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               tab,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: isSelected
//                                     ? AppColors.primary
//                                     : AppColors.textColor,
//                               ),
//                             ),
//                             if (isSelected)
//                               Container(
//                                 margin: const EdgeInsets.only(top: 4),
//                                 height: 2,
//                                 width: 20,
//                                 color: AppColors.primary,
//                               ),
//                           ],
//                         ),
//                       );
//                     }),
//                   );
//                 }).toList(),
//               ),
//             ),
//             const Divider(height: 1),
//
//             // Expanded(
//             //   child: Obx(() {
//             //     final ads = controller.ads;
//             //
//             //     if (ads.isEmpty) {
//             //       return NoAdsWidget();
//             //     }
//             //
//             //     return ListView.builder(
//             //       padding: const EdgeInsets.only(bottom: 20),
//             //       itemCount: ads.length,
//             //       itemBuilder: (context, index) {
//             //         final ad = ads[index];
//             //         return AdsTile(
//             //           title: ad['name'] ?? '',
//             //           image: ad['image_url'] ?? 'assets/images/test1.png', // ✅ product image
//             //           price: ad['price']?.toString() ?? '0',
//             //           condition: ad['condition']?.toString() ?? 'N/A',
//             //           icon: Icons.arrow_forward_ios,
//             //           onTap: () => Get.to(() => AdsDetailsView(adData: ad)),
//             //         );
//             //
//             //       },
//             //     );
//             //   }),
//             // ),
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   // ✅ Show shimmer loader while fetching
//                   return ListView.builder(
//                     itemCount: 6,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Container(
//                           height: 90,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade300,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//
//                 final ads = controller.ads;
//
//                 if (ads.isEmpty) {
//                   return NoAdsWidget();
//                 }
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.only(bottom: 20),
//                   itemCount: ads.length,
//                   itemBuilder: (context, index) {
//                     final ad = ads[index];
//                     return AdsTile(
//                       title: ad['name'] ?? '',
//                       // ✅ Provide a Widget, not String
//                       image: (ad['image_url'] != null && ad['image_url'].toString().isNotEmpty)
//                           ? Image.network(
//                         ad['image_url'],
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Image.asset(
//                             'assets/images/test1.png',
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       )
//                           : Image.asset(
//                         'assets/images/test1.png',
//                         fit: BoxFit.cover,
//                       ),
//                       price: ad['price']?.toString() ?? '0',
//                       condition: ad['condition']?.toString() ?? 'N/A',
//                       conditionColor: controller.getConditionColor(
//                         ad['condition']?.toString() ?? '',
//                       ),
//                       icon: Icons.arrow_forward_ios,
//                       onTap: () => Get.to(() => AdsDetailsView(ad)),
//                     );
//                   },
//                 );
//
//               }),
//             ),
//
//
//           ],
//         ),
//       ),
//
//       bottomNavigationBar: const CustomNavBar(currentIndex: 3),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../services/supabase_services.dart';
import '../../../constants/colors.dart';
import '../../../widgets/cummon_search_bar.dart';
import '../../../widgets/custom_nav_bar.dart';
import '../../../widgets/simple_appbar.dart';
import '../../products/views/widgets/product_card.dart';
import '../controllers/ads_controller.dart';
import 'ads_details_view.dart';
import 'widgets/ads_tile.dart';
import 'widgets/no_ads_widget.dart';

class AdsView extends GetView<AdsController> {
  AdsView({super.key});
  final AdsController controller = Get.put(AdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppbar(),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Row(
                children: ['All', 'Active', 'Pending', 'Inactive'].map((tab) {
                  return Expanded(
                    child: Obx(() {
                      final isSelected = controller.selectedTab.value == tab;
                      return GestureDetector(
                        onTap: () => controller.changeTab(tab),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tab,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textColor,
                              ),
                            ),
                            if (isSelected)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                height: 2,
                                width: 20,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      );
                    }),
                  );
                }).toList(),
              ),
            ),

            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonSearchbar(),
            ),
            const Divider(height: 1),




            // Ad List with loading shimmer
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final ads = controller.ads;
                if (ads.isEmpty) {
                  return NoAdsWidget();
                }

                if (controller.isGridView.value) {
                  // Grid view mode
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,  // Number of columns in the grid
                      childAspectRatio: 0.75, // Aspect ratio of the grid items
                    ),
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];
                      bool isFavorite = ad['is_favorite'] ?? false; // Get the favorite status

                      return ProductTile(
                        onTap: () => Get.to(() => AdsDetailsView(ad)),
                        title: ad['name'],
                        price: ad['price']?.toString() ?? '0',
                        condition: ad['condition'] ?? 'N/A',
                        location: ad['full_address'] ?? 'N/A',
                        sellerRating: ad['seller_rating']?.toString() ?? '0',
                        date: ad['created_at'] ?? 'N/A',
                        imageUrl: ad['image_url'] ?? 'default_image_url_here',
                        productId: ad['id'],
                        isFavorite: isFavorite,
                        onFavoriteToggle: () async {
                          // Toggle favorite logic
                          if (isFavorite) {
                            // Remove from favorites
                            await supabase.from('favorite_ads').delete().eq('product_id', ad['id']);
                          } else {
                            // Add to favorites
                            await supabase.from('favorite_ads').insert({
                              'user_id': 'current_user_id', // Get the current user's ID
                              'product_id': ad['id'],
                            });
                          }

                          // Toggle the local state to reflect the change
                          controller.ads[index]['is_favorite'] = !isFavorite;
                        },
                      );
                    },
                  );
                } else {
                  // List view mode
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];
                      return AdsTile(
                        title: ad['name'] ?? '',
                        image: ad['image_url'] != null && ad['image_url'].toString().isNotEmpty
                            ? Image.network(ad['image_url'], fit: BoxFit.cover)
                            : Image.asset('assets/images/testImage.jpg', fit: BoxFit.cover),
                        price: ad['price']?.toString() ?? '0',
                        condition: ad['condition']?.toString() ?? '',
                        conditionColor: controller.getConditionColor(ad['condition']?.toString() ?? ''),
                        icon: Icons.arrow_forward_ios,
                        onTap: () => Get.to(() => AdsDetailsView(ad)),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),
    );
  }
}
