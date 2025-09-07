import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../products/views/products_view.dart';
import 'views/categories_view.dart';
import 'widgets/searchbar.dart';
import '../../../widgets/custom_nav_bar.dart';
import '../controllers/home_controller.dart';
import 'widgets/custom_appbar.dart';
import 'widgets/promo_card_widget.dart';

class HomeView extends GetView<HomeController> {

   HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final ads = controller.ads;
    return Scaffold(
      appBar: HomeTopAppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                PromoCardView(),
                SizedBox(height: 10),
                CategoriesView(),
              ],
            ),
          ),
          Container(height: 10, color: AppColors.navBar),
          Padding(padding: const EdgeInsets.all(16), child: ProductsView()),
          // Obx(() {
          //   return SizedBox(
          //     height: 180,  // Set a fixed height for your horizontal list
          //     child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: ads.length,
          //       itemBuilder: (context, index) {
          //         final ad = ads[index];
          //         return Container(
          //           width: 180, // Set a fixed width for each item in the horizontal list
          //           margin: EdgeInsets.all(8),
          //           child: Column(
          //             children: [
          //               ClipRRect(
          //                 borderRadius: BorderRadius.circular(12),
          //                 child: Image.network(
          //                   ad['image_url'] ?? 'default_image_url_here',
          //                   width: 150,
          //                   height: 100,
          //                   fit: BoxFit.cover,
          //                   errorBuilder: (context, error, stackTrace) {
          //                     return Image.asset('assets/images/default_image.jpg');
          //                   },
          //                 ),
          //               ),
          //               SizedBox(height: 8),
          //               Text(ad['name'] ?? 'No name', style: TextStyle(fontWeight: FontWeight.bold)),
          //               Text('Price: ₹${ad['price']?.toString() ?? '0'}'),
          //             ],
          //           ),
          //         );
          //       },
          //     ),
          //   );
          // }),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
    );
  }
}
