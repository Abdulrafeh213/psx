import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constants/colors.dart';

class ProductsController extends GetxController {
  final supabase = Supabase.instance.client;
  // var favorites = <String>[].obs;
  final favorites = <String, RxBool>{}.obs;

  RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  // This will hold the product data
  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;

  RxBool isLoading = true.obs;
  RxString selectedTab = 'all'.obs;
  late RealtimeChannel channel;
  // Add search logic

  // RxString selectedTab = 'All'.obs;
  // RxBool isLoading = true.obs; // ✅ added loading state
  // var ads = <Map<String, dynamic>>[].obs; // RxList of maps

  String? get userId => supabase.auth.currentUser?.id;

  late final StreamSubscription _subscription;
  RxDouble userRating = 0.0.obs;

  // Method to update the rating value
  void updateRating(String productId, double rating) async {
    userRating.value = rating;
    if (productId.isNotEmpty) {
      await addReview(productId, rating);
    }
  }



  @override
  void onInit() {
    super.onInit();
    fetchAds();
    _subscribeToAds();
    fetchAllData();
  }



  // Fetch product data including ratings and reviews
  Future<void> fetchProductData(String productId) async {
    try {
      final response = await supabase
          .from('products')
          .select('name, price, description, image_url, avg_rating, total_reviews, seller_id')
          .eq('id', productId)
          .single();

      products.add(response);
    } catch (e) {
      print("Error fetching product data: $e");
    }
  }
  Future<void> addReview(String productId, double rating) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        print("User not logged in.");
        return;
      }

      // Check if the user has already reviewed this product
      final existingReviewResponse = await supabase
          .from('product_reviews')
          .select('id')
          .eq('product_id', productId)
          .eq('user_id', userId)
          .single()
          .catchError((error) {
        // Handle case where no review exists and return null
        if (error is PostgrestException && error.code == 'PGRST116') {
          return null; // No review found, it's expected
        } else {
          throw error; // Other errors should still be thrown
        }
      });

      if (existingReviewResponse != null) {
        // If review exists, update the existing review
        await supabase
            .from('product_reviews')
            .update({
          'rating': rating,  // Update the rating
        })
            .eq('product_id', productId)
            .eq('user_id', userId);
        print("Review updated.");
      } else {
        // If no review exists, insert a new review
        await supabase.from('product_reviews').insert({
          'product_id': productId,
          'rating': rating,
          'user_id': userId,
        });
        print("Review added.");
      }

      // Get updated average and total reviews
      final response = await supabase
          .from('product_reviews')
          .select('rating')
          .eq('product_id', productId);

      final List ratings = response;
      double avgRating = 0;
      if (ratings.isNotEmpty) {
        avgRating = ratings
            .map((e) => e['rating'] as double)
            .reduce((a, b) => a + b) / ratings.length;
      }

      // Update the product table with the new average rating and total review count
      await supabase.from('products').update({
        'average_user_rating': avgRating,
        'total_reviews': ratings.length,
      }).eq('id', productId);

      // Update the product in the controller to reflect the change
      final controller = Get.find<ProductsController>();
      controller.updateProductRating(productId, avgRating);

      print("Product updated with new ratings.");
    } catch (e) {
      print("Error adding or updating review: $e");
    }
  }






  // This function updates a product's average rating
  void updateProductRating(String productId, double newAverageRating) {
    final productIndex = products.indexWhere((product) => product['id'] == productId);
    if (productIndex != -1) {
      // Update the rating and refresh the UI
      products[productIndex]['average_user_rating'] = newAverageRating; // Update the map key
      products.refresh(); // This will refresh the UI if you're using GetX or similar state management
    }

}

  void _subscribeToAds() {
    channel = supabase.channel('products-channel');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'products',
      callback: (payload) {
        print('Realtime event: ${payload.eventType}');

        final newAd = payload.newRecord != null
            ? Map<String, dynamic>.from(payload.newRecord!)
            : null;

        final oldAd = payload.oldRecord != null
            ? Map<String, dynamic>.from(payload.oldRecord!)
            : null;

        if (payload.eventType == 'INSERT' && newAd != null) {
          ads.add(newAd);
        } else if (payload.eventType == 'UPDATE' && newAd != null) {
          final index = ads.indexWhere((ad) => ad['id'] == newAd['id']);
          if (index != -1) {
            ads[index] = newAd;
          }
        } else if (payload.eventType == 'DELETE' && oldAd != null) {
          ads.removeWhere((ad) => ad['id'] == oldAd['id']);
        }
      },
    );

    channel.subscribe();
  }

  Future<void> fetchAds() async {
    try {
      isLoading.value = true;
      final response = await supabase.from('products').select();
      ads.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching ads: $e");
    } finally {
      isLoading.value = false;
    }
  }
  //   var categories = <Map<String, dynamic>>[].obs; // List to hold category data
  //   var products = <Map<String, dynamic>>[].obs; // List to hold product data
  //   var isLoading = false.obs;
  //   var hasMore = true.obs;
  //   var offset = 0.obs;
  //   final scrollController = ScrollController();
  //   var favorites = <String>{}.obs; // Set to track favorite product IDs
  //
  //   @override
  //   void onInit() {
  //     super.onInit();
  //     fetchCategories();
  //     fetchProducts();
  //   }
  //
  //   // Fetch categories from the 'categories' table
  //   Future<void> fetchCategories() async {
  //     if (isLoading.value) return; // Prevent multiple fetches at the same time
  //     isLoading.value = true;
  //
  //     try {
  //       final response = await supabase.from('categories').select();
  //       categories.assignAll(response); // Add categories data to list
  //     } catch (e) {
  //       print("Error fetching categories: $e");
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  //
  //   // Fetch products from the 'products' table
  //   Future<void> fetchProducts() async {
  //     if (isLoading.value) return; // Prevent multiple fetches at the same time
  //     isLoading.value = true;
  //
  //     try {
  //       final response = await supabase.from('products').select();
  //       products.assignAll(response); // Add products data to list
  //     } catch (e) {
  //       print("Error fetching products: $e");
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  //
  //   // Get category name based on category_id
  //   String getCategoryNameById(int categoryId) {
  //     final category = categories.firstWhere((cat) => cat['id'] == categoryId, orElse: () => {});
  //     return category.isNotEmpty ? category['category_name'] : 'Unknown';
  //   }
  //
  //   // // Fetch products based on category name (using the exact approach you provided)
  //   // Future<void> fetchProductsByCategory(String categoryName) async {
  //   //   if (isLoading.value || !hasMore.value) return;
  //   //   isLoading.value = true;
  //   //
  //   //   try {
  //   //     final query = await supabase
  //   //         .from('products')
  //   //         .select()
  //   //         .eq('category_name', categoryName); // Your exact query approach
  //   //     final allData = List<Map<String, dynamic>>.from(query);
  //   //
  //   //     if (allData.isNotEmpty) {
  //   //       products.addAll(allData); // Add fetched data to products list
  //   //     } else {
  //   //       hasMore.value = false; // No more data to fetch
  //   //     }
  //   //   } catch (e) {
  //   //     print("Error fetching products: $e");
  //   //   } finally {
  //   //     isLoading.value = false;
  //   //   }
  //   // }
  //
  //   // // Fetch more products for pagination (still using your approach)
  //   // Future<void> fetchMore({String? condition}) async {
  //   //   if (isLoading.value || !hasMore.value) return;
  //   //   isLoading.value = true;
  //   //
  //   //   try {
  //   //
  //   //     final query = await supabase
  //   //         .from('products')
  //   //         .select()
  //   //         .eq('category_name', condition); // Your exact query approach
  //   //     final fetchedData = List<Map<String, dynamic>>.from(query); // Corrected handling
  //   //
  //   //     // var query = supabase.from('products').select().range(offset.value.toInt(), (offset.value + 9).toInt());
  //   //     //
  //   //     // if (condition != null) {
  //   //     //   query = query.eq('category_name', condition); // Your exact filter approach
  //   //     // }
  //   //     //
  //   //     // final response = await query;
  //   //     // final fetchedData = List<Map<String, dynamic>>.from(response); // Corrected handling
  //   //
  //   //     if (fetchedData.isNotEmpty) {
  //   //       products.addAll(fetchedData); // Add fetched products to the list
  //   //       offset.value += fetchedData.length;
  //   //     } else {
  //   //       hasMore.value = false; // No more data
  //   //     }
  //   //   } catch (e) {
  //   //     print("Error fetching more products: $e");
  //   //   } finally {
  //   //     isLoading.value = false;
  //   //   }
  //   // }
  //   // Fetch products based on category name (Direct Approach - No Pagination)
  //   Future<void> fetchProductsByCategory(String categoryName) async {
  //     if (isLoading.value) return;
  //     isLoading.value = true;
  //
  //     try {
  //       // Direct fetch - all products for the given category
  //       final query = supabase.from('products').select();
  //
  //       // Check if the categoryName is not null before applying the filter
  //       if (categoryName.isNotEmpty) {
  //         query.eq('category_name', categoryName); // Filter by category name
  //       }
  //
  //       final response = await query; // Execute the query
  //       final fetchedData = List<Map<String, dynamic>>.from(response); // Convert response to list of maps
  //
  //       if (fetchedData.isNotEmpty) {
  //         products.addAll(fetchedData); // Add fetched data to products list
  //       } else {
  //         hasMore.value = false; // No more data to fetch
  //       }
  //     } catch (e) {
  //       print("Error fetching products: $e");
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  //
  // // Fetch all products without pagination
  //   Future<void> fetchMore({String? condition}) async {
  //     if (isLoading.value) return;
  //     isLoading.value = true;
  //
  //     try {
  //       var query = supabase.from('products').select(); // Direct fetch all products
  //
  //       // Apply the condition (category name) filter if it's not null
  //       if (condition != null && condition.isNotEmpty) {
  //         query = query.eq('category_name', condition); // Apply filter by category name
  //       }
  //
  //       final response = await query; // Query execution
  //       final fetchedData = List<Map<String, dynamic>>.from(response); // Convert response to list of maps
  //
  //       if (fetchedData.isNotEmpty) {
  //         products.addAll(fetchedData); // Add products to the list
  //       } else {
  //         hasMore.value = false; // No more data to load
  //       }
  //     } catch (e) {
  //       print("Error fetching products: $e");
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  //
  //
  //   // Fetch initial products for category (also using your approach)
  //   Future<void> fetchInitial({String? condition}) async {
  //     products.clear();  // Clear existing products
  //     offset.value = 0;  // Reset offset for fresh data
  //     hasMore.value = true;  // Set hasMore to true
  //     await fetchMore(condition: condition);  // Fetch initial set of products
  //   }
  //
  //   // Toggle favorite functionality
  //   void toggleFavorite(String productId) {
  //     if (favorites.contains(productId)) {
  //       favorites.remove(productId); // Remove from favorites
  //     } else {
  //       favorites.add(productId); // Add to favorites
  //     }
  //   }

  Color getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
        return Colors.green;
      case 'used':
        return Colors.orange;
      case 'refurbished':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'inactive':
        return Colors.red;
      default:
        return AppColors.textColor;
    }
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    fetchAds();
  }

  Future<void> fetchFavorites() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await supabase
          .from('favorite_ads')
          .select('product_id')
          .eq('user_id', userId);

      // Convert list to Map<String, RxBool>
      final favMap = <String, RxBool>{};
      for (var item in response) {
        final productId = item['product_id'];
        if (productId != null) {
          favMap[productId] = true.obs;
        }
      }

      favorites.value = favMap;
    } catch (e) {
      print("Error fetching favorites: $e");
    }
  }

  // // Fetch favorite ads for the current user
  // Future<void> fetchFavorites() async {
  //   try {
  //     final userId = supabase.auth.currentUser?.id;
  //     if (userId == null) return;
  //     final response = await supabase
  //         .from('favorite_ads')
  //         .select('product_id')
  //         .eq('user_id', userId);
  //
  //     favorites.value = List<String>.from(
  //       response.map((item) => item['product_id']),
  //     );
  //   } catch (e) {
  //     print("Error fetching favorites: $e");
  //   }
  // }
  //
  // // Toggle favorite status of a product
  // Future<void> toggleFavorite(String productId) async {
  //   final userId = supabase.auth.currentUser?.id; // Dynamically get current user id
  //   if (userId == null) {
  //     print('User not logged in');
  //     return;
  //   }
  //
  //   final isFavorite = favorites.contains(productId);
  //
  //   try {
  //     if (isFavorite) {
  //       // Remove from favorites
  //       await supabase.from('favorite_ads').delete().eq('product_id', productId).eq('user_id', userId);
  //     } else {
  //       // Add to favorites
  //       await supabase.from('favorite_ads').insert({
  //         'user_id': userId,
  //         'product_id': productId,
  //       });
  //     }
  //
  //     // After toggling, refresh the favorites list
  //     await fetchFavorites();
  //   } catch (e) {
  //     print("Error toggling favorite: $e");
  //   }
  // }

  // Check if a product is in the favorites list
  // bool isProductFavorite(String productId) {
  //   return favorites.contains(productId);
  // }


  bool isProductFavorite(String productId) {
    final favorite = favorites[productId];
    return favorite != null && favorite.value;
  }

  Future<void> toggleFavorite(String productId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print('User not logged in');
      return;
    }

    // Ensure the product has a reactive entry
    if (!favorites.containsKey(productId)) {
      favorites[productId] = false.obs;
    }

    // Toggle UI immediately
    favorites[productId]!.toggle();

    // Sync with backend
    try {
      final isNowFavorite = favorites[productId]!.value;

      if (isNowFavorite) {
        // Add to favorites
        await supabase.from('favorite_ads').insert({
          'user_id': userId,
          'product_id': productId,
        });
      } else {
        // Remove from favorites
        await supabase
            .from('favorite_ads')
            .delete()
            .eq('product_id', productId)
            .eq('user_id', userId);
      }

      // Optional: Refresh from backend to be sure
      // await fetchFavorites();
    } catch (e) {
      print("Error syncing favorite: $e");

      // Rollback local state if backend failed
      favorites[productId]!.toggle();
    }
  }

  @override
  void onClose() {
    supabase.removeChannel(channel);
    super.onClose();
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;
    try {
      final categoryResponse = await supabase.from('categories').select();
      final adsResponse = await supabase.from('products').select();

      categories.assignAll(categoryResponse);
      ads.assignAll(adsResponse);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchAds() async {
  //   try {
  //     isLoading.value = true;
  //     final response = await Supabase.instance.client
  //         .from('products')
  //         .select('*');
  //
  //     print("Supabase response: $response");
  //
  //     ads.assignAll(
  //       (response as List<dynamic>).map((e) => Map<String, dynamic>.from(e)).toList(),
  //     );
  //
  //     print("Categories count: ${ads.length}");
  //   } catch (e) {
  //     print("❌ Error fetching categories: $e");
  //     ads.clear();
  //   } finally {
  //     isLoading.value = false;
  //     print("Loading finished");
  //   }
  // }
  // Future<void> fetchAds() async {
  //   try {
  //     // Start loading
  //     isLoading.value = true;
  //     print("Starting to fetch data...");
  //
  //     // Fetch all data from 'products' table without any filters
  //     final response = await supabase.from('products').select();
  //     print("Data fetched from Supabase: $response");
  //
  //     // Check if the response contains any data
  //     if (response == null || response.isEmpty) {
  //       print("No data found.");
  //       return;
  //     }
  //
  //     // Convert the response into List<Map<String, dynamic>> format
  //     List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response);
  //     print("Converted data: $data");
  //
  //     // Store the data into ads.value
  //     ads.value = data;
  //
  //     print("All ads stored in ads.value: ${ads.value}");
  //   } catch (e) {
  //     print("Error fetching ads: $e");
  //   } finally {
  //     // Stop loading
  //     isLoading.value = false;
  //     print("Data fetching complete.");
  //   }
  // }

  //   Future<void> fetchAds() async {
  //     if (userId == null) return; // Ensure the user is logged in
  //
  //     try {
  //       isLoading.value = true; // Set loading state
  //
  //       // Fetch all products from the 'products' table
  //       final response = await supabase.from('products').select();
  //
  //
  //
  //       // If there's no error, store the fetched data into ads.value
  //       ads.value = List<Map<String, dynamic>>.from(response);
  // print(ads.value);
  //     } catch (e) {
  //       print("❌ Error fetching ads: $e");
  //     } finally {
  //       isLoading.value = false; // Set loading to false after the operation is done
  //     }
  //   }

  // Future<void> fetchAds() async {
  //   if (userId == null) return;
  //
  //   try {
  //     isLoading.value = true;
  //
  //     List<Map<String, dynamic>> allData = [];
  //
  //     final response = await supabase
  //         .from('products')
  //         .select();
  //
  //     ads.value = List<Map<String, dynamic>>.from(response);
  //
  //
  //
  //     // // Optional: filter by status if needed
  //     // final filtered = allData.where((ad) {
  //     //   final status = (ad['ads_status'] ?? '').toString().toLowerCase();
  //     //   switch (selectedTab.value.toLowerCase()) {
  //     //     case 'active':
  //     //       return status == 'active';
  //     //     case 'inactive':
  //     //       return status == 'inactive';
  //     //     case 'pending':
  //     //       return status == 'pending';
  //     //     default:
  //     //       return true;
  //     //   }
  //     // }).toList();
  //
  //     ads.value = allData;
  //   } catch (e) {
  //     print("❌ Error fetching ads: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
