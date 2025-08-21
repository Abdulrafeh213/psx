import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LoginPhoneView extends GetView {
  const LoginPhoneView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginPhoneView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LoginPhoneView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
