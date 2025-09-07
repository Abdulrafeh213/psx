import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/colors.dart';
import '../../../widgets/simple_appbar.dart';
import '../../ads/controllers/ads_controller.dart';
import '../../ads/views/ads_details_view.dart';
import '../../ads/views/widgets/ads_tile.dart';
import '../../ads/views/widgets/no_ads_widget.dart';
import '../controllers/profile_controller.dart';
import 'widgets/ad_detail_widget.dart';
import 'widgets/shop_tile.dart';

class MyShopView extends GetView {
  MyShopView({super.key});
  final ProfileController controller = Get.put(ProfileController());
  final AdsController adsController = Get.put(AdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppbar(),
      body: SafeArea(
        child: Column(
          children: [
            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Row(
                children: ['All', 'Sell', 'Buy'].map((tab) {
                  return Expanded(
                    child: Obx(() {
                      final isSelected = adsController.selectedTab.value == tab;
                      return GestureDetector(
                        onTap: () => adsController.changeTab(tab),
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

            // 👇 Make this scrollable
            // Expanded(
            //   child: Obx(() {
            //     final ads = controller.ads;
            //
            //     if (ads.isEmpty) {
            //       return const Center(child: Text("No Ads Found"));
            //     }
            //
            //     return ListView.builder(
            //       padding: const EdgeInsets.only(bottom: 20),
            //       itemCount: ads.length,
            //       itemBuilder: (context, index) {
            //         final ad = ads[index];
            //         return ShopTile(
            //           title: ad['title'] ?? '',
            //           image: ad['image'] ?? 'assets/images/test1.png',
            //           price: ad['price'].toString(),
            //           condition: ad['condition'].toString(),
            //           icon: Icons.arrow_forward_ios,
            //           onTap: () => Get.to(() => AdDetailPage(adData: ad)),
            //         );
            //       },
            //     );
            //   }),
            // ),
            Expanded(
              child: Obx(() {
                // ✅ Show shimmer loader while fetching
                if (adsController.isLoading.value) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      height: 16,
                                      width: double.infinity,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      height: 14,
                                      width: 100,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      height: 14,
                                      width: 60,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                // ✅ After loading: show ads
                final ads = adsController.ads;

                if (ads.isEmpty) {
                  String message;

                  switch (controller.selectedTab.value.toLowerCase()) {
                    case 'buy':
                      message = "You haven't bought anything yet";
                      break;
                    case 'sell':
                      message = "You haven't sold anything yet";
                      break;
                    case 'all':
                    default:
                      message = "You have no transactions yet";
                      break;
                  }

                  return Center(
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }


                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    final ad = ads[index];
                    return AdsTile(
                      title: ad['name'] ?? '',
                      // ✅ Provide a Widget, not String
                      image: (ad['image_url'] != null && ad['image_url'].toString().isNotEmpty)
                          ? Image.network(
                        ad['image_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/testImage.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                          : Image.asset(
                        'assets/images/testImage.jpg',
                        fit: BoxFit.cover,
                      ),
                      price: ad['price']?.toString() ?? '0',
                      condition: ad['condition']?.toString() ?? 'N/A',
                      conditionColor: adsController.getConditionColor(
                        ad['condition']?.toString() ?? '',
                      ),
                      icon: Icons.arrow_forward_ios,
                      onTap: () => Get.to(() => AdsDetailsView(ad)),
                    );
                  },
                );

              }),
            ),
          ],
        ),
      ),
    );
  }
}
