import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
void SnackMess(
    String head, String str, Color? color, SnackPosition? pos, IconData? icon) {
  Get.snackbar(
    head,
    str,
    snackPosition: pos,
    colorText: color,
    messageText: Text(
      str,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ),
    icon: Icon(icon, color: color),
    overlayColor: Colors.black.withOpacity(0.3),
    animationDuration: const Duration(milliseconds: 100),
    snackStyle: SnackStyle.FLOATING,
    onTap: (snack) {
      Get.back();
    },
    barBlur: 10,
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: const Text(
        'OK',
        style: TextStyle(color: Colors.black),
      ),
    ),
  );
}
