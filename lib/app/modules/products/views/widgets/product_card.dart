// import 'package:flutter/material.dart';
//
// class ProductCard extends StatelessWidget {
//   final Map<String, dynamic> product;
//   final String categoryName;  // Add categoryName parameter
//   final bool isFavorite;
//   final VoidCallback onFavoriteToggle;
//
//   ProductCard({
//     required this.product,
//     required this.categoryName,  // Initialize categoryName
//     required this.isFavorite,
//     required this.onFavoriteToggle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to the product details page
//       },
//       child: Container(
//         width: 180,
//         margin: EdgeInsets.only(left: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: Image.network(
//                 product['image_url'] ?? 'https://via.placeholder.com/150',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product['name'] ?? 'Product Name',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text("Category: $categoryName"),  // Display category name
//                   Text("Price: ${product['price']}"),
//                   IconButton(
//                     icon: Icon(
//                       isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color: isFavorite ? Colors.red : Colors.grey,
//                     ),
//                     onPressed: onFavoriteToggle, // Toggle the favorite state
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/appFonts.dart';
import '../../controllers/products_controller.dart';

class ProductTile extends StatelessWidget {
  final String productId;
  final String title;
  final String price;
  final String condition;
  final String sellerRating;
  final String location;
  final String date;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const ProductTile({
    required this.title,
    required this.price,
    required this.condition,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.sellerRating,
    required this.productId,
    required this.onTap,
  });

  // Helper function to format the date to show only date and month
  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final formattedDate = DateFormat('dd MMM').format(parsedDate);
      return formattedDate;
    } catch (e) {
      return 'Invalid date';
    }
  }

  // Helper function to determine the color based on condition
  Color getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
        return Colors.green; // New condition
      case 'used':
        return Colors.orange; // Used condition
      case 'refurbished':
        return Colors.blue; // Refurbished condition
      default:
        return Colors.grey; // Default color for unknown conditions
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(ProductsController());
    final isFavorite = controller.isProductFavorite(productId);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
            ],
          ),
          child: Column(
            children: [
              // Stack to position the Icon above the image
              Stack(
                clipBehavior:
                    Clip.none, // Allow the icon to go outside the image container
                children: [
                  // Image Container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 145,
                      height: 120,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/default_image.jpg');
                      },
                    ),
                  ),

                  // Favorite Icon positioned above the image
                  Obx(() => Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(
                        controller.favorites[productId]?.value == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: controller.favorites[productId]?.value == true
                            ? Colors.red
                            : Colors.black,
                      ),
                      onPressed: () {
                        controller.toggleFavorite(productId);
                      },
                    ),
                  )),


                  //     Positioned(
              //       right: 0, // Move the icon to the right
              //       top: 0, // Move the icon above the image
              //       child: IconButton(
              //         icon: Icon(
              //           isFavorite ? Icons.favorite : Icons.favorite_border,
              //           color: isFavorite ? Colors.red : Colors.black,
              //         ),
              //         onPressed: () {
              //           controller.toggleFavorite(productId);
              //         },
              //       ),
              //     ),
                ],
              ),
              // Title and Price below the image
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Title with ellipsis overflow if the text is too long
                    Text(
                      title,
                      style: AppTextStyles.adsTiles,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3),
                    // Price Text with styling
                    Text(price, style: AppTextStyles.adsTiles2),
                    SizedBox(height: 3),
                    // Condition Text with color based on the condition
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Text(
                            condition,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: getConditionColor(condition),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 4,
                          child: Text(
                            '$sellerRating / 10',
                            style: AppTextStyles.adsTiles3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    // Location and Date
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.adsTiles3,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 4,
                          child: Text(
                            formatDate(date),
                            style: AppTextStyles.adsTiles3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
