import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paksecureexchange/app/widgets/common_app_bar.dart';
import '../../../../../services/supabase_services.dart';
import '../../../../widgets/cummon_search_bar.dart';
import '../../../../widgets/shimmer_loading.dart';
import '../../../../widgets/simple_appbar.dart';
import '../../../ads/views/ads_details_view.dart';
import '../../../ads/views/widgets/ads_tile.dart';
import '../../../products/views/widgets/ads_detailed_view.dart';
import '../../../products/views/widgets/product_card.dart';
import '../../controllers/home_controller.dart';
import 'custom_appbar.dart';
import '../widgets/searchbar.dart';
import 'search_result.dart';

class CategoryFullView extends GetView<HomeController> {
  final String categoryId; // Add categoryId as a parameter

  CategoryFullView({
    required this.categoryId,
  }); // Receive categoryId in the constructor

  @override
  Widget build(BuildContext context) {
    // Fetch ads for the selected category
    controller.fetchAdsByCategory(categoryId);
    return Scaffold(
      appBar: SimpleAppbar(), // Custom AppBar
      body: Column(
        children: [
          // Search Bar
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textEditingController,
                    onChanged: (query) {
                      controller.filterAdsBySearch(
                        query,
                      ); // Trigger filtering when the search query changes
                    },
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        controller.filterAdsBySearch(query);
                        Get.to(() => SearchResultView(categoryId: ''));
                      }
                    },
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Find cars, Mobile Phones, bikes, and more...',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 16.0,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.textEditingController.text.isNotEmpty)
                            IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                controller.clearSearch();
                                Get.back(); // Clear the search field
                              },
                            ),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // Row for Grid/List View Toggle
                Row(
                  children: [
                    // Grid View Icon
                    IconButton(
                      icon: Obx(() {
                        // Check if the current view is Grid view
                        return Icon(
                          Icons.grid_on,
                          color: controller.isGridView.value
                              ? Colors.blue
                              : Colors.grey,
                        );
                      }),
                      onPressed: () {
                        controller.isGridView.value =
                            true; // Switch to Grid view
                      },
                    ),
                    // List View Icon
                    IconButton(
                      icon: Obx(() {
                        // Check if the current view is List view
                        return Icon(
                          Icons.list,
                          color: !controller.isGridView.value
                              ? Colors.blue
                              : Colors.grey,
                        );
                      }),
                      onPressed: () {
                        controller.isGridView.value =
                            false; // Switch to List view
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Ads View: GridView or ListView based on isGridView
          Obx(() {
            if (controller.isLoading.value) {
              return ShimmerLoading();
            }

            if (controller.filteredAds.isEmpty) {
              return ShimmerLoading();
            }

            // GridView Layout
            if (controller.isGridView.value) {
              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.filteredAds.length,
                  itemBuilder: (context, index) {
                    final ad = controller.filteredAds[index];
                    bool isFavorite =
                        ad['is_favorite'] ?? false; // Get the favorite status

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
                          await supabase
                              .from('favorite_ads')
                              .delete()
                              .eq('product_id', ad['id']);
                        } else {
                          // Add to favorites
                          await supabase.from('favorite_ads').insert({
                            'user_id':
                                'current_user_id', // Get the current user's ID
                            'product_id': ad['id'],
                          });
                        }

                        // Toggle the local state to reflect the change
                        controller.filteredAds[index]['is_favorite'] =
                            !isFavorite;
                      },
                    );
                  },
                ),
              );
            }
            // ListView Layout
            else {
              return Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: controller.filteredAds.length,
                  itemBuilder: (context, index) {
                    final ad = controller.filteredAds[index];
                    bool isFavorite = ad['is_favorite'] ?? false;

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
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
