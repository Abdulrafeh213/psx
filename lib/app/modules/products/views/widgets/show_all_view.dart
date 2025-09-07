// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/products_controller.dart';
// import '../widgets/product_card.dart';
//
// class ShowAllView extends StatelessWidget {
//   final String? condition; // Category or condition to filter products
//   final ProductsController controller = Get.find<ProductsController>();
//
//   ShowAllView({this.condition, super.key}) {
//     controller.fetchInitial(condition: condition); // Fetch products based on category or condition
//     controller.scrollController.addListener(_onScroll);
//   }
//
//   // Handle scroll event to fetch more products when reaching the end of the list
//   void _onScroll() {
//     if (controller.scrollController.position.pixels >= controller.scrollController.position.maxScrollExtent - 200) {
//       controller.fetchMore(condition: condition);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("All Products")),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Categories Section (Horizontal Scroll)
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               "Categories",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(
//             height: 100, // Height for the category row
//             child: Obx(() {
//               if (controller.categories.isEmpty) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               return ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: controller.categories.length,
//                 itemBuilder: (context, index) {
//                   return CategoryCard(category: controller.categories[index]);
//                 },
//               );
//             }),
//           ),
//
//           // Display Products for Selected Category
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               condition != null ? "$condition Products" : "Featured Products",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//
//           // Horizontal Scroll for Products in Category
//           SizedBox(
//             height: 260,
//             child: Obx(() {
//               return ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: controller.products.length,
//                 itemBuilder: (context, index) {
//                   final product = controller.products[index];
//                   final isFavorite = controller.favorites.contains(product['id']);
//                   return ProductCard(
//                     product: product,
//                     isFavorite: isFavorite,
//                     onFavoriteToggle: () {
//                       controller.toggleFavorite(product['id']);
//                     }, categoryName: '',
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CategoryCard extends StatelessWidget {
//   final Map<String, dynamic> category;
//
//   CategoryCard({required this.category});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Fetch products when category is selected
//         Get.to(() => ShowAllView(condition: category['category_name']));
//       },
//       child: Container(
//         width: 120,
//         margin: EdgeInsets.only(right: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: Image.network(
//                 category['image_url'] ?? 'https://via.placeholder.com/150',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 category['category_name'] ?? 'Category',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
