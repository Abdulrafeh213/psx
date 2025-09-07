import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paksecureexchange/app/widgets/shimmer_loading.dart';
import 'package:shimmer/shimmer.dart';
import '../../controllers/home_controller.dart';
import '../widgets/category_full_view.dart';
import '../widgets/category_tile_widget.dart';
import '../widgets/search_result.dart';

class CategoriesView extends GetView<HomeController> {
  CategoriesView({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        // Shimmer container while loading
        return ShimmerLoading();
      }

      if (controller.categories.isEmpty) {
        return ShimmerLoading();
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: List.generate(controller.categories.length, (index) {
              final category = controller.categories[index];
              final name = category['category_name'] ?? '';
              final imageUrl = category['image_url'] ?? '';
              final categoryId = category['id'] ?? '';

              return Row(
                children: [
                  CategoryTile(
                    title: name,
                    imageUrl: imageUrl,
                    // onTap: () => print("Clicked on $name"),
                    onTap: (){
                      controller.fetchAdsByCategory(categoryId);
                      Get.to(() => CategoryFullView(categoryId: category['id']));


                    },
                  ),
                  // Add width between tiles except for last tile
                  if (index != controller.categories.length - 1)
                    const SizedBox(width: 30), // adjust width here
                ],
              );
            }),
          ),
        ),
      );

    });
  }
}
