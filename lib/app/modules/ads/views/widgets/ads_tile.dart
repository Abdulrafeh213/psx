import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../constants/colors.dart';

class AdsTile extends StatelessWidget {
  final String title;
  final Widget image;
  final String price;
  final String condition;
  final Color conditionColor;
  final IconData icon;
  final VoidCallback onTap;

  const AdsTile({
    super.key,
    required this.title,
    required this.image,
    required this.price,
    required this.condition,
    required this.conditionColor,
    required this.icon,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 80,
                width: 80,
                child: image,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Price: $price",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14)),
                      const SizedBox(width: 50),
                      Row(
                        children: [
                          Icon(Icons.circle,
                              size: 10, color: conditionColor),
                          const SizedBox(width: 6),
                          Text(condition,
                              style: TextStyle(
                                color: conditionColor,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(icon, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

