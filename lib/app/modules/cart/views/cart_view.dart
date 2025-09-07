import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/common_app_bar.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Cart'),
      body: const Center(
        child: Text('CartView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
