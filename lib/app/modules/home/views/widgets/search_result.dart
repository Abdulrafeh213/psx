import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paksecureexchange/app/widgets/common_app_bar.dart';
import '../../../../../services/supabase_services.dart';
import '../../../products/views/widgets/ads_detailed_view.dart';
import '../../../products/views/widgets/product_card.dart';
import '../../controllers/home_controller.dart';
import 'custom_appbar.dart';

class SearchResultView extends GetView<HomeController> {
  final String categoryId;  // Add categoryId as a parameter

  SearchResultView({required this.categoryId});  // Receive categoryId in the constructor

  @override
  Widget build(BuildContext context) {
    // Fetch ads for the selected category
    controller.fetchAdsByCategory(categoryId);

    return Scaffold(
      appBar: CommonAppBar(title: 'title'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.filteredAds.isEmpty) {
          return Center(child: Text('No products found.'));
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  // Number of columns in the grid
            childAspectRatio: 0.75, // Aspect ratio of the grid items
          ),
          itemCount: controller.filteredAds.length,
          itemBuilder: (context, index) {
            final ad = controller.filteredAds[index];
            bool isFavorite = ad['is_favorite'] ?? false; // Get the favorite status

            return ProductTile(
              onTap: () => Get.to(() => AdsDetailedView(ad)),
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
                controller.filteredAds[index]['is_favorite'] = !isFavorite;
              },
            );
          },
        );
      }),
    );
  }
}
