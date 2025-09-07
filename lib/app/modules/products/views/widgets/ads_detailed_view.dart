import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/common_app_bar.dart';
import '../../../chats/views/chat_detail_view.dart';
import '../../controllers/products_controller.dart';

class AdsDetailedView extends StatefulWidget {
  final Map<String, dynamic> adData;
  const AdsDetailedView(this.adData, {super.key});

  @override
  State<AdsDetailedView> createState() => _AdsDetailedViewState();
}

class _AdsDetailedViewState extends State<AdsDetailedView> {
  final ProductsController controller = Get.put(ProductsController());
  final supabase = Supabase.instance.client;
  String? sellerPhone;
  bool isOfferMade = false;
  double offeredPrice = 0.0;
  late String productId;

  @override
  void initState() {
    super.initState();
    _fetchSellerPhone();
    productId = widget.adData['id'];
  }

  Future<void> _fetchSellerPhone() async {
    try {
      final response = await supabase
          .from('users')
          .select('phone')
          .eq('user_id', widget.adData['seller_id'])
          .maybeSingle();

      setState(() {
        sellerPhone = response?['phone'];
      });
    } catch (e) {
      print("❌ Error fetching phone: $e");
    }
  }

  // Function to fetch and display average rating and review count
  double getAverageRating() {
    return widget.adData['avg_rating'] ??
        0.0; // Fetch avg_rating from the adData
  }

  int getTotalReviews() {
    return widget.adData['total_reviews'] ??
        0; // Fetch total_reviews from adData
  }

  void _chatWithSeller() {
    // Get chatId and userId from the adData
    String chatId =
        widget.adData['chat_id'] ??
        'default_chat_id'; // Replace with actual field if needed
    String userId =
        widget.adData['seller_id'] ??
        'default_user_id'; // Replace with actual seller user ID

    // Navigate to the ChatDetailView screen
    Get.to(
      () => ChatDetailView(
        chatId: chatId,
        otherId: userId.toString(), // Pass the user ID as a string
      ),
    );
    print("Navigating to chat screen...");
  }

  void _makeOffer() {
    setState(() {
      isOfferMade = true;
      offeredPrice = widget.adData['price'] * 0.9;
    });
  }

  void _buyProduct() {
    // Navigate to the checkout page
    print("Buying the product with offer price: $offeredPrice");
  }

  @override
  Widget build(BuildContext context) {
    final adData = widget.adData;
    final isActive = (adData['ads_status'] ?? 'inactive') == 'active';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CommonAppBar(title: adData['name']),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child:
                    (adData['image_url'] != null &&
                        adData['image_url'].toString().isNotEmpty)
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        child: Image.network(
                          adData['image_url'],
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/testImage.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        child: Image.asset(
                          'assets/images/testImage.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Card with details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adData['name'] ?? '',

                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "PKR ${adData['price'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Description",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        adData['description'] ?? 'No description',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Full Address",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        adData['full_address'] ?? 'Not provided',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                      if (sellerPhone != null) ...[
                        Text(
                          "Seller Phone",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          sellerPhone!,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Obx(
                                () => RatingBar.builder(
                              initialRating: controller.userRating.value,
                              minRating: 0,
                              maxRating: 5,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 40.0,
                              unratedColor: Colors.grey[300],
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                final rounded = (rating * 4).round() / 4; // Allow .25 steps
                                controller.updateRating(productId, rounded.toDouble());
                              },
                            ),
                          ),
                        ),


                        const Divider(height: 32),
                        // Condition & Warranty
                        Row(
                          children: [
                            _infoChip(
                              Icons.check_circle,
                              "Condition",
                              adData['condition'] ?? 'N/A',
                            ),
                            _infoChip(
                              Icons.people,
                              "Avg. Rating",
                              adData['average_user_rating']?.toString() ??
                                  'N/A',
                            ),
                            _infoChip(
                              adData['warranty'] != null
                                  ? Icons.verified_user
                                  : Icons.cancel,
                              "Warranty",
                              adData['warranty'] ?? 'No warranty',
                            ),
                          ],
                        ),
                        // Ratings
                        Row(
                          children: [
                            _infoChip(
                              Icons.star,
                              "Seller Rating",
                              adData['seller_rating']?.toString() ?? 'N/A',
                            ),

                            _infoChip(
                              Icons.comment,
                              "Reviews",
                              adData['total_reviews']?.toString() ?? '0',
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _chatWithSeller,
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text("Chat with Seller"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isOfferMade ? _buyProduct : _makeOffer,
                icon: Icon(
                  isOfferMade ? Icons.shopping_cart : Icons.offline_bolt,
                  color: Colors.white,
                ),
                label: Text(
                  isOfferMade ? "Buy for PKR $offeredPrice" : "Make Offer",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOfferMade
                      ? AppColors.secondary
                      : AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.blueAccent),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
