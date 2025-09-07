import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/colors.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/show_message_widget.dart';

class AdsDetailsView extends StatefulWidget {
  final Map<String, dynamic> adData;
  const AdsDetailsView(this.adData, {super.key});

  @override
  State<AdsDetailsView> createState() => _AdsDetailsViewState();
}

class _AdsDetailsViewState extends State<AdsDetailsView> {
  final supabase = Supabase.instance.client;
  String? sellerPhone;

  @override
  void initState() {
    super.initState();
    _fetchSellerPhone();
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

  Future<void> deleteAd() async {
    try {
      await supabase.from('products').delete().eq('id', widget.adData['id']);
      Get.back();
      showMessage("Deleted", "Ad deleted successfully");
    } catch (e) {
      showMessage("Error", "Failed to delete: $e");
    }
  }

  Future<void> toggleStatus() async {
    try {
      final currentStatus = widget.adData['ads_status'] ?? 'inactive';
      final newStatus = currentStatus == 'active' ? 'inactive' : 'active';

      await supabase
          .from('products')
          .update({'ads_status': newStatus})
          .eq('id', widget.adData['id']);

      Get.back();
      showMessage("Updated", "Ad marked as $newStatus");
    } catch (e) {
      showMessage("Error", "Failed to update status: $e");
    }
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

      // Bottom Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: deleteAd,
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text("Delete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
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
                onPressed: toggleStatus,
                icon: Icon(
                  isActive ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                label: Text(isActive ? "Mark Inactive" : "Mark Active"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? AppColors.secondary : AppColors.success,
                  foregroundColor: AppColors.white,
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
