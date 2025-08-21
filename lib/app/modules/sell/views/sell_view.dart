import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sell_controller.dart';

class SellView extends GetView<SellController> {
  const SellView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SellView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SellView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
