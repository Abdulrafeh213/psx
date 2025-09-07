import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/simple_appbar.dart';

class SettingView extends GetView {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppbar(),
      body: const Center(
        child: Text('SettingView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
