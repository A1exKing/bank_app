   import 'package:flutter/material.dart';
import 'package:get/get.dart';

void openSnackbar({required String status, required String text}) {
      Get.snackbar(status, text,
          snackPosition: SnackPosition.TOP,
          forwardAnimationCurve: Curves.easeIn,
          reverseAnimationCurve: Curves.easeOut,
          colorText: Colors.white,
          backgroundColor: status == "ok" ? Color(0xFF58C72C) : Color(0xffc72c41),
          duration: const Duration(seconds: 3));
    }