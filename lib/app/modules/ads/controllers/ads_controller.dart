// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// class AdsController extends GetxController {
//   RxString selectedTab = 'All'.obs;
//   RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;
//
//   final authId = FirebaseAuth.instance.currentUser?.uid;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAds();
//   }
//
//   void changeTab(String tab) {
//     selectedTab.value = tab;
//     fetchAds();
//   }
//
//   void fetchAds() async {
//     final query = FirebaseFirestore.instance.collection('ads');
//     final snapshot = await query.where('authId', isEqualTo: authId).get();
//
//     final filtered = snapshot.docs
//         .where((doc) {
//           final status = doc['status'] ?? '';
//           if (selectedTab.value == 'All') return true;
//           return status == selectedTab.value;
//         })
//         .map((doc) => doc.data())
//         .toList();
//
//     ads.value = filtered;
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/colors.dart';

class AdsController extends GetxController {
  final supabase = Supabase.instance.client;
  String? get userId => supabase.auth.currentUser?.id;

  final allAds = <Map<String, dynamic>>[].obs;
  final ads = <Map<String, dynamic>>[].obs;
  final selectedTab = 'All'.obs;
  final isLoading = false.obs;

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _fetchAds();
    _listenForAdsChanges();
  }

  var isGridView = true.obs;  // Track view mode (grid or list)

  void toggleViewMode(bool isGrid) {
    isGridView.value = isGrid;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _fetchAds() async {
    final uid = userId;
    if (uid == null) return;

    try {
      isLoading.value = true;
      final response = await supabase.from('products').select().eq('seller_id', uid);
      allAds.value = (response as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      _applyFilter();
    } catch (e) {
      print("Error fetching ads: $e");
      ads.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    final filter = selectedTab.value.toLowerCase();
    ads.value = allAds.where((ad) {
      final status = (ad['ads_status'] ?? '').toString().toLowerCase();
      if (filter == 'all') return true;
      return status == filter;
    }).toList();
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    _applyFilter();
  }

  void _listenForAdsChanges() {
    final uid = userId;
    if (uid == null) return;

    // Supabase stream returns initial data + updates
    _subscription = supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('seller_id', uid)
        .listen((liveData) {
      print('Realtime update received: ${liveData.length} records');
      allAds.assignAll(liveData.map((e) => Map<String, dynamic>.from(e)));
      _applyFilter();
    }, onError: (err) {
      print('Realtime stream error: $err');
    });

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

  // Color getConditionColor(String condition) {
  //   switch (condition.toLowerCase()) {
  //     case 'active':
  //       return Colors.green;
  //     case 'pending':
  //       return Colors.orange;
  //     case 'inactive':
  //       return Colors.red;
  //     default:
  //       return AppColors.textColor;
  //   }
  // }
}


// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../../constants/colors.dart';
//
// class AdsController extends GetxController {
//   var ads = <Map<String, dynamic>>[].obs; // RxList of maps
//   final allAds = <Map<String, dynamic>>[].obs;   // Holds all ads fetched from Supabase
//   final selectedTab = 'all'.obs;              // Current selected tab
//   final isLoading = false.obs;
//
//
//   final supabase = Supabase.instance.client;
//   String? get userId => supabase.auth.currentUser?.id;
//   late final StreamSubscription _subscription;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAds();
//     // _listenAds();
//   }
//
//
//   Future<void> fetchAds() async {
//     try {
//       isLoading.value = true;
//       final response = await Supabase.instance.client
//           .from('products')
//           .select('*');
//
//       print("Supabase response for ads: $response");
//
//       // Store all fetched ads in a separate list
//       allAds.value = (response as List<dynamic>)
//           .map((e) => Map<String, dynamic>.from(e))
//           .toList();
//
//       // Apply current tab filter after fetch
//       applyAdFilter();
//
//       print("products count: ${ads.length}");
//     } catch (e) {
//       print("❌ Error fetching products: $e");
//       ads.clear();
//     } finally {
//       isLoading.value = false;
//       print("Loading finished");
//     }
//   }
//
//
//   void applyAdFilter() {
//     final filtered = allAds.where((ad) {
//       final status = (ad['ads_status'] ?? '').toString().toLowerCase();
//       switch (selectedTab.value.toLowerCase()) {
//         case 'active':
//           return status == 'active';
//         case 'inactive':
//           return status == 'inactive';
//         case 'pending':
//           return status == 'pending';
//         case 'all':
//           return true;
//
//         default:
//
//           return true;
//       }
//     }).toList();
//
//     ads.value = filtered;
//   }
//
//   // void onTabChanged(String tab) {
//   //   selectedTab.value = tab;
//   //   applyAdFilter();
//   // }
//
//   // void _listenAds() {
//   //   isLoading.value = true;
//   //
//   //   _subscription = Supabase.instance.client
//   //       .from('products')
//   //       .stream(primaryKey: ['id'])
//   //       .eq('seller_id', userId!) // ✅ only current seller’s ads
//   //       .listen((data) {
//   //         ads.assignAll(_applyFilter(data));
//   //         isLoading.value = false;
//   //       });
//   // }
//   //
//   // void changeTab(String tab) {
//   //   selectedTab.value = tab;
//   //   // re-filter current ads instantly
//   //   ads.assignAll(_applyFilter(ads));
//   // }
//   //
//   // List<Map<String, dynamic>> _applyFilter(List<Map<String, dynamic>> data) {
//   //   return data.where((ad) {
//   //     final status = (ad['ads_status'] ?? '').toString().toLowerCase();
//   //     switch (selectedTab.value.toLowerCase()) {
//   //       case 'active':
//   //         return status == 'active';
//   //       case 'inactive':
//   //         return status == 'inactive';
//   //       case 'pending':
//   //         return status == 'pending';
//   //       case 'all':
//   //       default:
//   //         return true;
//   //     }
//   //   }).toList();
//   // }
//   //
//   // @override
//   // void onClose() {
//   //   _subscription.cancel();
//   //   super.onClose();
//   // }
//
//   Color getConditionColor(String condition) {
//     switch (condition.toLowerCase()) {
//       case 'new':
//         return Colors.green;
//       case 'used':
//         return Colors.orange;
//       case 'refurbished':
//         return Colors.blue;
//       case 'active':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'inactive':
//         return Colors.red;
//       default:
//         return AppColors.textColor;
//     }
//   }
//
//   void changeTab(String tab) {
//     selectedTab.value = tab;
//     applyAdFilter();
//   }
//
//   // Future<void> fetchAds() async {
//   //   if (userId == null) return;
//   //
//   //   try {
//   //     isLoading.value = true;
//   //
//   //     final response = await supabase
//   //         .from('products')
//   //         .select()
//   //         .eq('seller_id', userId!);
//   //
//   //     List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
//   //       response,
//   //     );
//   //
//   //     final filtered = data.where((ad) {
//   //       final status = (ad['ads_status'] ?? '').toString().toLowerCase();
//   //       switch (selectedTab.value.toLowerCase()) {
//   //         case 'active':
//   //           return status == 'active';
//   //         case 'inactive':
//   //           return status == 'inactive';
//   //         case 'pending':
//   //           return status == 'pending';
//   //         case 'all':
//   //         default:
//   //           return true;
//   //       }
//   //     }).toList();
//   //
//   //     ads.value = filtered;
//   //   } catch (e) {
//   //     print("❌ Error fetching ads: $e");
//   //   } finally {
//   //     isLoading.value = false; // ✅ Stop loading
//   //   }
//   // }
//   // Future<void> fetchAds() async {
//   //   if (userId == null) return;
//   //
//   //   try {
//   //     isLoading.value = true;
//   //
//   //     List<Map<String, dynamic>> allData = [];
//   //
//   //     // Determine type based on selected tab
//   //     switch (selectedTab.value.toLowerCase()) {
//   //       case 'sell':
//   //         {
//   //           final response = await supabase
//   //               .from('products')
//   //               .select()
//   //               .eq('seller_id', userId!);
//   //
//   //           allData = List<Map<String, dynamic>>.from(response);
//   //         }
//   //         break;
//   //
//   //       case 'buy':
//   //         {
//   //           final response = await supabase
//   //               .from('products')
//   //               .select()
//   //               .eq('ads_status', 'pending');
//   //
//   //           allData = List<Map<String, dynamic>>.from(response);
//   //         }
//   //         break;
//   //
//   //
//   //       case 'all':
//   //       default:
//   //         {
//   //           // Fetch all products related to user (buy + sell)
//   //           final sellResponse = await supabase
//   //               .from('products')
//   //               .select()
//   //               .eq('seller_id', userId!);
//   //           final buyResponse = await supabase
//   //               .from('products')
//   //               .select()
//   //               .eq('buyer_id', userId!);
//   //
//   //           allData = [
//   //             ...List<Map<String, dynamic>>.from(sellResponse),
//   //             ...List<Map<String, dynamic>>.from(buyResponse),
//   //           ];
//   //         }
//   //         break;
//   //     }
//   //
//   //     // Optional: filter by status if needed
//   //     final filtered = allData.where((ad) {
//   //       final status = (ad['ads_status'] ?? '').toString().toLowerCase();
//   //       switch (selectedTab.value.toLowerCase()) {
//   //         case 'active':
//   //           return status == 'active';
//   //         case 'inactive':
//   //           return status == 'inactive';
//   //         case 'pending':
//   //           return status == 'pending';
//   //         default:
//   //           return true;
//   //       }
//   //     }).toList();
//   //
//   //     ads.value = filtered;
//   //   } catch (e) {
//   //     print("❌ Error fetching ads: $e");
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//
// }
