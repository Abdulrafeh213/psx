import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../constants/colors.dart';

class ShopTile extends StatelessWidget {
  final String title;
  final String image;
  final String condition;
  final String price;
  final IconData icon;
  final VoidCallback onTap;

  const ShopTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.image,
    required this.condition,
    required this.price,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.startsWith('http')
                  ? Image.network(
                      image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/placeholder.png',
                        width: 80,
                        height: 80,
                      ),
                    )
                  : Image.asset(
                      image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(width: 12),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      AutoSizeText(
                        "PKR $price",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.check_circle, size: 16, color: Colors.green),
                      Flexible(
                        child: AutoSizeText(
                          condition,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Icon button
            Icon(icon, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
