import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LoginEmailView extends GetView {
  const LoginEmailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginEmailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LoginEmailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
