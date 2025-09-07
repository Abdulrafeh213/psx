import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_button_one.dart';
import '../../../sell/views/sell_view.dart';
import '../../controllers/home_controller.dart';
import 'category_full_view.dart';

class PromoCardView extends GetView<HomeController> {
  const PromoCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/PSX-Logo.png',
                      width: 60,
                      height: 60,
                    ),
                    const Text(
                      'Enjoy additional benefit of PSX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Image.asset(
                      'assets/images/promoboxImage.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Buy car',
                  icon: Icons.shopping_cart,
                  onPressed: () {
                  },

                  BackgroundColor: AppColors.white,
                  TextColor: AppColors.textColor,
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Sell car',
                  icon: Icons.sell,
                  onPressed: () {
                    Get.to(() => SellView());
                  },
                  BackgroundColor: AppColors.white,
                  TextColor: AppColors.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
