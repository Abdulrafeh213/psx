import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/appFonts.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/custom_button.dart';

class NoAdsWidget extends StatelessWidget {
  const NoAdsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/illustration.png',
              width: MediaQuery.of(context).size.width / 2,
              height: 150,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 10),
            Text(
              'you haven’t listed anything yet',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 10),
            Text(
              'let go of what you don’t use anymore',
              style: AppTextStyles.tiles,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'POST',
              onPressed: () => Get.toNamed('/sell'),
              BackgroundColor: AppColors.primary,
              TextColor: AppColors.white,
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(color: AppColors.secondary),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.6,
                        child: Text(
                          'Heavy discount on packages',
                          style: AppTextStyles.appBar,
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.6,
                        child: CustomButton(
                          text: 'VIEW Packages',
                          onPressed: () => Get.toNamed('/home'),
                          BackgroundColor: AppColors.white,
                          TextColor: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
