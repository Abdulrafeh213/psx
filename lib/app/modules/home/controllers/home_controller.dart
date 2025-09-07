
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../../services/supabase_services.dart';
import '../../../constants/colors.dart';
import '../../../models/listing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SortMode { newest, priceLowHigh, priceHighLow }

class HomeController extends GetxController {
  final supabaseService = SupabaseService();

  // Reactive state
  final RxList<Listing> all = <Listing>[].obs;
  final RxString query = ''.obs;
  final Rx<SortMode> sort = SortMode.newest.obs;
  final RxInt visibleRows = 7.obs;
  final RxString locationName = ''.obs;
  var categories = <Map<String, dynamic>>[].obs; // RxList of maps
  var ads = <Map<String, dynamic>>[].obs; // RxList of maps
  var featuredAds = <Map<String, dynamic>>[].obs;
  var recommendedAds = <Map<String, dynamic>>[].obs; // Add this!
  final favorites = <String, RxBool>{}.obs;
  // Filtered ads after searching
  var filteredAds = <Map<String, dynamic>>[].obs;  // Filtered ads after searching
  var adsByCategory = <Map<String, dynamic>>[].obs;
  TextEditingController textEditingController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    _loadLocation();
    _bindListings();
    fetchCategories();
    fetchAds();
    fetchFeaturedAds();
    fetchRecommendedAds();
    listenToLiveAds();
  }


  // Future<void> fetchAds() async {
  //   try {
  //     isLoading.value = true;
  //     final response = await Supabase.instance.client
  //         .from('products')
  //         .select('*');
  //
  //     print("Supabase response for ads: $response");
  //
  //     ads.assignAll(
  //       (response as List<dynamic>).map((e) => Map<String, dynamic>.from(e)).toList(),
  //     );
  //
  //     print("products count: ${ads.length}");
  //   } catch (e) {
  //     print("❌ Error fetching producs: $e");
  //     ads.clear();
  //   } finally {
  //     isLoading.value = false;
  //     print("Loading finished");
  //   }
  // }
  //
  // Future<void> fetchFeaturedAds() async {
  //   try {
  //     isLoading.value = true;
  //
  //     final response = await Supabase.instance.client
  //         .from('products')
  //         .select('*')
  //         .order('created_at', ascending: false); // LIFO
  //
  //     featuredAds.assignAll(
  //       (response as List<dynamic>)
  //           .map((e) => Map<String, dynamic>.from(e))
  //           .toList(),
  //     );
  //
  //     print("📦 Featured ads fetched: ${featuredAds.length}");
  //   } catch (e) {
  //     print("❌ Error fetching featured ads: $e");
  //     featuredAds.clear();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  Future<void> fetchRecommendedAds() async {
    try {
      isLoading.value = true;

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      // 1. Get favorite product IDs
      final favoriteResponse = await Supabase.instance.client
          .from('favorite_ads')
          .select('product_id')
          .eq('user_id', userId);

      final favoriteProductIds = (favoriteResponse as List)
          .map((e) => e['product_id'] as String)
          .toList();

      // 2. Get recent search category IDs (no timestamps involved)
      final searchResponse = await Supabase.instance.client
          .from('search_history')
          .select('category_id')  // Only select category_id, no timestamp
          .eq('user_id', userId)
          .limit(5);

      final searchedCategoryIds = (searchResponse as List)
          .map((e) => e['category_id'] as String)
          .toSet();

      // 3. Combine interests: favorites + searches
      List<String> combinedInterests = [];
      combinedInterests.addAll(favoriteProductIds);
      combinedInterests.addAll(searchedCategoryIds);

      List<Map<String, dynamic>> recommendedList = [];

      if (combinedInterests.isNotEmpty) {
        // 4. Fetch recommended products based on combined interests (favorites and category searches)
        String filter = '';
        if (favoriteProductIds.isNotEmpty) {
          filter += 'id.in.(${favoriteProductIds.join(",")})';
        }
        if (searchedCategoryIds.isNotEmpty) {
          if (filter.isNotEmpty) filter += ',';
          filter += 'category_id.in.(${searchedCategoryIds.join(",")})';
        }

        final productResponse = await Supabase.instance.client
            .from('products')
            .select('*')
            .or(filter)
            .order('created_at', ascending: false);  // No timestamps from search

        recommendedList = (productResponse as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      // 5. If no recommendations or fewer than 40, fetch random ads to fill using the SQL function
      if (recommendedList.length < 40) {
        final excludeIds = recommendedList.map((ad) => ad['id'].toString()).toList();

        // Calling the rpc function to get random products
        final randomResponse = await Supabase.instance.client
            .rpc('get_random_products', params: {'exclude_ids': excludeIds});

        final randomAds = (randomResponse as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        recommendedList.addAll(randomAds);
      }

      // 6. Assign recommended ads (max 40)
      recommendedAds.assignAll(recommendedList.take(40).toList());

      print("🎯 Recommended ads fetched: ${recommendedAds.length}");
    } catch (e) {
      print("❌ Error fetching recommended ads: $e");
      recommendedAds.clear();
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchAds() async {
    try {
      isLoading.value = true;
      final response = await Supabase.instance.client
          .from('products')
          .select('*')
          .eq('ads_status', 'active');

      print("Supabase response for ads: $response");

      ads.assignAll(
        (response as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList(),
      );

      print("products count: ${ads.length}");
    } catch (e) {
      print("❌ Error fetching producs: $e");
      ads.clear();
    } finally {
      isLoading.value = false;
      print("Loading finished");
    }
  }



  // Method to filter ads based on the search query (name, category, and description)
  void filterAdsBySearch(String searchQuery) async {
    if (searchQuery.isEmpty) {
      // If search query is empty, show all ads
      filteredAds.value = ads;
    } else {
      // Convert the search query to lowercase for case-insensitive matching
      String searchLower = searchQuery.toLowerCase();

      // Fetch all categories to map category_id to category_name
      final category = await fetchCategory(); // Ensure it returns a list of categories

      // Filter the ads based on the name, category, or description
      filteredAds.value = ads.where((ad) {
        // Get the category name using the category_id
        String categoryName = category.firstWhere(
              (category) => category['id'] == ad['category_id'],
          orElse: () => {'category_name': ''},
        )['category_name']?.toLowerCase() ?? '';

        // Check if the search query matches any part of the ad's name, category, or description
        return ad['name']?.toLowerCase().contains(searchLower) == true ||
            categoryName.contains(searchLower) ||
            ad['description']?.toLowerCase().contains(searchLower) == true;
      }).toList();

      // Save the search query and relevant info to the search history table
      await saveSearchHistory(searchQuery);
    }
  }

// Fetch all categories (you should implement this according to your data source)
  // Method to fetch categories from the database
  Future<List<Map<String, dynamic>>> fetchCategory() async {
    try {
      // Execute the query to get categories
      final response = await supabase.from('categories').select('id, category_name');

      // Use response.body directly in Supabase 2.0 and above
      final category = response;
      return category;
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }


// Method to store search history
  Future<void> saveSearchHistory(String searchQuery) async {
    final userId = supabase.auth.currentUser?.id; // Get current user id

    if (userId != null && searchQuery.isNotEmpty) {
      final categoryId = await getCategoryIdFromSearchQuery(searchQuery);

      try {
        await supabase.from('search_history').insert({
          'user_id': userId,
          'keyword': searchQuery,
          'category_id': categoryId,
          'searched_at': DateTime.now().toIso8601String(),
        });
        print("Search history saved.");
      } catch (e) {
        print("Error saving search history: $e");
      }
    }
  }

// Method to determine category_id based on search query (or leave null if no category match is found)
  Future<String?> getCategoryIdFromSearchQuery(String searchQuery) async {
    // Implement logic to match search query with category, if relevant
    final category = await fetchCategory();

    // Example: If the search query matches category name, fetch the corresponding category ID
    final matchedCategory = category.firstWhere(
          (category) => category['category_name'].toLowerCase().contains(searchQuery.toLowerCase()),
      orElse: () => {},
    );

    return matchedCategory['id'];
  }

  // void fetchAdsByCategory(String categoryId) async {
  //   isLoading.value = true;
  //
  //   try {
  //     // Fetch ads from Supabase based on category_id
  //     final response = await supabase
  //         .from('products')  // Assuming the products are in the 'products' table
  //         .select('*')
  //         .eq('category_id', categoryId);  // Filter by the category_id
  //
  //     filteredAds.value = response;  // Update filtered ads list
  //
  //   } catch (e) {
  //     print('Error fetching ads: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Fetch ads by category ID from Supabase
  void fetchAdsByCategory(String categoryId) async {
    try {
      isLoading(true); // Start loading indicator
      // Query the database for ads belonging to the category
      final response = await supabase
          .from('products') // Assuming your products table is named 'products'
          .select('*')
          .eq('category_id', categoryId) ;



      final List<dynamic> data = response;

      // Update filteredAds with the fetched data
      filteredAds.value = List<Map<String, dynamic>>.from(data);
      print(filteredAds);

      isLoading(false); // Stop loading indicator
    } catch (error) {
      isLoading(false);
      print("Error fetching ads by category: $error");
    }
  }



  var isGridView = true.obs;  // Track view mode (grid or list)

  void toggleViewMode(bool isGrid) {
    isGridView.value = isGrid;
  }


  // To clear the search bar and reset filtered ads
  void clearSearch() {
    textEditingController.clear();
    filterAdsBySearch(''); // Reset the search results
  }


  bool isProductFavorite(String productId) {
    final favorite = favorites[productId];
    return favorite != null && favorite.value;
  }

  Future<void> fetchFeaturedAds() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client
          .from('products')
          .select('*')
          .eq('ads_status', 'active') // <- Filter added here
          .order('created_at', ascending: false); // LIFO

      featuredAds.assignAll(
        (response as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList(),
      );

      print("📦 Featured ads fetched: ${featuredAds.length}");
    } catch (e) {
      print("❌ Error fetching featured ads: $e");
      featuredAds.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchRecommendedAds() async {
  //   try {
  //     isLoading.value = true;
  //
  //     final userId = Supabase.instance.client.auth.currentUser?.id;
  //     if (userId == null) return;
  //
  //     // 1. Get favorite product IDs
  //     final favoriteResponse = await Supabase.instance.client
  //         .from('favorite_ads')
  //         .select('product_id')
  //         .eq('user_id', userId);
  //
  //     final favoriteProductIds = (favoriteResponse as List)
  //         .map((e) => e['product_id'] as String)
  //         .toList();
  //
  //     // 2. Get recent search category IDs (limit 5)
  //     final searchResponse = await Supabase.instance.client
  //         .from('search_history')
  //         .select('category_id')
  //         .eq('user_id', userId)
  //         .order('searched_at', ascending: false)
  //         .limit(5);
  //
  //     final searchedCategoryIds = (searchResponse as List)
  //         .map((e) => e['category_id'] as String)
  //         .toSet();
  //
  //     List<Map<String, dynamic>> recommendedList = [];
  //
  //     // 3. If no favorites and no search history, get random ads only
  //     if (favoriteProductIds.isEmpty && searchedCategoryIds.isEmpty) {
  //       final randomResponse = await Supabase.instance.client
  //           .from('products')
  //           .select('*')
  //           .eq('ads_status', 'active')
  //           .order('random()')
  //           .limit(40);
  //
  //       recommendedList = (randomResponse as List)
  //           .map((e) => Map<String, dynamic>.from(e))
  //           .toList();
  //     } else {
  //       // 4. Build filter for favorites and search categories
  //       String filter = '';
  //       if (favoriteProductIds.isNotEmpty) {
  //         filter += 'id.in.(${favoriteProductIds.join(",")})';
  //       }
  //       if (searchedCategoryIds.isNotEmpty) {
  //         if (filter.isNotEmpty) filter += ',';
  //         filter += 'category_id.in.(${searchedCategoryIds.join(",")})';
  //       }
  //
  //       // 5. Fetch recommended ads matching favorites or categories
  //       final productResponse = await Supabase.instance.client
  //           .from('products')
  //           .select('*')
  //           .eq('ads_status', 'active')
  //           .or(filter)
  //           .order('created_at', ascending: false);
  //
  //       recommendedList = (productResponse as List)
  //           .map((e) => Map<String, dynamic>.from(e))
  //           .toList();
  //
  //       // 6. If less than 40, fill with random ads excluding already fetched ads
  //       if (recommendedList.length < 40) {
  //         final excludeIds = recommendedList.map((ad) => ad['id']).toList();
  //
  //         List<Map<String, dynamic>> randomAds = [];
  //
  //         if (excludeIds.isNotEmpty) {
  //           final randomResponse = await Supabase.instance.client
  //               .from('products')
  //               .select('*')
  //               .eq('ads_status', 'active')
  //               .not('id', 'in', '(${excludeIds.join(",")})')
  //               .order('random()')
  //               .limit(40 - recommendedList.length);
  //
  //           randomAds = (randomResponse as List)
  //               .map((e) => Map<String, dynamic>.from(e))
  //               .toList();
  //         } else {
  //           final randomResponse = await Supabase.instance.client
  //               .from('products')
  //               .select('*')
  //               .eq('ads_status', 'active')
  //               .order('random()')
  //               .limit(40 - recommendedList.length);
  //
  //           randomAds = (randomResponse as List)
  //               .map((e) => Map<String, dynamic>.from(e))
  //               .toList();
  //         }
  //
  //         recommendedList.addAll(randomAds);
  //       }
  //     }
  //
  //     // 7. Limit to 40 ads max
  //     recommendedAds.assignAll(recommendedList.take(40).toList());
  //
  //     print("🎯 Recommended ads fetched: ${recommendedAds.length}");
  //
  //     // Check if recommendedAds are empty or has less than 40
  //     if (recommendedAds.length < 40) {
  //       await fetchAdditionalAds();  // This fetches more featured ads
  //     }
  //   } catch (e) {
  //     print("❌ Error fetching recommended ads: $e");
  //     recommendedAds.clear();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  // Future<void> fetchRecommendedAds() async {
  //   try {
  //     isLoading.value = true;
  //
  //     final response = await Supabase.instance.client
  //         .from('products')
  //         .select('*')
  //         .eq('ads_status', 'active') // <- Filter added here
  //         .order('created_at', ascending: false); // LIFO
  //
  //     recommendedAds.assignAll(
  //       (response as List<dynamic>)
  //           .map((e) => Map<String, dynamic>.from(e))
  //           .toList(),
  //     );
  //
  //     print("📦 Featured ads fetched: ${featuredAds.length}");
  //   } catch (e) {
  //     print("❌ Error fetching featured ads: $e");
  //     featuredAds.clear();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


//   Future<void> fetchRecommendedAds() async {
//
//     try {
//       isLoading.value = true;
//
//       final response = await Supabase.instance.client
//           .from('products')
//           .select('*')
//           .eq('ads_status', 'active')  // <- Filter added here
//           .order('created_at', ascending: true); // LIFO
//
//
//       recommendedAds.assignAll(
//         (response as List<dynamic>)
//             .map((e) => Map<String, dynamic>.from(e))
//             .toList(),
//       );
//       // recommendedAds.assignAll(recommendedAds1);
//
//       print("📦 Featured ads fetched: ${recommendedAds.length}");
//     } catch (e) {
//       print("❌ Error fetching featured ads: $e");
//       featuredAds.clear();
//     } finally {
//       isLoading.value = false;
//     }
//
//
//
//
//
// //     try {
// //       isLoading.value = true;
// //
// //       // Fetch featured ads to fill the remaining gap
// //       final response = await Supabase.instance.client
// //           .from('products')
// //           .select('*')
// //           .eq('ads_status', 'active')  // <- Filter added here
// //           .order('created_at', ascending: false); // LIFO
// //
// //       // Convert response to list and shuffle
// //       final List<Map<String, dynamic>> ads = (response as List<dynamic>)
// //           .map((e) => Map<String, dynamic>.from(e))
// //           .toList();
// //
// // // Shuffle the list to display in random order
// //       ads.shuffle();
// //
// // // Assign the shuffled list to recommendedAds
// //       recommendedAds.assignAll(ads);
// //
// //       print("📦 Featured ads fetched and shuffled: ${recommendedAds.length}");
// //     } catch (e) {
// //       print("❌ Error fetching featured ads: $e");
// //       recommendedAds.clear();  // Also clear recommendedAds in case of error
// //     } finally {
// //       isLoading.value = false;
// //     }
//   }


  void listenToLiveAds() {
    Supabase.instance.client
        .from('products')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .listen((event) {
      final newAd = Map<String, dynamic>.from(event.last);

      // Add to featured
      ads.insert(0, newAd);

      // If ad matches interest → add to recommended & notify
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null && _isAdOfUserInterest(newAd)) {
        recommendedAds.insert(0, newAd);
        _sendUserNotification(newAd);
      }
    });
  }

  bool _isAdOfUserInterest(Map<String, dynamic> ad) {
    final userCategoryIds = recommendedAds.map((e) => e['category_id']).toSet();
    return userCategoryIds.contains(ad['category_id']);
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _sendUserNotification(Map<String, dynamic> ad) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'recommended_ads_channel',
      'Recommended Ads',
      channelDescription: 'Channel for new recommended ads',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Ad: ${ad['name']}',
      'A product matching your interest is live!',
      platformChannelSpecifics,
    );
  }


  void _bindListings() {
    all.bindStream(supabaseService.listingsStream());
  }

  Future<void> _loadLocation() async {
    final location = await supabaseService.currentUserLocationName();

    if (location.isNotEmpty) {
      final parts = location.split(" ");
      // Pick last 2 or 3 words
      final lastWords = parts.length > 2
          ? parts
          .sublist(parts.length - 3)
          .join(" ") // last 3 words
          : location; // fallback if less than 3 words

      locationName.value = lastWords;
    }
  }

  void setQuery(String q) => query.value = q.trim();

  void setSort(SortMode m) => sort.value = m;

  void showMore() => visibleRows.value += 7;

  void resetPagination() => visibleRows.value = 7;

  // Filtered and paginated listings
  List<Listing> get filtered {
    final q = query.value.toLowerCase();
    var out = all
        .where((e) {
      if (q.isEmpty) return true;
      return e.title.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          (e.locationName?.toLowerCase() ?? '').contains(q);
    })
        .toList(growable: false);

    switch (sort.value) {
      case SortMode.newest:
        out.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortMode.priceLowHigh:
        out.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortMode.priceHighLow:
        out.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    return out;
  }

  List<Listing> get paged {
    final count = visibleRows.value * 2;
    final f = filtered;
    return f.take(count).toList(growable: false);
  }

  List<Listing> byCategory(String cat) =>
      all.where((e) => e.category == cat).toList(growable: false);

  List<Listing> featured() =>
      all.where((e) => e.featured).toList(growable: false);

  final isLoading = true.obs;

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await Supabase.instance.client
          .from('categories')
          .select('*');

      print("Supabase response: $response");

      categories.assignAll(
        (response as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList(),
      );

      print("Categories count: ${categories.length}");
    } catch (e) {
      print("❌ Error fetching categories: $e");
      categories.clear();
    } finally {
      isLoading.value = false;
      print("Loading finished");
    }
  }
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

}

//   final location = ''.obs;
//
//   Future<void> _loadLocation() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       location.value = '';
//       return;
//     }
//
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//
//       if (doc.exists) {
//         final data = doc.data();
//         final locationData = data?['location'];
//
//         if (locationData != null && locationData['placeName'] != null) {
//           final List<dynamic> placeList = locationData['placeName'];
//           location.value = placeList.whereType<String>().join(', ');
//           return;
//         }
//       }
//
//       location.value = ''; // fallback if not found
//     } catch (e) {
//       location.value = '';
//       // Optional: log error or use a logger
//     }
//   }
//
//
//   final FirebaseService _service = FirebaseService();
//
//   // Reactive state
//   final RxList<Listing> all = <Listing>[].obs;
//   final RxString locationName = ''.obs;
//
//   // Categories (8 items)
//   final List<CategoryItem> categories = const [
//     CategoryItem('Cars', 'assets/svgs/cars.svg'),
//     CategoryItem('Properties', 'assets/svgs/properties.svg'),
//     CategoryItem('Mobiles', 'assets/svgs/mobiles.svg'),
//     CategoryItem('Jobs', 'assets/svgs/jobs.svg'),
//     CategoryItem('MotorBikes', 'assets/svgs/motorbikes.svg'),
//     CategoryItem('Electronics', 'assets/svgs/electronics.svg'),
//     CategoryItem('Fashion', 'assets/svgs/fashion.svg'),
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadLocation();
//     // Bind realtime streams
//     ever<List<Listing>>(all, (_) {}); // keep for potential side-effects
//     // all.bindStream(_service.listingsStream());
//     // locationName.bindStream(_service.currentUserLocationName());
//   }
//
//   List<Listing> byCategory(String cat) =>
//       all.where((e) => e.category == cat).toList(growable: false);
//
//   List<Listing> featured() =>
//       all.where((e) => e.featured).toList(growable: false);
//
//
// }
//
// class CategoryItem {
//   final String name;
//   final String svgPath;
//   const CategoryItem(this.name, this.svgPath);
// }
//
//
// enum SortMode { newest, priceLowHigh, priceHighLow }
//
// class SearchController extends GetxController {
//   final FirebaseService _service = FirebaseService();
//
//   // realtime base data
//   final RxList<Listing> all = <Listing>[].obs;
//
//   // search/sort state
//   final RxString query = ''.obs;
//   final Rx<SortMode> sort = SortMode.newest.obs;
//   final RxInt visibleRows = 7.obs; // 2 items per row => visible = rows * 2
//
//   @override
//   void onInit() {
//     super.onInit();
//     // all.bindStream(_service.listingsStream());
//   }
//
//   void setQuery(String q) => query.value = q.trim();
//   void setSort(SortMode m) => sort.value = m;
//   void showMore() => visibleRows.value += 7; // +14 items
//   void resetPagination() => visibleRows.value = 7;
//
//   List<Listing> get filtered {
//     final q = query.value.toLowerCase();
//     var out = all.where((e) {
//       if (q.isEmpty) return true;
//       return e.title.toLowerCase().contains(q) ||
//           e.category.toLowerCase().contains(q) ||
//           e.locationName.toLowerCase().contains(q);
//     }).toList(growable: false);
//
//     switch (sort.value) {
//       case SortMode.newest:
//         out.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//         break;
//       case SortMode.priceLowHigh:
//         out.sort((a, b) => a.price.compareTo(b.price));
//         break;
//       case SortMode.priceHighLow:
//         out.sort((a, b) => b.price.compareTo(a.price));
//         break;
//     }
//     return out;
//   }
//
//   List<Listing> get paged {
//     final count = visibleRows.value * 2;
//     final f = filtered;
//     return f.take(count).toList(growable: false);
//   }
// }
