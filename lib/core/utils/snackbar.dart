import 'package:royal/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// void showSnackbar(String title, String message, {bool isError = true}) {
//   Get.snackbar(
//     title,
//     message,
//     backgroundColor: isError ? Colors.red : DarkThemeColors.primaryColor,
//     colorText: Colors.white,
//   );
// }



void showSnackbar(String title, String message,
    {bool isError = true}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed, // makes it full width at the bottom
      backgroundColor: isError ? Colors.red : Colors.green,
      content: Text(
        "$title: $message",
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      duration: const Duration(seconds: 3), // display time
    ),
  );
}
