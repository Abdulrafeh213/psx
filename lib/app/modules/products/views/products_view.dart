// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../ads/views/widgets/no_ads_widget.dart';
// import '../controllers/products_controller.dart';
// import 'widgets/product_card.dart';
//
// class ProductsView extends GetView {
//   final ProductsController controller = ProductsController();
//   ProductsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Recommended Products Section
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               "Recommended Products",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           // Horizontal Scroll for Recommended Products
//           Expanded(
//             child: Obx(() {
//               // ✅ Show shimmer loader while fetching
//               if (controller.isLoading.value) {
//                 return ListView.builder(
//                   itemCount: 6,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Row(
//                         children: [
//                           Shimmer.fromColors(
//                             baseColor: Colors.grey.shade300,
//                             highlightColor: Colors.grey.shade100,
//                             child: Container(
//                               height: 80,
//                               width: 80,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade300,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Shimmer.fromColors(
//                                   baseColor: Colors.grey.shade300,
//                                   highlightColor: Colors.grey.shade100,
//                                   child: Container(
//                                     height: 16,
//                                     width: double.infinity,
//                                     color: Colors.grey.shade300,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Shimmer.fromColors(
//                                   baseColor: Colors.grey.shade300,
//                                   highlightColor: Colors.grey.shade100,
//                                   child: Container(
//                                     height: 14,
//                                     width: 100,
//                                     color: Colors.grey.shade300,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Shimmer.fromColors(
//                                   baseColor: Colors.grey.shade300,
//                                   highlightColor: Colors.grey.shade100,
//                                   child: Container(
//                                     height: 14,
//                                     width: 60,
//                                     color: Colors.grey.shade300,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               }
//
//               // ✅ After loading: show ads
//               final ads = controller.ads;
//
//               if (ads.isEmpty) {
//                 return NoAdsWidget();
//               }
//
//               return ListView.builder(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 itemCount: ads.length,
//                 itemBuilder: (context, index) {
//                   final ad = ads[index];
//                   return ProductTile(
//                     title: ad['name'] ?? '',
//                     // ✅ Provide a Widget, not String
//                     image: (ad['image_url'] != null && ad['image_url'].toString().isNotEmpty)
//                         ? Image.network(
//                       ad['image_url'],
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Image.asset(
//                           'assets/images/testImage.jpg',
//                           fit: BoxFit.cover,
//                         );
//                       },
//                     )
//                         : Image.asset(
//                       'assets/images/testImage.jpg',
//                       fit: BoxFit.cover,
//                     ),
//                     price: ad['price']?.toString() ?? '0',
//                     condition: ad['condition']?.toString() ?? 'N/A',
//                     conditionColor: controller.getConditionColor(
//                       ad['condition']?.toString() ?? '',
//                     ),
//                     icon: Icons.arrow_forward_ios, onTap: () {  },
//                     // onTap: () => Get.to(() => AdsDetailsView(ad)),
//                   );
//                 },
//               );
//
//             }),
//           ),
//           // SizedBox(
//           //   height: 260,
//           //   child: Obx(() {
//           //     if (controller.products.isEmpty) {
//           //       return _buildShimmer(); // Show shimmer while loading
//           //     }
//           //     return ListView.builder(
//           //       scrollDirection: Axis.horizontal,
//           //       itemCount: controller.products.length,
//           //       itemBuilder: (context, index) {
//           //         final product = controller.products[index];
//           //         final isFavorite = controller.favorites.contains(product['id']);
//           //         final categoryName = controller.getCategoryNameById(product['category_id']);
//           //         return ProductCard(
//           //           product: product,
//           //           categoryName: categoryName, // Pass category name to the product card
//           //           isFavorite: isFavorite,
//           //           onFavoriteToggle: () {
//           //             controller.toggleFavorite(product['id']);
//           //           },
//           //         );
//           //       },
//           //     );
//           //   }),
//           // ),
//
//           // // Featured Products Section
//           // Padding(
//           //   padding: const EdgeInsets.all(12),
//           //   child: Text(
//           //     "Featured Products",
//           //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           //   ),
//           // ),
//           // // Horizontal Scroll for Featured Products
//           // SizedBox(
//           //   height: 260,
//           //   child: Obx(() {
//           //     if (controller.products.isEmpty) {
//           //       return _buildShimmer(); // Show shimmer while loading
//           //     }
//           //     return ListView.builder(
//           //       scrollDirection: Axis.horizontal,
//           //       itemCount: controller.products.length,
//           //       itemBuilder: (context, index) {
//           //         final product = controller.products[index];
//           //         final isFavorite = controller.favorites.contains(product['id']);
//           //         final categoryName = controller.getCategoryNameById(product['category_id']);
//           //         return ProductCard(
//           //           product: product,
//           //           categoryName: categoryName, // Pass category name to the product card
//           //           isFavorite: isFavorite,
//           //           onFavoriteToggle: () {
//           //             controller.toggleFavorite(product['id']);
//           //           },
//           //         );
//           //       },
//           //     );
//           //   }),
//           // ),
//           //
//           // // Categories Section (Show Categories)
//           // Padding(
//           //   padding: const EdgeInsets.all(12),
//           //   child: Text(
//           //     "Categories",
//           //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           //   ),
//           // ),
//           // // Loop through categories and display products under each category
//           // Obx(() {
//           //   if (controller.categories.isEmpty) {
//           //     return _buildShimmerCategories(); // Show shimmer while loading categories
//           //   }
//           //   return Column(
//           //     children: controller.categories.map((category) {
//           //       // Filter products based on category_id
//           //       final filteredProducts = controller.products
//           //           .where((product) => product['category_id'] == category['id'])
//           //           .toList();
//           //
//           //       return Column(
//           //         crossAxisAlignment: CrossAxisAlignment.start,
//           //         children: [
//           //           // Display category name
//           //           Padding(
//           //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           //             child: Text(
//           //               category['category_name'] ?? 'Category',
//           //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           //             ),
//           //           ),
//           //           // Display products under this category
//           //           SizedBox(
//           //             height: 260,
//           //             child: filteredProducts.isEmpty
//           //                 ? _buildShimmer() // Show shimmer if no products
//           //                 : ListView.builder(
//           //               scrollDirection: Axis.horizontal,
//           //               itemCount: filteredProducts.length,
//           //               itemBuilder: (context, index) {
//           //                 final product = filteredProducts[index];
//           //                 final isFavorite = controller.favorites.contains(product['id']);
//           //                 final categoryName = controller.getCategoryNameById(product['category_id']);
//           //                 return ProductCard(
//           //                   product: product,
//           //                   categoryName: categoryName, // Pass category name to the product card
//           //                   isFavorite: isFavorite,
//           //                   onFavoriteToggle: () {
//           //                     controller.toggleFavorite(product['id']);
//           //                   },
//           //                 );
//           //               },
//           //             ),
//           //           ),
//           //         ],
//           //       );
//           //     }).toList(),
//           //   );
//           // }),
//         ],
//       ),
//     );
//   }
//
//   // Shimmer Effect for Product Cards
//   Widget _buildShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 5, // Display 5 shimmer placeholders
//         itemBuilder: (context, index) {
//           return Container(
//             width: 180,
//             margin: EdgeInsets.only(left: 12),
//             color: Colors.white,
//           );
//         },
//       ),
//     );
//   }
//
//   // Shimmer Effect for Category Cards
//   Widget _buildShimmerCategories() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 5, // Display 5 shimmer placeholders for categories
//         itemBuilder: (context, index) {
//           return Container(
//             width: 120,
//             margin: EdgeInsets.only(right: 12),
//             color: Colors.white,
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/supabase_services.dart';
import '../../home/controllers/home_controller.dart';
import 'widgets/ads_detailed_view.dart';
import 'widgets/ads_with_categories.dart';
import 'widgets/features_products.dart';
import 'widgets/product_card.dart';
import 'widgets/recommended_ads.dart';

class ProductsView extends GetView<HomeController> {
  ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecommendedAds(),
        FeaturesProducts(),
        AdsWithCategories(),


        // Padding(
        //   padding: const EdgeInsets.all(12),
        //   child: Text(
        //     "Recommended Products",
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),
        // Obx(() {
        //   final ads = controller.ads;
        //
        //   return SizedBox(
        //     height: 250,
        //     child: ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       itemCount: ads.length,
        //       itemBuilder: (context, index) {
        //         final ad = ads[index];
        //
        //         bool isFavorite = ad['is_favorite'] ?? false; // Get the favorite status
        //
        //         return ProductTile(
        //          onTap: () => Get.to(() => AdsDetailedView(ad)),
        //           title: ad['name'],
        //           price: ad['price']?.toString() ?? '0',
        //           condition: ad['condition'] ?? 'N/A',
        //           location: ad['full_address'] ?? 'N/A',
        //           sellerRating: ad['seller_rating']?.toString() ?? '0',
        //           date: ad['created_at'] ?? 'N/A',
        //           imageUrl: ad['image_url'] ?? 'default_image_url_here',
        //           productId: ad['id'],
        //           isFavorite: isFavorite,
        //           onFavoriteToggle: () async {
        //             // Toggle favorite logic
        //             if (isFavorite) {
        //               // Remove from favorites
        //               await supabase.from('favorite_ads').delete().eq('product_id', ad['id']);
        //             } else {
        //               // Add to favorites
        //               await supabase.from('favorite_ads').insert({
        //                 'user_id': 'current_user_id', // Get the current user's ID
        //                 'product_id': ad['id'],
        //               });
        //             }
        //
        //             // Toggle the local state to reflect the change
        //             controller.ads[index]['is_favorite'] = !isFavorite;
        //           },
        //         );
        //       },
        //     ),
        //   );
        // }),
      ],
    );
  }
}

