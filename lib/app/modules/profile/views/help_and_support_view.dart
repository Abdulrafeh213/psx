import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/simple_appbar.dart';

class HelpAndSupportView extends GetView {
  const HelpAndSupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppbar(),
      body: const Center(
        child: Text(
          'HelpAndSupportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
