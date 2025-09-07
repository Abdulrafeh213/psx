import 'package:flutter/material.dart';

class AdDetailPage extends StatelessWidget {
  final Map<String, dynamic> adData;

  const AdDetailPage({super.key, required this.adData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(adData['title'] ?? 'Ad Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              adData['image'] ?? 'assets/images/test1.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              'Price: ${adData['price']}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Condition: ${adData['condition']}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text('Description:\n${adData['description'] ?? 'No description'}'),
          ],
        ),
      ),
    );
  }
}
