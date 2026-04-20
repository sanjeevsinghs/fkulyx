import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void show(String message) {
    if (message.trim().isEmpty) return;

    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 50,
      backgroundColor: const Color(0xFFE8F5E9),
      borderColor: const Color(0xFF66BB6A),
      borderWidth: 1,
      colorText: const Color(0xFF1B5E20),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF1B5E20),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: const Duration(seconds: 1),
      isDismissible: true,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static void showError(String s) {}
}
