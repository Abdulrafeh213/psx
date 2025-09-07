import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMessage(String title, String message, {bool isError = false}) {
  Get.dialog(
    AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: isError ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('OK')),
      ],
    ),
    barrierDismissible: false,
  );
}
