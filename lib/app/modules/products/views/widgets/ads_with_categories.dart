import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paksecureexchange/app/modules/home/controllers/home_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../services/supabase_services.dart';
import '../../../home/views/widgets/category_full_view.dart';
import 'ads_detailed_view.dart';
import 'product_card.dart';

class AdsWithCategories extends GetView<HomeController> {
  AdsWithCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmer(); // Show shimmer while loading
      }

      final categories = controller.categories;
      final ads = controller.ads.toSet().toList();  // Remove duplicates

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, catIndex) {
          final category = categories[catIndex];
          final categoryId = category['id'];
          final categoryName = category['category_name'] ?? 'Unnamed';

          // Filter ads for this category and remove duplicates
          final filteredAds = ads
              .where((ad) => ad['category_id'] == categoryId)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Title with > icon button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoryName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        // Navigate to another screen (e.g., CategoryDetailScreen)
                        Get.to(() => CategoryFullView(categoryId: categoryId));
                      },
                    ),
                  ],
                ),
              ),

              // Horizontal list of ads
              SizedBox(
                height: 250,
                child: filteredAds.isEmpty
                    ? Center(child: Text("No products found in this category"))
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredAds.length,
                  itemBuilder: (context, index) {
                    final ad = filteredAds[index];
                    bool isFavorite = ad['is_favorite'] ?? false;

                    return ProductTile(
                      onTap: () => Get.to(() => AdsDetailedView(ad)),
                      title: ad['name'] ?? '',
                      price: ad['price']?.toString() ?? '0',
                      condition: ad['condition'] ?? 'N/A',
                      location: ad['full_address'] ?? 'N/A',
                      sellerRating: ad['seller_rating']?.toString() ?? '0',
                      date: ad['created_at'] ?? 'N/A',
                      imageUrl: ad['image_url'] ?? '',
                      productId: ad['id'],
                      isFavorite: isFavorite,
                      onFavoriteToggle: () async {
                        if (isFavorite) {
                          await supabase.from('favorite_ads').delete().eq('product_id', ad['id']);
                        } else {
                          await supabase.from('favorite_ads').insert({
                            'user_id': 'current_user_id',
                            'product_id': ad['id'],
                          });
                        }

                        // Update local state
                        final adIndex = controller.ads.indexWhere((a) => a['id'] == ad['id']);
                        if (adIndex != -1) {
                          controller.ads[adIndex]['is_favorite'] = !isFavorite;
                          controller.ads.refresh();
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16), // spacing between categories
            ],
          );
        },
      );
    });
  }

  // ✅ SHIMMER placeholder while loading
  Widget _buildShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer for category name
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 150,
                  height: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            // Shimmer for horizontal product list
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, _) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
